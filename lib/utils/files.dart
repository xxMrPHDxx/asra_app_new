import 'dart:io';

import 'package:asra_app_new/api.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

Future<File> getFileFromUrl(String url, {name}) async {
  var fileName = 'tempfile';
  if (name != null) {
    fileName = name;
  }
  try {
    final response = await Api.bytes.get('/$url') as Response;
    final bytes = response.bodyBytes;
    final dir = await getApplicationDocumentsDirectory();
    File file = File('${dir.path}/$fileName.pdf');
    File urlFile = await file.writeAsBytes(bytes);
    return urlFile;
  } catch (e) {
    throw Exception("Error opening pdf: $e");
  }
}
