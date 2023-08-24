import 'package:asra_app_new/api.dart';
import 'package:asra_app_new/utils/files.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showPdf(BuildContext context, String url) async {
  final file = await getFileFromUrl(url);
  if (context.mounted) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => PDFView(
          filePath: file.path,
          autoSpacing: true,
          enableSwipe: true,
          pageSnap: true,
          swipeHorizontal: true,
          nightMode: false,
          onError: (e) {
            Fluttertoast.showToast(msg: 'Error: $e');
          },
          onPageError: (page, e) {
            Fluttertoast.showToast(msg: 'Page Error: $e');
          },
        ),
      ),
    );
  }
}

void showImage(BuildContext context, String url) async {
  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => Image.network(
        Api.link('/$url'),
      ),
    ),
  );
}
