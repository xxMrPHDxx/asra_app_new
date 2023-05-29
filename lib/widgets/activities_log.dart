import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';

class Activity {
  final String type;
  final DateTime start;
  final DateTime? stop;
  final String note, status;
  final String actor;
  final String? approved;
  final double? driverCost;
  Activity(
    this.type,
    this.start,
    this.stop,
    this.note,
    this.status,
    this.actor, {
    this.approved,
    this.driverCost,
  });
}

class ActivitiesLog extends StatelessWidget {
  final List<Activity> _activities;

  const ActivitiesLog(this._activities, {Key? key}) : super(key: key);

  static Color _getColor(String? approval) {
    if (approval == 'Approved') {
      return Colors.green;
    }
    if (approval == 'Denied') {
      return Colors.red;
    }
    return Colors.black;
  }

  static String _getDriverCost(Activity activity) {
    if (activity.approved != 'Approved' || activity.driverCost == null) {
      return '';
    }
    return ' +RM${activity.driverCost!.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('MMM d, y\nh:mm a');
    return Timeline.tileBuilder(
      builder: TimelineTileBuilder.fromStyle(
        contentsAlign: ContentsAlign.reverse,
        contentsBuilder: (ctx, idx) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              df.format(_activities[idx].start),
              style: const TextStyle(
                fontSize: 10,
              ),
            ),
          );
        },
        nodePositionBuilder: (ctx, idx) {
          return 0.25;
        },
        oppositeContentsBuilder: (ctx, idx) {
          final activity = _activities[idx];
          return Padding(
            padding: const EdgeInsets.all(10),
            child: InkWell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    activity.type,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: activity.actor == 'passenger' ? Colors.blue.shade800 : Colors.black,
                        ),
                  ),
                  if (activity.note.isNotEmpty)
                    Text(
                      activity.note,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: activity.actor == 'passenger' ? Colors.blue.shade800 : Colors.black,
                          ),
                    ),
                  Text(
                    'Status: ${activity.status}',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: activity.actor == 'passenger' ? Colors.blue.shade800 : Colors.black),
                  ),
                  if (activity.approved != null)
                    Text(
                      '(${activity.approved}${_getDriverCost(activity)})',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: activity.actor == 'passenger' ? Colors.blue.shade800 : _getColor(activity.approved),
                          ),
                    ),
                ],
              ),
              onTap: () {
                Fluttertoast.showToast(msg: 'Not implemented!');
              },
            ),
          );
        },
        itemCount: _activities.length,
      ),
    );
  }
}
