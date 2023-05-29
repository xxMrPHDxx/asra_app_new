import 'package:asra_app_new/generated/l10n.dart';
import 'package:asra_app_new/utils/colors.dart';
import 'package:asra_app_new/utils/dimensions.dart';
import 'package:asra_app_new/widgets/templates.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class _DriverType extends StatelessWidget {
  final String caption;
  final Image image;
  final bool selected;
  const _DriverType({
    required this.caption,
    required this.image,
    this.selected = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          SizedBox.square(
            dimension: 60,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                selected ? Colors.blue : Colors.black,
                BlendMode.colorDodge,
              ),
              child: image,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            caption,
            style: Theme.of(context).textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: selected ? Colors.blue : Colors.black,
                ),
          ),
        ],
      ),
    );
  }
}

class DriverTypeRegistration extends StatefulWidget {
  final int? value;
  final void Function(int) onChange;
  final void Function() onNext;
  const DriverTypeRegistration({
    this.value,
    required this.onChange,
    required this.onNext,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DriverTypeRegistrationState();
}

class _DriverTypeRegistrationState extends State<DriverTypeRegistration> {
  @override
  Widget build(BuildContext context) {
    return TopImageTemplateWidget(
      child: Column(
        children: [
          Text(
            S.of(context).registrationType,
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: Dimensions.extraLargeTextSize,
              fontWeight: FontWeight.bold,
              color: CustomColor.primaryColor,
            ),
          ),
          InkWell(
            onTap: () => widget.onChange(1),
            child: _DriverType(
              caption: 'Partner Driver',
              image: Image.asset('assets/partner.png'),
              selected: widget.value == 1,
            ),
          ),
          InkWell(
            onTap: () => widget.onChange(2),
            child: _DriverType(
              caption: 'Driver Only',
              image: Image.asset('assets/driver.png'),
              selected: widget.value == 2,
            ),
          ),
          InkWell(
            onTap: () => widget.onChange(3),
            child: _DriverType(
              caption: 'Hosting',
              image: Image.asset('assets/host.png'),
              selected: widget.value == 3,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              ElevatedButton(
                child: const Text('Next'),
                onPressed: () {
                  widget.onNext();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
