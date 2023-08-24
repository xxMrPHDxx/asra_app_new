import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:asra_app_new/api.dart';
import 'package:asra_app_new/models/job.dart';
import 'package:asra_app_new/widgets/activities_log.dart';

class _ActivityType {
  final int id;
  final String name;
  _ActivityType(this.id, this.name);
}

class AddActivityWidget extends StatelessWidget {
  final String authToken;
  final Job job;
  final Function? onInsert;
  AddActivityWidget(this.authToken, this.job, {this.onInsert, Key? key})
      : super(key: key) {
    _getActivityTypes();
  }

  Future<List<_ActivityType>> _getActivityTypes() async {
    final List<_ActivityType> activityTypes = [];
    final result = await Api.json.get('/activity/types');
    if (!result['success']) {
      throw Exception(result['message']);
    } else {
      for (final type in result['types']) {
        activityTypes.add(
          _ActivityType(type['id'], type['name']),
        );
      }
    }
    return activityTypes;
  }

  Future<void> _insertActivity(
      BuildContext context, int id, String note) async {
    if (note.isEmpty) return;
    final response = await Api.json.post(
      '/orders/${job.orderId}/${job.itemId}/activity',
      {
        'activity_id': id,
        'note': note,
      },
      {
        'Authorization': 'Bearer $authToken',
      },
    );
    try {
      if (!response['success']) throw Exception(response['message']);
      final activity = response['activity'];
      if (onInsert != null) {
        onInsert!(
          Activity(
            activity['type'],
            DateTime.parse(activity['start']),
            activity['stop'] == null ? null : DateTime.parse(activity['stop']),
            activity['note'],
            activity['status'],
            activity['actor'],
            approved: activity['approved'],
            driverCost: activity['driver_cost'],
          ),
        );
      }
    } catch (e) {
      if (e is Exception) {
        Fluttertoast.showToast(msg: '[Error]: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int activityId;
    final activityNote = TextEditingController();
    return FutureBuilder<List<_ActivityType>>(
      future: _getActivityTypes(),
      builder: (ctx, snapshot) {
        return StatefulBuilder(
          builder: (context, setState) {
            if (!snapshot.hasData ||
                snapshot.data!.isEmpty ||
                snapshot.hasError) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            activityId = snapshot.data![0].id;
            return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 4,
              child: Card(
                shadowColor: Colors.grey,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Add Status',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black87,
                              width: 2,
                            ),
                          ),
                        ),
                        items: snapshot.data!
                            .map((type) => DropdownMenuItem<int>(
                                  value: type.id,
                                  child: Text(
                                    type.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          fontSize: 12,
                                        ),
                                  ),
                                ))
                            .toList(),
                        onChanged: (id) {
                          if (id == null) return;
                          activityId = id;
                        },
                        onSaved: (id) {
                          if (id == null) return;
                          activityId = id;
                        },
                        value: activityId,
                        hint: const Text('- Please Select -'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black87,
                              width: 2,
                            ),
                          ),
                          hintText: 'Note',
                        ),
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontSize: 12,
                            ),
                        controller: activityNote,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          _insertActivity(
                                  context, activityId, activityNote.text)
                              .then((_) {
                            Navigator.of(context).pop();
                          });
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
