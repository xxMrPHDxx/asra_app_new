import 'package:asra_app_new/widgets/memo.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:asra_app_new/api.dart';
import 'package:asra_app_new/pages/home.dart';
import 'package:asra_app_new/models/job.dart';
import 'package:asra_app_new/error.dart';
import 'package:asra_app_new/widgets/job_offers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socket_io_client/socket_io_client.dart' as sio;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class _Info {
  String profilePic = '';
  String name = '';
}

class OffersPage extends StatefulWidget {
  final LoginData login;
  final String authToken;

  const OffersPage(this.login, this.authToken, {Key? key}) : super(key: key);

  @override
  State<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  final _info = _Info();
  final df = DateFormat('d MMM, yyyy hh:mm a');
  bool _busy = true;
  final Map<int, Job> _bookings = {};
  final Map<String, List<Job>> _dailyUse = {};
  late final sio.Socket _socket;

  @override
  void initState() {
    super.initState();
    Future.wait([_getJobOffers(), _getInfo()]).then(
      (value) => setState(() {
        _busy = false;
      }),
    );
    _socket = sio.io(
      'http://103.18.244.31:3000',
      sio.OptionBuilder().setTransports(['websocket']).enableForceNew().build(),
    );
    _socket.on('update_bookings', (drivers_) async {
      final drivers = drivers_ as List;
      if (!drivers.contains(widget.login.id)) return;
      if (mounted) {
        setState(() {
          _busy = true;
        });
        await _getJobOffers();
      }
    });
  }

  Future<void> _getJobOffers() async {
    final response = await Api.json.get('/driver/offers', {
      'Authorization': 'Bearer ${widget.authToken}',
    });
    if (!response['success']) {
      Fluttertoast.showToast(msg: 'Error: ${response['message']}');
    } else {
      setState(() {
        _bookings.clear();
        for (final booking in response['offers']) {
          int id = booking['item_id'];
          final job = Job(
            booking['order_id'],
            id,
            booking['service_id'],
            booking['quotation_id'],
            booking['order_type'],
            booking['customer_name'],
            booking['status'] ?? 'N/A',
            booking['place_from'] ?? 'N/A',
            booking['place_to'] ?? 'N/A',
            DateTime.parse(booking['date_from']),
            DateTime.parse(booking['date_to']),
            price: double.parse(booking['price']),
            flightNumber: booking['flight_number'],
            etd: DateTime.tryParse(booking['etd'] ?? ''),
            eta: DateTime.tryParse(booking['eta'] ?? ''),
            subJob: booking['sub_id'],
            fromLat: double.tryParse(booking['lat_from'] ?? '') ?? 0,
            fromLon: double.tryParse(booking['lon_from'] ?? '') ?? 0,
            toLat: double.tryParse(booking['lat_to'] ?? '') ?? 0,
            toLon: double.tryParse(booking['lon_to'] ?? '') ?? 0,
            request: booking['request'] ?? '-',
            note: booking['note'] ?? '-',
          );
          if (job.typeId == 3) {
            if (_dailyUse.containsKey(job.quotationId)) {
              _dailyUse[job.quotationId]!.add(job);
            } else {
              _dailyUse[job.quotationId] = [job];
            }
          } else {
            _bookings[id] = job;
          }
        }
        _busy = false;
      });
    }
  }

  Future<void> _getInfo() async {
    final path = widget.login.type == 'host' ? '/host' : '/driver';
    final response = await Api.json.get(path, {
      'Authorization': 'Bearer ${widget.authToken}',
    });
    if (response['success']) {
      final info = response['info'];
      setState(() {
        _info.profilePic = info['profile_pic'] ?? '';
        _info.name = info['name'];
      });
    } else {
      Fluttertoast.showToast(msg: '[Error]: ${response["message"]}');
    }
  }

  void _acceptJob(final Job booking) async {
    setState(() => _busy = true);
    try {
      final response = await Api.json.get(
        '/orders/${booking.orderId}/${booking.itemId}/accept',
        {
          'Authorization': 'Bearer ${widget.authToken}',
        },
      );
      if (!response['success']) {
        throw Error(response['message']);
      }
      Fluttertoast.showToast(msg: 'Successfully accepted the job!');
      setState(() {
        booking.orderStatus = 'A';
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Error: ${e is Error ? e.message : e.toString()}');
    }
    setState(() => _busy = false);
  }

  void _cancelJob(Job booking) async {
    setState(() {
      _busy = true;
    });
    try {
      final response = await Api.json.get(
        '/orders/${booking.orderId}/${booking.itemId}/cancel',
        {
          'Authorization': 'Bearer ${widget.authToken}',
        },
      );
      if (!response['success']) {
        throw Error(response['message']);
      }
      Fluttertoast.showToast(msg: 'Successfully cancelled the job!');
      setState(() {
        booking.orderStatus = 'P';
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Error: ${e is Error ? e.message : e.toString()}');
    }
    setState(() {
      _busy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: SizedBox.square(
                    dimension: 48,
                    child: Image.network(
                      Api.link('/${_info.profilePic}'),
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 100,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Hi, ${_info.name.toUpperCase()}!',
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  MemoViewer(authToken: widget.authToken),
                  const SizedBox(height: 10),
                  JobOffersWidget(
                    bookings: _bookings,
                    dailyUsed: _dailyUse,
                    onAccept: _acceptJob,
                    onCancel: _cancelJob,
                    busy: _busy,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _socket.close();
    super.dispose();
  }
}
