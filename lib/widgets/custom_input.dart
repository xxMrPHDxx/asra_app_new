import 'package:asra_app_new/generated/l10n.dart';
import 'package:asra_app_new/utils/colors.dart';
import 'package:asra_app_new/utils/custom_style.dart';
import 'package:asra_app_new/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Widget? suffixIcon;
  final bool obscureText;
  const CustomTextField({
    this.controller,
    this.hintText,
    this.suffixIcon,
    this.obscureText = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) => TextFormField(
        style: CustomStyle.textStyle,
        controller: controller,
        validator: (value) {
          if (value == null) return null;
          if (value.isEmpty) {
            return S.of(context).errorEmpty;
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.all(10),
          labelStyle: CustomStyle.textStyle,
          focusedBorder: CustomStyle.focusBorder,
          enabledBorder: CustomStyle.focusErrorBorder,
          focusedErrorBorder: CustomStyle.focusErrorBorder,
          errorBorder: CustomStyle.focusErrorBorder,
          filled: true,
          fillColor: Colors.white,
          hintStyle: CustomStyle.textStyle,
          suffixIcon: suffixIcon,
        ),
        obscureText: obscureText,
      ),
    );
  }
}

class CustomPasswordField extends StatefulWidget {
  final TextEditingController? controller;
  const CustomPasswordField({
    this.controller,
    super.key,
  });

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: widget.controller,
      hintText: S.of(context).password,
      obscureText: !_visible,
      suffixIcon: IconButton(
        onPressed: () {
          setState(() {
            _visible = !_visible;
          });
        },
        icon: !_visible
            ? Icon(
                Icons.visibility_off,
                color: Colors.black.withOpacity(0.2),
              )
            : Icon(
                Icons.visibility,
                color: Colors.black.withOpacity(0.2),
              ),
      ),
    );
  }
}

class CustomCheckboxField extends StatelessWidget {
  final Widget? title;
  final bool? checked;
  final void Function(bool)? onToggle;
  const CustomCheckboxField({
    this.title,
    this.checked,
    this.onToggle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox.square(
          dimension: 16,
          child: ColoredBox(
            color: Colors.white,
            child: Checkbox(
              checkColor: CustomColor.accentColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: BorderSide.none,
              ),
              fillColor: MaterialStateProperty.all(CustomColor.primaryColor),
              value: checked,
              onChanged: (newValue) {
                if (newValue == null || onToggle == null) return;
                onToggle!(newValue);
              },
            ),
          ),
        ),
        if (title != null) const SizedBox(width: 10),
        if (title != null) title!,
      ],
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final Color color, backgroundColor;
  final void Function()? onClick;
  const CustomButton({
    required this.text,
    this.color = CustomColor.accentColor,
    this.backgroundColor = CustomColor.primaryColor,
    this.onClick,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        height: 50.0,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(Dimensions.radius * 0.5),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.roboto(
              color: color,
              fontSize: Dimensions.largeTextSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  static accent({
    required String text,
  }) {
    return CustomButton(
      text: text,
      color: CustomColor.primaryColor,
      backgroundColor: CustomColor.accentColor,
    );
  }
}
