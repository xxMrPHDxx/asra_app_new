import 'dart:developer';

// import 'package:asra_app_new/pages/tracking.dart';
// import 'package:asra_app_new/pages/user_auth.dart';
import 'package:asra_app_new/pages/activities.dart';
import 'package:asra_app_new/pages/tracking.dart';
import 'package:asra_app_new/pages/user_auth.dart';
import 'package:asra_app_new/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:asra_app_new/models/job.dart';
import 'package:asra_app_new/pages/home.dart';
import 'package:asra_app_new/api.dart';
// import 'package:asra_app_new/pages/activities.dart';

class TripsPage extends StatefulWidget {
  final LoginData login;
  final String authToken;

  const TripsPage(this.login, this.authToken, {Key? key}) : super(key: key);

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  final df = DateFormat('d MMM, yyyy hh:mm a');
  bool _loading = true;
  final List<Job> _jobs = [];

  @override
  void initState() {
    super.initState();
    _getTrips();
  }

  void _getTrips() async {
    final response = await Api.get('/jobs', {
      'Authorization': 'Bearer ${widget.authToken}',
    });
    if (!response['success']) {
      log('[Error]: ${response['message']}');
    } else {
      Fluttertoast.showToast(msg: 'Length: ${response['jobs'].length}');
      setState(() {
        for (final job in response['jobs']) {
          _jobs.add(Job(
            job['order_id'],
            job['item_id'],
            job['service_id'],
            job['quotation_id'],
            job['order_type'],
            job['customer_name'],
            job['status'] ?? 'N/A',
            job['place_from'] ?? 'N/A',
            job['place_to'],
            DateTime.parse(job['date_from']),
            DateTime.parse(job['date_to']),
            price: double.parse(job['price']),
            link: job['link'],
            flightNumber: job['flight_number'],
            etd: DateTime.tryParse(job['etd'] ?? ''),
            eta: DateTime.tryParse(job['eta'] ?? ''),
            subJob: job['sub_id'],
            fromLat: double.tryParse(job['lat_from'] ?? '') ?? 0,
            fromLon: double.tryParse(job['lon_from'] ?? '') ?? 0,
            toLat: double.tryParse(job['lat_to'] ?? '') ?? 0,
            toLon: double.tryParse(job['lon_to'] ?? '') ?? 0,
            request: job['request'] ?? '-',
          ));
        }
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_jobs.isEmpty) {
      return Center(
        child: Text(
          'No active job!',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }
    final parentJobs = _jobs.where((job) => job.subJob == null || job.subJob == 0 || job.typeId == 3).toList(growable: false);
    return ListView.builder(
      itemBuilder: (ctx, idx) {
        final parentJob = parentJobs[idx];
        final subjobs = _jobs.where((job) => parentJob.typeId == 3 ? (job != parentJob && job.quotationId == parentJob.quotationId) : job.subJob == parentJob.itemId).toList(growable: false);
        final childprice = subjobs.fold<double>(0, (s, job) => s + job.price);
        final price = (childprice + parentJob.price).toStringAsFixed(2);
        final path = [
          parentJob.placeFrom,
          ...subjobs.map((job) => job.request),
          if (parentJob.placeTo != null) parentJob.placeTo,
        ].join(' \u27a1 ');
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${idx + 1}',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 10),
                          ![3, 5, 6, 7].contains(parentJob.typeId) && parentJob.typeId != 1
                              ? SvgPicture.asset(
                                  height: 30,
                                  'assets/svg/cheuffeur.svg',
                                  colorFilter: const ColorFilter.mode(
                                    CustomColor.primaryColor,
                                    BlendMode.srcIn,
                                  ),
                                )
                              : const Icon(
                                  FontAwesomeIcons.plane,
                                  color: CustomColor.primaryColor,
                                ),
                        ],
                      ),
                    ),
                    VerticalDivider(
                      width: 20,
                      thickness: 2,
                      color: Colors.black.withAlpha(80),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Job#${parentJob.itemId} (${parentJob.orderType})',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            parentJob.customerName,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            path,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          if (parentJob.flightNumber != null) const SizedBox(height: 5),
                          if (parentJob.flightNumber != null)
                            Text(
                              'Flight number: ${parentJob.flightNumber}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          const SizedBox(height: 5),
                          Text(
                            'ETD: ${parentJob.etd == null ? '' : df.format(parentJob.etd!)}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'ETA: ${parentJob.eta == null ? '' : df.format(parentJob.eta!)}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Job Value: RM$price',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              ElevatedButton(
                                style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                                      backgroundColor: MaterialStatePropertyAll(Colors.yellow.shade700),
                                    ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) => UserAuth(parentJob.link),
                                    ),
                                  );
                                },
                                child: const Icon(Icons.qr_code),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => ActivitiesPage(
                                      parentJob,
                                      widget.login,
                                      widget.authToken,
                                    ),
                                  ));
                                },
                                child: const Text('Details'),
                              ),
                              const SizedBox(width: 10),
                              SizedBox.square(
                                dimension: 30,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) => TrackingPage(
                                        job: parentJob,
                                        subJobs: subjobs,
                                      ),
                                    ));
                                  },
                                  child: const Icon(Icons.map),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      // separatorBuilder: (ctx, idx) => const SizedBox(height: 0),
      itemCount: parentJobs.length,
    );
  }
}
