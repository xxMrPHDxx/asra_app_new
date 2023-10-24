import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class AddBlockingWidget extends StatelessWidget {
  final void Function(DateTime, DateTime)? onClick;
  const AddBlockingWidget({Key? key, this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime? startDate, endDate;
    final df = DateFormat('MMM d, y h:mm a');
    final minTime = DateTime.now();
    final maxTime = minTime.add(const Duration(days: 365));
    return StatefulBuilder(
      builder: (context, setState) => Dialog(
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
                  'Select Block Date',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                const Text('From'),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black87,
                              width: 2,
                            ),
                          ),
                          constraints: BoxConstraints.tightFor(height: 42),
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Start',
                        ),
                        controller: TextEditingController.fromValue(
                          TextEditingValue(
                            text: startDate == null
                                ? '-- Please Select --'
                                : df.format(startDate!),
                          ),
                        ),
                        readOnly: true,
                      ),
                    ),
                    ElevatedButton(
                      child: const Text('Pick'),
                      onPressed: () {
                        DatePicker.showDateTimePicker(
                          context,
                          minTime: minTime,
                          maxTime: maxTime,
                          currentTime: startDate,
                          onConfirm: (datetime) {
                            setState(() {
                              startDate = datetime;
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text('Until'),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black87,
                              width: 2,
                            ),
                          ),
                          constraints: BoxConstraints.tightFor(height: 42),
                          contentPadding: EdgeInsets.zero,
                          hintText: 'End',
                        ),
                        controller: TextEditingController.fromValue(
                          TextEditingValue(
                            text: endDate == null
                                ? '-- Please Select --'
                                : df.format(endDate!),
                          ),
                        ),
                        readOnly: true,
                      ),
                    ),
                    ElevatedButton(
                      child: const Text('Pick'),
                      onPressed: () {
                        DatePicker.showDateTimePicker(
                          context,
                          minTime: minTime,
                          maxTime: maxTime,
                          currentTime: endDate,
                          onConfirm: (datetime) {
                            setState(() {
                              endDate = datetime;
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (onClick != null &&
                        startDate != null &&
                        endDate != null) {
                      onClick!(startDate!, endDate!);
                    }
                  },
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
