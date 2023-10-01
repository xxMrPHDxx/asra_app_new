import 'package:asra_app_new/models/job.dart';
import 'package:asra_app_new/utils/colors.dart';
import 'package:asra_app_new/utils/custom_style.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

const double iconSize = 48;

const serviceIcons = {
  1: FontAwesomeIcons.plane,
  3: FontAwesomeIcons.calendar,
  8: FontAwesomeIcons.city,
  4: FontAwesomeIcons.mapLocation,
};

class JobOffersWidget extends StatelessWidget {
  final Map<int, Job> bookings;
  final Map<String, List<Job>> dailyUsed;
  final void Function(Job) onAccept;
  final void Function(Job) onCancel;
  final bool busy;

  const JobOffersWidget({
    required this.bookings,
    required this.dailyUsed,
    required this.onAccept,
    required this.onCancel,
    required this.busy,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (busy) return const Center(child: CircularProgressIndicator());
    if (bookings.isEmpty) {
      return Center(
        child: Text(
          'No job offers!',
          style: CustomStyle.defaultStyle,
        ),
      );
    }
    final df = DateFormat('d MMM, yyyy hh:mm a');
    final parentJobs = bookings.values
        .where((job) => job.typeId != 3 && (job.subJob ?? 0) == 0)
        .toList(growable: false);
    final keys = dailyUsed.keys.toList();
    return Column(
      children: List.generate(parentJobs.length + dailyUsed.length, (idx) {
        final parentJob = idx >= dailyUsed.length
            ? parentJobs[idx - dailyUsed.length]
            : dailyUsed[keys[idx]]!.first;
        List<Job>? subjobs;
        List<Job>? jobs;
        final String path;
        final double totalprice;
        if (parentJob.typeId == 3) {
          totalprice =
              dailyUsed[parentJob.quotationId]!.fold(0, (a, b) => a + b.price);
          path = 'Not implemented!';
        } else {
          subjobs = bookings.values
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
        final isJobPending = parentJob.orderStatus.toLowerCase() == 'p';
        final darkColor = isJobPending
            ? CustomColor.secondaryColor
            : CustomColor.jobAcceptedColor;
        return Padding(
          padding: const EdgeInsets.all(5),
          child: Container(
            decoration: BoxDecoration(
              color: darkColor,
              border: Border.all(style: BorderStyle.none),
              boxShadow: [
                BoxShadow(
                  color: darkColor.withOpacity(0.7),
                  blurRadius: 2,
                  offset: const Offset(3, 3),
                ),
              ],
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Padding(
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
                          df.format(parentJob.dateFrom.toLocal()),
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
                                    text:
                                        i % 2 == 0 ? paths[i ~/ 2] : ' \u27a1 ',
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
                          if (parentJob.typeId == 3) const SizedBox(height: 5),
                          if (parentJob.typeId == 3)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // parentJob,
                                ...dailyUsed[parentJob.quotationId]!,
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
                          if (parentJob.typeId == 1) const SizedBox(height: 5),
                          if (parentJob.typeId == 1)
                            Text(
                              'ETD: ${parentJob.etd == null ? '' : df.format(parentJob.etd!.toLocal())}',
                              style: CustomStyle.textStyle,
                            ),
                          if (parentJob.typeId == 1) const SizedBox(height: 5),
                          if (parentJob.typeId == 1)
                            Text(
                              'ETA: ${parentJob.eta == null ? '' : df.format(parentJob.eta!.toLocal())}',
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
                              isJobPending
                                  ? InkWell(
                                      onTap: busy
                                          ? null
                                          : () {
                                              onAccept(parentJob);
                                            },
                                      child: SizedBox.square(
                                        dimension: iconSize,
                                        child: Image.asset(
                                            'assets/imgs/accept.png'),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: busy
                                          ? null
                                          : () {
                                              onCancel(parentJob);
                                            },
                                      child: SizedBox.square(
                                        dimension: iconSize,
                                        child: Image.asset(
                                            'assets/imgs/cancel.png'),
                                      ),
                                    ),
                              if (parentJob.note != null)
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(
                                          'Trip Information',
                                          style: GoogleFonts.roboto(
                                            fontSize: 26,
                                          ),
                                        ),
                                        content: SizedBox(
                                          height: 200,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                Text(
                                                  parentJob.note!,
                                                  style: CustomStyle.textStyle,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Icon(
                                    FontAwesomeIcons.circleInfo,
                                    color: Colors.grey,
                                    size: iconSize,
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
      }),
    );
  }
}
