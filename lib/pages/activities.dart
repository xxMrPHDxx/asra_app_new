import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:asra_app_new/api.dart';
import 'package:asra_app_new/models/job.dart';
import 'package:asra_app_new/widgets/activities_log.dart';
import 'package:asra_app_new/pages/home.dart';
import 'package:asra_app_new/widgets/add_activity.dart';
import 'package:intl/date_symbol_data_local.dart';

class ActivitiesPage extends StatefulWidget {
  final Job job;
  final LoginData login;
  final String authToken;

  const ActivitiesPage(this.job, this.login, this.authToken, {Key? key})
      : super(key: key);

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  final List<Activity> _activities = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadActivities().then((_) {
      setState(() {
        _loading = false;
      });
    }).catchError((e) {
      Fluttertoast.showToast(msg: '[Error]: ${e.toString()}');
    });
  }

  Future<void> _loadActivities() async {
    await initializeDateFormatting();
    final job = widget.job;
    Fluttertoast.showToast(
        msg:
            'Getting orders:  /orders/${job.orderId}/${job.itemId}/activities');
    final res =
        await Api.json.get('/orders/${job.orderId}/${job.itemId}/activities', {
      'Authorization': 'Bearer ${widget.authToken}',
    });
    if (!res['success']) {
      Fluttertoast.showToast(msg: 'Error: ${res['message']}');
    } else if (mounted) {
      setState(() {
        _activities.length = 0;
        for (final activity in res['activities']) {
          _activities.add(Activity(
            activity['type'],
            DateTime.parse(activity['start']),
            activity['stop'] == null ? null : DateTime.parse(activity['stop']),
            activity['note'],
            activity['status'],
            activity['actor'],
            approved: activity['approved'],
            driverCost: activity['driver_cost'] == null
                ? null
                : double.parse(activity['driver_cost']),
            actorId: activity['actor_id'],
          ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.job;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.7),
              BlendMode.dstATop,
            ),
            image: const AssetImage('assets/background.jpg'),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      elevation: 4,
                      color: Theme.of(context).colorScheme.surface,
                      shadowColor: Colors.grey,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              job.customerName,
                              textAlign: TextAlign.start,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              job.orderType,
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            Text(
                              job.placeTo == null
                                  ? job.placeFrom
                                  : '${job.placeFrom} - ${job.placeTo}',
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Card(
                        elevation: 4,
                        color: Theme.of(context).colorScheme.surface,
                        shadowColor: Colors.grey,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: ActivitiesLog(_activities),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: Colors.yellow,
          size: 30,
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddActivityWidget(
              widget.authToken,
              widget.job,
              onInsert: (activity) {
                setState(() {
                  _activities.insert(
                    0,
                    activity,
                  );
                });
              },
            ),
          );
        },
      ),
    );
  }
}
