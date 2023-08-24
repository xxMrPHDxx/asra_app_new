import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

abstract class Api {
  // static const String _baseUri = 'http://192.168.0.101:3000/api';
  static const String _baseUri = 'http://103.18.244.31:3000';

  static link(String path) {
    return '$_baseUri$path';
  }

  Future<dynamic> get(String path, [Map<String, String>? headers]);
  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> data,
      [Map<String, String>? headers]);
  Future<Map<String, dynamic>> patch(String path, Map<String, dynamic> data,
      [Map<String, String>? headers]) {
    throw Exception('Not implemented!');
  }

  static Api get bytes => _Bytes();
  static Api get json => _Json();
  static Api get multipart => _Multipart();
}

class _Bytes extends Api {
  @override
  Future<dynamic> get(String path, [Map<String, String>? headers]) async {
    final response = await http.get(
      Uri.parse('${Api._baseUri}$path'),
      headers: headers,
    );
    return response;
  }

  @override
  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> data,
      [Map<String, String>? headers]) async {
    throw Exception('Invalid');
  }
}

class _Json extends Api {
  @override
  Future<Map<String, dynamic>> get(String path,
      [Map<String, String>? headers]) async {
    final response = await http.get(
      Uri.parse('${Api._baseUri}/api$path'),
      headers: headers,
    );
    return jsonDecode(response.body);
  }

  @override
  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> data, [
    Map<String, String>? headers,
  ]) async {
    headers ??= {};
    headers['Content-Type'] = 'application/json';
    final response = await http.post(
      Uri.parse('${Api._baseUri}/api$path'),
      headers: headers,
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }

  @override
  Future<Map<String, dynamic>> patch(
    String path,
    Map<String, dynamic> data, [
    Map<String, String>? headers,
  ]) async {
    headers ??= {};
    headers['Content-Type'] = 'application/json';
    final response = await http.patch(
      Uri.parse('${Api._baseUri}/api$path'),
      headers: headers,
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }
}

class _Multipart extends Api {
  @override
  Future<Map<String, dynamic>> get(String path,
      [Map<String, String>? headers]) async {
    throw Exception('Invalid');
  }

  @override
  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> data,
      [Map<String, String>? headers]) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${Api._baseUri}/api$path'),
    );
    if (headers != null) request.headers.addAll(headers);
    for (final entry in data.entries) {
      if (entry.value is http.MultipartFile) {
        request.files.add(entry.value);
      } else {
        request.fields[entry.key] = entry.value.toString();
      }
    }
    final response = await request.send();
    return jsonDecode(await response.stream.bytesToString());
  }
}
