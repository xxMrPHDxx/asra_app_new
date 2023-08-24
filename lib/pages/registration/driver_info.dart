import 'package:asra_app_new/generated/l10n.dart';
import 'package:asra_app_new/models/driver.dart';
import 'package:asra_app_new/utils/colors.dart';
import 'package:asra_app_new/utils/dimensions.dart';
import 'package:asra_app_new/widgets/form_group.dart';
import 'package:asra_app_new/widgets/form_field.dart';
import 'package:asra_app_new/widgets/templates.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DriverInfoRegistration extends StatefulWidget {
  final bool hasNext;
  final bool enabled;
  final Driver driver;
  final void Function() onPrev;
  final void Function() onNext;
  const DriverInfoRegistration({
    required this.hasNext,
    this.enabled = true,
    required this.driver,
    required this.onPrev,
    required this.onNext,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DriverInfoRegistrationState();
}

class _DriverInfoRegistrationState extends State<DriverInfoRegistration> {
  @override
  Widget build(BuildContext context) {
    return TopImageTemplateWidget(
      child: Column(
        children: [
          Text(
            S.of(context).registerDriver,
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: Dimensions.extraLargeTextSize,
              fontWeight: FontWeight.bold,
              color: CustomColor.primaryColor,
            ),
          ),
          const SizedBox(height: Dimensions.heightSize * 3),
          FormGroup(
            label: 'Full Name',
            child: CustomFormField(
              enabled: widget.enabled,
              prefixIcon: const Icon(Icons.person),
              hint: 'Johnny Depp',
              value: widget.driver.name,
              onChange: (name) => setState(() => widget.driver.name = name),
            ),
          ),
          const SizedBox(height: 10),
          FormGroup(
            label: 'Email',
            child: CustomFormField(
              enabled: widget.enabled,
              prefixIcon: const Icon(Icons.email),
              hint: 'user@example.com',
              value: widget.driver.email,
              onChange: (email) => setState(() {
                widget.driver.email = email;
              }),
            ),
          ),
          const SizedBox(height: 10),
          FormGroup(
            label: 'Identity Card',
            child: CustomFormField(
              enabled: widget.enabled,
              prefixIcon: const Icon(Icons.credit_card),
              hint: '990102-01-1234',
              value: widget.driver.icNumber,
              onChange: (ic) => setState(() {
                widget.driver.icNumber = ic;
              }),
            ),
          ),
          const SizedBox(height: 10),
          FormGroup(
            label: 'Phone',
            child: CustomFormField(
              enabled: widget.enabled,
              prefixIcon: const Icon(Icons.phone),
              hint: '0123456789',
              value: widget.driver.phone,
              onChange: (phone) => setState(() {
                widget.driver.phone = phone;
              }),
            ),
          ),
          const SizedBox(height: 10),
          FormGroup(
            label: 'Password',
            child: CustomFormField(
              enabled: widget.enabled,
              prefixIcon: const Icon(Icons.lock),
              hint: 'Length >= 8',
              value: widget.driver.password,
              onChange: (password) => setState(() {
                widget.driver.password = password;
              }),
            ),
          ),
          const SizedBox(height: 10),
          FormGroup(
            label: 'Address',
            child: CustomFormField(
              enabled: widget.enabled,
              prefixIcon: const Icon(Icons.credit_card),
              hint: 'Lot 12, Petaling Street',
              value: widget.driver.address,
              onChange: (address) => setState(() {
                widget.driver.address = address;
              }),
              maxLines: 3,
            ),
          ),
          const SizedBox(height: 10),
          CustomFileUploadField(
            enabled: widget.enabled,
            title: 'Identity Card',
            value: widget.driver.icDocument,
            onChange: (path) => setState(() {
              widget.driver.icDocument = path;
            }),
          ),
          const SizedBox(height: 10),
          CustomFileUploadField(
            enabled: widget.enabled,
            title: 'License',
            value: widget.driver.drivingLicense,
            onChange: (path) => setState(() {
              widget.driver.drivingLicense = path;
            }),
          ),
          const SizedBox(height: 10),
          CustomFileUploadField(
            enabled: widget.enabled,
            title: 'E-hailing License',
            value: widget.driver.ehailingLicense,
            onChange: (path) => setState(() {
              widget.driver.ehailingLicense = path;
            }),
          ),
          const SizedBox(height: 10),
          CustomFileUploadField(
            enabled: widget.enabled,
            title: 'E-hailing Insurance',
            value: widget.driver.ehailingInsurance,
            onChange: (path) => setState(() {
              widget.driver.ehailingInsurance = path;
            }),
          ),
          const SizedBox(height: 10),
          CustomFileUploadField(
            enabled: widget.enabled,
            title: 'Car Grant',
            value: widget.driver.carGrant,
            onChange: (path) => setState(() {
              widget.driver.carGrant = path;
            }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              ElevatedButton(
                onPressed: !widget.enabled ? null : widget.onPrev,
                child: const Text('Prev'),
              ),
              ElevatedButton(
                onPressed: !widget.enabled ? null : widget.onNext,
                child: Text(widget.hasNext ? 'Next' : 'Register'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
