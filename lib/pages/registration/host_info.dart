import 'package:asra_app_new/generated/l10n.dart';
import 'package:asra_app_new/models/host.dart';
import 'package:asra_app_new/utils/colors.dart';
import 'package:asra_app_new/utils/dimensions.dart';
import 'package:asra_app_new/widgets/form_group.dart';
import 'package:asra_app_new/widgets/form_field.dart';
import 'package:asra_app_new/widgets/templates.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HostInfoRegistration extends StatefulWidget {
  final bool enabled;
  final Host host;
  final void Function() onPrev;
  final void Function() onNext;
  const HostInfoRegistration({
    this.enabled = true,
    required this.host,
    required this.onPrev,
    required this.onNext,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HostInfoRegistrationState();
}

class _HostInfoRegistrationState extends State<HostInfoRegistration> {
  @override
  Widget build(BuildContext context) {
    return TopImageTemplateWidget(
      child: Column(
        children: [
          Text(
            S.of(context).registerHost,
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
              value: widget.host.name,
              onChange: (name) => setState(() {
                widget.host.name = name;
              }),
            ),
          ),
          const SizedBox(height: 10),
          FormGroup(
            label: 'Email',
            child: CustomFormField(
              enabled: widget.enabled,
              prefixIcon: const Icon(Icons.email),
              hint: 'user@example.com',
              value: widget.host.email,
              onChange: (email) => setState(() {
                widget.host.email = email;
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
              value: widget.host.icNumber,
              onChange: (ic) => setState(() {
                widget.host.icNumber = ic;
              }),
            ),
          ),
          const SizedBox(height: 10),
          FormGroup(
            label: 'Gender',
            child: CustomDropdownButton<String>(
              enabled: widget.enabled,
              items: ['Male', 'Female']
                  .map(
                    (val) => DropdownMenuItem<String>(
                      value: val,
                      child: Text(val),
                    ),
                  )
                  .toList(),
              value: widget.host.gender,
              onChanged: (gender) => setState(() {
                widget.host.gender = gender;
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
              value: widget.host.phone,
              onChange: (phone) => setState(() {
                widget.host.phone = phone;
              }),
            ),
          ),
          const SizedBox(height: 10),
          FormGroup(
            label: 'Password',
            child: CustomFormField(
              enabled: widget.enabled,
              prefixIcon: const Icon(Icons.lock),
              hint: 'Minimum Length: 8',
              value: widget.host.password,
              onChange: (password) => setState(() {
                widget.host.password = password;
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
              value: widget.host.address,
              onChange: (address) => setState(() {
                widget.host.address = address;
              }),
              maxLines: 3,
            ),
          ),
          const SizedBox(height: 10),
          CustomFileUploadField(
            enabled: widget.enabled,
            title: 'Identity Card',
            value: widget.host.icPath,
            onChange: (path) => setState(() {
              widget.host.icPath = path;
            }),
          ),
          const SizedBox(height: 10),
          CustomFileUploadField(
            enabled: widget.enabled,
            title: 'License',
            value: widget.host.bankPath,
            onChange: (path) => setState(() {
              widget.host.bankPath = path;
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
                child: const Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
