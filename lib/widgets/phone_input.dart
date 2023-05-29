import 'package:asra_app_new/generated/l10n.dart';
import 'package:asra_app_new/utils/custom_style.dart';
import 'package:asra_app_new/utils/dimensions.dart';
import 'package:asra_app_new/widgets/country_picker.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

class PhoneInput extends StatelessWidget {
  final Country? initialValue;
  final TextEditingController? controller;
  final void Function(Country)? onChanged;
  const PhoneInput({
    this.initialValue,
    this.controller,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) => Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(Dimensions.radius * 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CountryPickerWidget(
              initialValue: initialValue,
              onChanged: (country) {
                if (onChanged != null) onChanged!(country);
                setState(() {
                  controller?.text = '+${country.phoneCode}';
                });
              },
            ),
            SizedBox(
              height: 50.0,
              width: MediaQuery.of(context).size.width / 1.5,
              child: TextFormField(
                style: CustomStyle.textStyle,
                controller: controller,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null) return null;
                  if (value.isEmpty) {
                    return S.of(context).errorEmpty;
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: S.of(context).phone,
                  contentPadding: const EdgeInsets.all(10.0),
                  labelStyle: CustomStyle.textStyle,
                  filled: true,
                  fillColor: Colors.white,
                  hintStyle: CustomStyle.textStyle,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
