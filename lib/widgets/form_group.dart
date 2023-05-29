import 'package:asra_app_new/utils/custom_style.dart';
import 'package:flutter/material.dart';

class FormGroup extends StatelessWidget {
  final String label;
  final Widget child;
  const FormGroup({
    required this.label,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: CustomStyle.textStyle,
        ),
        const SizedBox(height: 5),
        child,
      ],
    );
  }
}
