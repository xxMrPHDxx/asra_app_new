import 'dart:async';
import 'dart:math';

import 'package:asra_app_new/error.dart';
import 'package:asra_app_new/models/job.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class TrackingPage extends StatefulWidget {
  final Job job;
  final List<Job> subJobs;
  const TrackingPage({
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

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  void _getLocation() async {
    _markerIcons.add(await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
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
        double angle = atan2(pos.latitude - lastY, pos.longitude - lastY) * 180 / pi;
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
    } catch (e) {
      Fluttertoast.showToast(msg: e is Error ? e.message : e.toString());
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: _position, zoom: 17),
        // onMapCreated: (controller) {
        //   _controller = controller;
        // },
        markers: {
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
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
