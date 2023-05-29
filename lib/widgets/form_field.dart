import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomFormField extends StatelessWidget {
  final bool enabled;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final String? hint;
  final int maxLines;
  final String value;
  final String? obscureCharacter;
  final void Function(String) onChange;
  final void Function()? onIconClicked;
  const CustomFormField({
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.hint,
    this.maxLines = 1,
    required this.value,
    this.obscureCharacter,
    required this.onChange,
    this.onIconClicked,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black87,
            width: 2,
          ),
        ),
        constraints:
            maxLines > 1 ? null : const BoxConstraints.tightFor(height: 42),
        contentPadding: maxLines > 1
            ? const EdgeInsets.symmetric(vertical: 20, horizontal: 10)
            : const EdgeInsets.symmetric(horizontal: 10),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon == null
            ? null
            : TextButton(
                onPressed: onIconClicked,
                child: suffixIcon!,
              ),
        hintText: hint,
      ),
      maxLines: maxLines,
      initialValue: value,
      onChanged: onChange,
      obscureText: obscureCharacter != null,
      obscuringCharacter: obscureCharacter ?? ' ',
    );
  }
}

class CustomFileFormField extends StatelessWidget {
  final bool enabled;
  final String title;
  final String? value;
  final List<String>? allowedExtensions;
  final void Function(String) onChange;
  const CustomFileFormField({
    this.enabled = true,
    required this.title,
    required this.value,
    this.allowedExtensions,
    required this.onChange,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (ctx, setState) => TextField(
        readOnly: true,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black87,
              width: 2,
            ),
          ),
          constraints: const BoxConstraints.tightFor(height: 42),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          hintText: 'Select document',
          suffixIcon: TextButton(
            onPressed: !enabled
                ? null
                : () async {
                    final result = await FilePicker.platform.pickFiles(
                      dialogTitle: title,
                      type: FileType.custom,
                      allowedExtensions: allowedExtensions,
                      withReadStream: true,
                      allowMultiple: false,
                    );
                    if (result == null) return;
                    onChange(result.files[0].path!);
                  },
            child: const Icon(FontAwesomeIcons.upload),
          ),
        ),
        controller: TextEditingController(text: value),
      ),
    );
  }
}

class CustomDropdownButton<T> extends StatelessWidget {
  final bool enabled;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final String? hint;
  final void Function(T)? onChanged;
  const CustomDropdownButton({
    this.enabled = true,
    required this.items,
    this.value,
    this.hint,
    this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: DropdownButton<T>(
          hint: hint == null
              ? null
              : Text(
                  hint!,
                  style: Theme.of(context)
                      .textTheme
                      .button!
                      .copyWith(color: Colors.black),
                ),
          underline: Container(),
          isExpanded: true,
          items: items,
          value: value,
          onChanged: !enabled
              ? null
              : (val) {
                  if (val != null) onChanged?.call(val);
                },
        ),
      ),
    );
  }
}
