import 'dart:async';

import 'package:asra_app_new/api.dart';
import 'package:asra_app_new/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MemoViewer extends StatefulWidget {
  final String authToken;
  const MemoViewer({
    required this.authToken,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MemoViewerState();
}

class _MemoViewerState extends State<MemoViewer> {
  final List<String> _memos = [];
  late final Timer _timer;
  int _index = 0;
  bool _loading = true;

  _MemoViewerState() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      setState(() {
        if (_memos.length > 1 && ++_index >= _memos.length) {
          _index = 0;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getMemos();
  }

  void _getMemos() async {
    try {
      final response = await Api.get('/memo', {
        'Authorization': 'Bearer ${widget.authToken}',
      });
      if (!response['success']) throw Error(response['message']);
      for (final memo in response['memos']) {
        _memos.add(memo['content']);
      }
      setState(() => _loading = false);
    } catch (e) {
      if (e is Error) Fluttertoast.showToast(msg: e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_memos.isEmpty) {
      return const Center(
        child: Text('No memo!'),
      );
    }
    return Html(
      data: _memos[_index],
      shrinkWrap: true,
      style: const {
        // 'img': Style(
        //   width: Width(100, Unit.percent),
        // ),
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
