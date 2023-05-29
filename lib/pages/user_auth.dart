import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UserAuth extends StatelessWidget {
  final String data;
  const UserAuth(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: QrImageView(
          data: data,
          version: QrVersions.auto,
          // size: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}
