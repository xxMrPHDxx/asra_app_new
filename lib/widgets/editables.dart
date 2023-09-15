import 'package:asra_app_new/widgets/form_field.dart';
import 'package:flutter/material.dart';

class EditableFormField extends StatefulWidget {
  final bool? enabled;
  final String? value;
  final Icon? prefixIcon;
  final String? hint;
  final void Function(String?)? onChanged;
  final int? maxLines;
  const EditableFormField({
    this.enabled,
    this.value,
    this.prefixIcon,
    this.hint,
    this.onChanged,
    this.maxLines,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _EditableFormFieldState();
}

class _EditableFormFieldState extends State<EditableFormField> {
  bool _changed = false;
  String? _value;

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      onFocusChange: (focus) {
        if (!focus) {
          if (_changed && widget.onChanged != null) {
            widget.onChanged!(_value);
            setState(() => _changed = false);
          }
        }
      },
      child: CustomFormField(
        enabled: widget.enabled ?? true,
        prefixIcon: widget.prefixIcon,
        hint: widget.hint,
        value: _value,
        onChange: (value) {
          setState(() {
            _value = value;
            _changed = true;
          });
        },
        maxLines: widget.maxLines ?? 1,
      ),
    );
  }
}
