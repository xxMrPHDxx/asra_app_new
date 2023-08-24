import 'package:asra_app_new/api.dart';
import 'package:asra_app_new/utils/viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import 'form_group.dart';

class CustomFormField extends StatelessWidget {
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hint;
  final int maxLines;
  final String? value;
  final String? obscureCharacter;
  final bool? readOnly;
  final void Function(String)? onChange;
  final void Function()? onIconClicked;
  const CustomFormField({
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.hint,
    this.maxLines = 1,
    this.value,
    this.obscureCharacter,
    this.readOnly,
    this.onChange,
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
      readOnly: readOnly ?? false,
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

enum FileUploadType {
  pdf,
  image,
}

class CustomFileUploadField extends StatefulWidget {
  final bool enabled;
  final String title;
  final String? hintText;
  final String? value;
  final FileUploadType uploadType;
  final void Function(String) onChange;
  const CustomFileUploadField({
    this.enabled = true,
    required this.title,
    this.hintText,
    required this.value,
    this.uploadType = FileUploadType.pdf,
    required this.onChange,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomFileUploadFieldState();
}

class _CustomFileUploadFieldState extends State<CustomFileUploadField> {
  @override
  Widget build(BuildContext context) {
    bool uploaded = widget.value?.isNotEmpty ?? false;
    return FormGroup(
      label: '${widget.title} (${uploaded ? '\u2705' : '\u274C'})',
      child: TextField(
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
          hintText: widget.hintText ?? 'Select document',
          prefixIcon: uploaded
              ? TextButton(
                  onPressed: () {
                    if (widget.uploadType == FileUploadType.pdf) {
                      showPdf(context, widget.value!);
                    } else {
                      showImage(context, widget.value!);
                    }
                  },
                  child: const Text('View'),
                )
              : null,
          suffixIcon: TextButton(
            onPressed: !widget.enabled
                ? null
                : () async {
                    try {
                      final result = await FilePicker.platform.pickFiles(
                        dialogTitle: widget.title,
                        type: FileType.custom,
                        allowedExtensions:
                            widget.uploadType == FileUploadType.pdf
                                ? ['pdf']
                                : ['jpg', 'png'],
                        allowMultiple: false,
                      );
                      if (result == null) return;
                      String endpoint = widget.uploadType == FileUploadType.pdf
                          ? 'pdf'
                          : 'image';
                      final response =
                          await Api.multipart.post('/upload/$endpoint', {
                        'input': await MultipartFile.fromPath(
                          'input',
                          result.files[0].path!,
                        ),
                      });
                      if (!response['success']) {
                        throw Exception(response['message']);
                      }
                      setState(() {
                        widget.onChange(response['path']);
                      });
                    } catch (e) {
                      Fluttertoast.showToast(
                        msg: '$e',
                      );
                    }
                  },
            child: const Icon(FontAwesomeIcons.upload),
          ),
        ),
        controller: TextEditingController(text: widget.value),
      ),
    );
  }
}

class DatePickerField extends StatelessWidget {
  final String? value;
  final void Function(String)? onChanged;
  const DatePickerField({
    this.value,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
            ),
            enabled: false,
            controller: TextEditingController(text: value),
          ),
        ),
        SizedBox.square(
          dimension: 48,
          child: InkWell(
            onTap: () async {
              final result = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(
                  const Duration(days: 10 * 365),
                ),
              );
              if (result == null) return;
              final date = DateFormat('d MMM y').format(result);
              if (onChanged != null) onChanged!(date);
            },
            child: const Icon(Icons.date_range),
          ),
        ),
      ],
    );
  }
}
