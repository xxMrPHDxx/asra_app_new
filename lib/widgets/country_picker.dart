import 'package:asra_app_new/utils/custom_style.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

class CountryPickerWidget extends StatelessWidget {
  final Country? initialValue;
  final void Function(Country)? onChanged;
  const CountryPickerWidget({
    this.initialValue,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.0,
      width: 60.0,
      alignment: Alignment.center,
      child: InkWell(
        child: Text(
          initialValue?.flagEmoji ?? '',
          style: CustomStyle.textStyle.copyWith(fontSize: 30),
        ),
        onTap: () {
          showCountryPicker(
            context: context,
            onSelect: (country) {
              if (onChanged != null) onChanged!(country);
            },
          );
        },
      ),
    );
  }
}
