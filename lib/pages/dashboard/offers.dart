import 'package:asra_app_new/utils/colors.dart';
import 'package:asra_app_new/utils/custom_style.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:asra_app_new/api.dart';
import 'package:asra_app_new/pages/home.dart';
import 'package:asra_app_new/models/job.dart';
import 'package:asra_app_new/error.dart';
import 'package:socket_io_client/socket_io_client.dart' as sio;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

const serviceIcons = {
  1: FontAwesomeIcons.plane,
  3: FontAwesomeIcons.calendar,
  8: FontAwesomeIcons.city,
  4: FontAwesomeIcons.mapLocation,
};

class OffersPage extends StatefulWidget {
  final LoginData login;
  final String authToken;

  const OffersPage(this.login, this.authToken, {Key? key}) : super(key: key);

  @override
  State<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  final df = DateFormat('d MMM, yyyy hh:mm a');
  bool _busy = true;
  final Map<int, Job> _bookings = {};
  final Map<String, List<Job>> _dailyUse = {};
  late final sio.Socket _socket;

  @override
  void initState() {
    super.initState();
    _getJobOffers();
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
    final response = await Api.get('/driver/offers', {
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

  void _acceptJob(final Job booking) async {
    setState(() => _busy = true);
    try {
      final response = await Api.get(
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
      final response = await Api.get(
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
    if (_busy) return const Center(child: CircularProgressIndicator());
    if (_bookings.isEmpty) {
      return Center(
        child: Text(
          'No job offers!',
          style: CustomStyle.defaultStyle,
        ),
      );
    }
    final parentJobs = _bookings.values
        .where(
            (job) => job.typeId != 3 && (job.subJob == null || job.subJob == 0))
        .toList(growable: false);
    final keys = _dailyUse.keys.toList();
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView.builder(
        itemCount: parentJobs.length + _dailyUse.length,
        itemBuilder: (ctx, idx) {
          final parentJob = idx >= _dailyUse.length
              ? parentJobs[idx - _dailyUse.length]
              : _dailyUse[keys[idx]]!.first;
          List<Job>? subjobs;
          List<Job>? jobs;
          final String path;
          final double totalprice;
          if (parentJob.typeId == 3) {
            totalprice = _dailyUse[parentJob.quotationId]!
                .fold(0, (a, b) => a + b.price);
            path = 'Not implemented!';
          } else {
            subjobs = _bookings.values
                .where((job) => parentJob.typeId == 3
                    ? (job != parentJob &&
                        job.quotationId == parentJob.quotationId)
                    : job.subJob == parentJob.itemId)
                .toList(growable: false);
            totalprice = parentJob.price +
                subjobs.fold<double>(0, (s, job) => s + job.price);
            jobs = [
              // parentJob,
              ...subjobs,
              // if (parentJob.placeTo != null) parentJob.placeTo,
            ];
            path = [
              parentJob.placeFrom,
              ...subjobs.map((job) => '${job.request.substring(0, 8)}...'),
              if (parentJob.placeTo != null) parentJob.placeTo,
            ].join(' \u27a1 ');
          }
          final price = totalprice.toStringAsFixed(2);
          final paths = [
            parentJob.placeFrom,
            if (subjobs != null) ...subjobs.map((j) => j.request),
            parentJob.placeTo,
          ];
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: CustomColor.secondaryColor,
                border: Border.all(style: BorderStyle.none),
                boxShadow: [
                  BoxShadow(
                    color: CustomColor.secondaryColor.withOpacity(0.7),
                    blurRadius: 2,
                    offset: const Offset(3, 3),
                  ),
                ],
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Padding(
                // padding: const EdgeInsets.all(10),
                padding: EdgeInsets.zero,
                child: ExpansionTile(
                  controlAffinity: ListTileControlAffinity.trailing,
                  collapsedIconColor: CustomColor.accentColor,
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: EdgeInsets.zero,
                  expandedAlignment: Alignment.centerLeft,
                  shape: Border.all(style: BorderStyle.none),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (![5, 6, 7].contains(parentJob.typeId))
                              // SvgPicture.asset(
                              //     height: 30,
                              //     'assets/svg/cheuffeur.svg',
                              //     colorFilter: const ColorFilter.mode(
                              //       CustomColor.accentColor,
                              //       BlendMode.srcIn,
                              //     ),
                              //   )
                              // :
                              Icon(
                                serviceIcons[parentJob.typeId],
                                color: CustomColor.accentColor,
                              ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${parentJob.orderType}\t',
                                  style: CustomStyle.defaultStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: CustomColor.accentColor,
                                  ),
                                ),
                                TextSpan(
                                  text: '(${parentJob.itemId})',
                                  style: CustomStyle.defaultStyle.copyWith(
                                    color: CustomColor.accentColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (parentJob.typeId != 3) const SizedBox(height: 5),
                          if (parentJob.typeId != 3)
                            Text(
                              path,
                              style: CustomStyle.textStyle
                                  .copyWith(color: CustomColor.accentColor),
                            ),
                          const SizedBox(height: 5),
                          Text(
                            df.format(parentJob.dateFrom),
                            style: CustomStyle.textStyle
                                .copyWith(color: CustomColor.accentColor),
                          ),
                        ],
                      )
                    ],
                  ),
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: CustomColor.accentColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        border: Border.all(style: BorderStyle.none),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Customer: ${parentJob.customerName}',
                              style: CustomStyle.textStyle,
                            ),
                            if (subjobs != null &&
                                subjobs.isNotEmpty &&
                                jobs != null)
                              const SizedBox(height: 5),
                            if (subjobs != null &&
                                subjobs.isNotEmpty &&
                                jobs != null)
                              RichText(
                                text: TextSpan(
                                  children:
                                      List.generate(paths.length * 2 - 1, (i) {
                                    return TextSpan(
                                      text: i % 2 == 0
                                          ? paths[i ~/ 2]
                                          : ' \u27a1 ',
                                      style: CustomStyle.textStyle.copyWith(
                                        color: i % 2 == 1 ||
                                                i % 2 == 0 &&
                                                    i ~/ 2 >= jobs!.length ||
                                                (jobs![i ~/ 2].typeId > 7 ||
                                                    jobs[i ~/ 2].typeId < 5)
                                            ? CustomColor.primaryColor
                                            : CustomColor.greyColor,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            if (parentJob.typeId == 3)
                              const SizedBox(height: 5),
                            if (parentJob.typeId == 3)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // parentJob,
                                  ..._dailyUse[parentJob.quotationId]!,
                                ]
                                    .mapIndexed(
                                      (i, job) => Text(
                                        '${i + 1}) ${job.placeFrom} \u27a1 ${job.placeTo}',
                                        style: CustomStyle.textStyle,
                                      ),
                                    )
                                    .toList(growable: false),
                              ),
                            if (parentJob.typeId == 1 &&
                                parentJob.flightNumber != null)
                              const SizedBox(height: 5),
                            if (parentJob.typeId == 1 &&
                                parentJob.flightNumber != null)
                              Text(
                                'Flight number: ${parentJob.flightNumber}',
                                style: CustomStyle.textStyle,
                              ),
                            if (parentJob.typeId == 1)
                              const SizedBox(height: 5),
                            if (parentJob.typeId == 1)
                              Text(
                                'ETD: ${parentJob.etd == null ? '' : df.format(parentJob.etd!)}',
                                style: CustomStyle.textStyle,
                              ),
                            if (parentJob.typeId == 1)
                              const SizedBox(height: 5),
                            if (parentJob.typeId == 1)
                              Text(
                                'ETA: ${parentJob.eta == null ? '' : df.format(parentJob.eta!)}',
                                style: CustomStyle.textStyle,
                              ),
                            const SizedBox(height: 5),
                            Text(
                              'Job Value: RM$price',
                              style: CustomStyle.textStyle,
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                parentJob.orderStatus.toLowerCase() == 'p'
                                    ? TextButton(
                                        style: Theme.of(context)
                                            .elevatedButtonTheme
                                            .style!
                                            .copyWith(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.transparent),
                                            ),
                                        onPressed: _busy
                                            ? null
                                            : () {
                                                _acceptJob(parentJob);
                                              },
                                        child: const Icon(
                                          FontAwesomeIcons.check,
                                          color: Colors.green,
                                          size: 20,
                                        ),
                                      )
                                    : TextButton(
                                        style: Theme.of(context)
                                            .elevatedButtonTheme
                                            .style!
                                            .copyWith(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.transparent),
                                            ),
                                        onPressed: _busy
                                            ? null
                                            : () {
                                                _cancelJob(parentJob);
                                              },
                                        child: const Icon(
                                          FontAwesomeIcons.xmark,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _socket.close();
    super.dispose();
  }
}
