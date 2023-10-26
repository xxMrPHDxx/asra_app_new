import 'dart:async';
import 'dart:math';

import 'package:asra_app_new/api.dart';
import 'package:asra_app_new/error.dart';
import 'package:asra_app_new/models/job.dart';
import 'package:asra_app_new/utils/polyline.dart';
import 'package:callkeep/callkeep.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';

class TrackingPage extends StatefulWidget {
  final String authToken;
  final Job job;
  final List<Job> subJobs;
  const TrackingPage({
    required this.authToken,
    required this.job,
    required this.subJobs,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  bool _loading = true;
  late final LatLng _position;
  late final StreamSubscription<LocationData> _subscription;
  final _location = Location();
  late Marker _marker;
  late BitmapDescriptor _driverIcon;
  // late GoogleMapController _controller;
  final List<BitmapDescriptor> _markerIcons = [];
  late double lastX, lastY;

  final List<LatLng> _waypoints = [];
  late final Timer _routeTimer;
  int _activeRoute = 0;
  Polyline? _route;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _getLocationAndRoutes() async {
    final start = LatLng(widget.job.fromLat, widget.job.fromLon);
    final finish = LatLng(widget.job.toLat, widget.job.toLon);
    _waypoints.add(start);
    _waypoints
        .addAll(widget.subJobs.map((job) => LatLng(job.toLat, job.toLon)));
    _waypoints.add(finish);
    final coords = await getRoutesBetweenPoints(
      widget.authToken,
      start,
      finish,
    );
    _route = Polyline(
      width: 10,
      polylineId: const PolylineId('main'),
      color: Colors.redAccent.shade200,
      points: coords,
    );

    _markerIcons.add(await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size.fromWidth(12)),
      'assets/markers/start.png',
    ));
    for (int i = 1; i <= 6; i++) {
      _markerIcons.add(
        await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(),
          'assets/markers/marker_$i.png',
        ),
      );
    }
    _markerIcons.add(await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      'assets/markers/finish.png',
    ));
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        if (!await _location.requestService()) {
          throw const Error('Failed to request location service!');
        }
      }
      PermissionStatus permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        if (await _location.requestPermission() != PermissionStatus.granted) {
          throw const Error('Location permission denied!');
        }
      }
      final loc = await _location.getLocation();
      _driverIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty,
        'assets/markers/car.png',
      );
      setState(() {
        _position = LatLng(loc.latitude!, loc.longitude!);
        lastX = loc.latitude!;
        lastY = loc.longitude!;
        _marker = Marker(
          markerId: const MarkerId('driver_pos'),
          icon: _driverIcon,
          position: _position,
        );
      });
      _subscription = _location.onLocationChanged.listen((loc) {
        final pos = LatLng(loc.latitude!, loc.longitude!);
        double angle =
            atan2(pos.latitude - lastY, pos.longitude - lastY) * 180 / pi;
        lastX = pos.latitude;
        lastY = pos.longitude;
        // _controller.moveCamera(CameraUpdate.newLatLng(pos));
        setState(() {
          _marker = Marker(
            markerId: const MarkerId('driver_pos'),
            icon: _driverIcon,
            position: pos,
            anchor: const Offset(0.5, 0.5),
            rotation: 180 + angle,
          );
        });
      });

      _routeTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
        if (widget.job.dateFrom.isBefore(DateTime.now())) return;
        final pos = _waypoints[_activeRoute];
        final dLat = _position.latitude - pos.latitude;
        final dLon = _position.longitude - pos.longitude;
        final dist = sqrt(dLat * dLat + dLon * dLon);
        if (_activeRoute < _waypoints.length - 1 && dist < 0.00001) {
          setState(() => _activeRoute++);
        }

        // Calculating routes
        final coords = await getRoutesBetweenPoints(
          widget.authToken,
          _position,
          pos,
          _waypoints.sublist(1, _waypoints.length - 1),
        );
        setState(() {
          Fluttertoast.showToast(msg: 'Updating route...');
          _route = Polyline(
            width: 10,
            polylineId: const PolylineId('main'),
            color: Colors.green,
            points: coords,
          );
        });
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e is Error ? e.message : e.toString());
    }
    setState(() {
      _loading = false;
    });
  }

  Future<String> _getEmergencyNumber(String token) async {
    try {
      final res = await Api.json.get(
        '/driver',
        {'Authorization': 'Bearer $token'},
      );
      if (!res['success']) throw Exception(res['message']);
      final info = res['info'];
      return info['emergency_number'];
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: SingleChildScrollView(
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.stretch,
    //       children:
    //           _routes.first.points.map((e) => Text(e.toString())).toList(),
    //     ),
    //   ),
    // );
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.job.fromLat,
            widget.job.fromLon,
          ),
          zoom: 17,
        ),
        onMapCreated: (controller) async {
          // _controller = controller;
          await _getLocationAndRoutes();
        },
        polylines: {
          if (_route != null) _route!,
        },
        markers: _loading
            ? const {}
            : {
                _marker,
                Marker(
                  markerId: const MarkerId('start'),
                  position: LatLng(
                    widget.job.fromLat,
                    widget.job.fromLon,
                  ),
                  icon: _markerIcons.first,
                ), // Start
                Marker(
                  markerId: const MarkerId('end'),
                  position: LatLng(
                    widget.job.toLat,
                    widget.job.toLon,
                  ),
                  icon: _markerIcons.last,
                ), // End
                ...List.generate(
                  widget.subJobs.length,
                  (i) {
                    final job = widget.subJobs[i];
                    return Marker(
                      markerId: MarkerId('sub#${job.itemId}'),
                      position: LatLng(
                        job.toLat,
                        job.toLon,
                      ),
                      icon: _markerIcons[i + 1],
                    );
                  },
                )
              },
      ),
      floatingActionButton: SizedBox.square(
        dimension: 64,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: ClipOval(
            child: TextButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.yellow),
              ),
              onPressed: () async {
                final number = await _getEmergencyNumber(widget.authToken);
                if (!RegExp(r'^01\d{8,9}$').hasMatch(number)) {
                  Fluttertoast.showToast(msg: 'Invalid phone number!');
                  return;
                }
                final callKeep = FlutterCallkeep();
                final callSetup = <String, dynamic>{
                  'ios': {
                    'appName': 'CallKeepDemo',
                  },
                  'android': {
                    'alertTitle': 'Permissions required',
                    'alertDescription':
                        'This application needs to access your phone accounts',
                    'cancelButton': 'Deny',
                    'okButton': 'Allow',
                    // Required to get audio in background when using Android 11
                    'foregroundService': {
                      'channelId': 'asra.app.driver',
                      'channelName': 'ASRA Driver Caller ID',
                      'notificationTitle': 'You are currently on call',
                      'notificationIcon': 'assets/logo-sm.png',
                    },
                  },
                };
                if (mounted) callKeep.setup(context, callSetup);
                await callKeep.startCall(
                  const Uuid().v4(),
                  number,
                  'Driver',
                );
                // launchUrlString('tel://$emergencyNumber');
              },
              child: const Icon(
                Icons.phone,
                color: Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    _routeTimer.cancel();
    super.dispose();
  }
}
