import 'package:asra_app_new/models/owner.dart';
import 'package:asra_app_new/widgets/form_field.dart';
import 'package:asra_app_new/widgets/form_group.dart';
import 'package:flutter/material.dart';

class OwnerInfoRegistration extends Dialog {
  final Owner owner;
  final int? ownerId;
  const OwnerInfoRegistration({
    required this.owner,
    this.ownerId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (ctx, setState) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 4,
        child: Card(
          shadowColor: Colors.grey,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Owner Information',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  const SizedBox(height: 10),
                  FormGroup(
                    label: 'Name',
                    child: CustomFormField(
                      value: owner.name,
                      onChange: (name) => setState(() => owner.name = name),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FormGroup(
                    label: 'Identity Card',
                    child: CustomFormField(
                      value: owner.ic,
                      onChange: (ic) => setState(() => owner.ic = ic),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FormGroup(
                    label: 'Bank Name',
                    child: CustomFormField(
                      value: owner.bankName,
                      onChange: (bankName) => setState(() {
                        owner.bankName = bankName;
                      }),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FormGroup(
                    label: 'Bank Account',
                    child: CustomFormField(
                      value: owner.bankNo,
                      onChange: (bankNo) => setState(() {
                        owner.bankNo = bankNo;
                      }),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FormGroup(
                    label: 'Gender',
                    child: CustomDropdownButton<String>(
                      hint: 'Please select',
                      items: ['Male', 'Female']
                          .map(
                            (g) => DropdownMenuItem<String>(
                              value: g,
                              child: Text(g),
                            ),
                          )
                          .toList(),
                      value: owner.gender,
                      onChanged: (gender) => setState(() {
                        owner.gender = gender;
                      }),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FormGroup(
                    label: 'Phone',
                    child: CustomFormField(
                      value: owner.phone,
                      onChange: (phone) => setState(() {
                        owner.phone = phone;
                      }),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FormGroup(
                    label: 'Address',
                    child: CustomFormField(
                      value: owner.address,
                      onChange: (address) => setState(() {
                        owner.address = address;
                      }),
                      maxLines: 3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FormGroup(
                    label: 'Identity Card Document',
                    child: CustomFileFormField(
                      title: 'Identity Card',
                      value: owner.icPath,
                      allowedExtensions: const ['pdf'],
                      onChange: (icPath) => setState(() {
                        owner.icPath = icPath;
                      }),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FormGroup(
                    label: 'Bank Statement Document',
                    child: CustomFileFormField(
                      title: 'Bank Statement',
                      value: owner.bankStatementPath,
                      allowedExtensions: const ['pdf'],
                      onChange: (bankStatementPath) => setState(() {
                        owner.bankStatementPath = bankStatementPath;
                      }),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
