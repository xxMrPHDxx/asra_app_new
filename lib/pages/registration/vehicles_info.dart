import 'package:asra_app_new/api.dart';
import 'package:asra_app_new/error.dart';
import 'package:asra_app_new/models/owner.dart';
import 'package:asra_app_new/models/vehicle.dart';
import 'package:asra_app_new/pages/registration/owner_info.dart';
import 'package:asra_app_new/widgets/form_field.dart';
import 'package:asra_app_new/widgets/form_group.dart';
import 'package:flutter/material.dart';

class VehicleClass {
  int id;
  String name;
  VehicleClass(this.id, this.name);
}

class VehicleModel {
  int id;
  String name;
  VehicleModel(this.id, this.name);
}

Future<List<VehicleClass>> getVehicleClasses() async {
  final response = await Api.get('/vehicle/classes');
  if (!response['success']) {
    throw Error(response['message']);
  }
  final classes = response['classes'] as List<dynamic>;
  return classes.map((cls) {
    return VehicleClass(cls['id'], cls['name']);
  }).toList(growable: false);
}

Future<List<VehicleModel>> getVehicleModels(int id) async {
  final response = await Api.get('/vehicle/$id/models');
  if (!response['success']) {
    throw Exception(response['message']);
  }
  final models = response['models'] as List<dynamic>;
  return models.map((e) => VehicleModel(e['id'], e['name'])).toList();
}

class _VehicleInfo extends StatefulWidget {
  final bool enabled;
  final List<VehicleClass> types;
  final Owner owner;
  final void Function()? onClose;

  const _VehicleInfo({
    this.enabled = true,
    required this.types,
    required this.owner,
    this.onClose,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VehicleInfoState();
}

class _VehicleInfoState extends State<_VehicleInfo> {
  List<VehicleModel> _models = [];

  @override
  void initState() {
    super.initState();
    if (widget.owner.vehicle.classId != null) {
      getVehicleModels(widget.owner.vehicle.classId!).then((models) {
        setState(() {
          _models = models;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehicle = widget.owner.vehicle;
    return Stack(
      children: [
        Card(
          color: Colors.grey.shade300,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                FormGroup(
                  label: 'Vehicle Type',
                  child: CustomDropdownButton<int>(
                    enabled: widget.enabled,
                    items: widget.types
                        .map(
                          (t) => DropdownMenuItem<int>(
                            value: t.id,
                            child: Text(t.name),
                          ),
                        )
                        .toList(),
                    value: vehicle.classId,
                    onChanged: (id) async {
                      final arr = await getVehicleModels(id);
                      setState(() {
                        vehicle.classId = id;
                        vehicle.modelId = null;
                        _models.length = 0;
                        _models.addAll(arr);
                      });
                    },
                  ),
                ),
                if (vehicle.classId != null) const SizedBox(height: 10),
                if (vehicle.classId != null)
                  vehicle.classId != null && _models.isEmpty
                      ? Text(
                          'No models available for this type',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.red),
                        )
                      : FormGroup(
                          label: 'Vehicle Model',
                          child: CustomDropdownButton<int>(
                            enabled: widget.enabled,
                            items: _models
                                .map(
                                  (t) => DropdownMenuItem<int>(
                                    value: t.id,
                                    child: Text(t.name),
                                  ),
                                )
                                .toList(),
                            value: _models.isEmpty ? null : vehicle.modelId,
                            onChanged: _models.isEmpty
                                ? null
                                : (id) {
                                    setState(() {
                                      vehicle.modelId = id;
                                    });
                                  },
                          ),
                        ),
                const SizedBox(height: 10),
                FormGroup(
                  label: 'Plate Number',
                  child: CustomFormField(
                    enabled: widget.enabled,
                    value: vehicle.plateNo,
                    onChange: (val) => setState(() {
                      vehicle.plateNo = val;
                    }),
                  ),
                ),
                const SizedBox(height: 10),
                FormGroup(
                  label: 'Insurance Document',
                  child: CustomFileFormField(
                    enabled: widget.enabled,
                    title: 'Insurance',
                    value: vehicle.insurancePath,
                    allowedExtensions: const ['pdf'],
                    onChange: (path) => setState(() {
                      vehicle.insurancePath = path;
                    }),
                  ),
                ),
                const SizedBox(height: 10),
                FormGroup(
                  label: 'Road Tax Document',
                  child: CustomFileFormField(
                    enabled: widget.enabled,
                    title: 'Road Tax',
                    value: vehicle.roadTaxPath,
                    allowedExtensions: const ['pdf'],
                    onChange: (path) => setState(() {
                      vehicle.roadTaxPath = path;
                    }),
                  ),
                ),
                const SizedBox(height: 10),
                FormGroup(
                  label: 'Owner Approval Document',
                  child: CustomFileFormField(
                    enabled: widget.enabled,
                    title: 'Owner Approval',
                    value: vehicle.ownerApprovalPath,
                    allowedExtensions: const ['pdf'],
                    onChange: (path) => setState(() {
                      vehicle.ownerApprovalPath = path;
                    }),
                  ),
                ),
                const SizedBox(height: 10),
                FormGroup(
                  label: 'Vehicle View (Front)',
                  child: CustomFileFormField(
                    enabled: widget.enabled,
                    title: 'Front View',
                    value: vehicle.frontView,
                    allowedExtensions: const ['jpg', 'png'],
                    onChange: (path) => setState(() {
                      vehicle.frontView = path;
                    }),
                  ),
                ),
                const SizedBox(height: 10),
                FormGroup(
                  label: 'Vehicle View (Left)',
                  child: CustomFileFormField(
                    enabled: widget.enabled,
                    title: 'Left View',
                    value: vehicle.leftView,
                    allowedExtensions: const ['jpg', 'png'],
                    onChange: (path) => setState(() {
                      vehicle.leftView = path;
                    }),
                  ),
                ),
                const SizedBox(height: 10),
                FormGroup(
                  label: 'Vehicle View (Right)',
                  child: CustomFileFormField(
                    enabled: widget.enabled,
                    title: 'Right View',
                    value: vehicle.rightView,
                    allowedExtensions: const ['jpg', 'png'],
                    onChange: (path) => setState(() {
                      vehicle.rightView = path;
                    }),
                  ),
                ),
                const SizedBox(height: 10),
                FormGroup(
                  label: 'Vehicle View (Rear)',
                  child: CustomFileFormField(
                    enabled: widget.enabled,
                    title: 'Rear View',
                    value: vehicle.rearView,
                    allowedExtensions: const ['jpg', 'png'],
                    onChange: (path) => setState(() {
                      vehicle.rearView = path;
                    }),
                  ),
                ),
                const SizedBox(height: 10),
                FormGroup(
                  label: 'Vehicle View (Inner)',
                  child: CustomFileFormField(
                    enabled: widget.enabled,
                    title: 'Inner View',
                    value: vehicle.innerView,
                    allowedExtensions: const ['jpg', 'png'],
                    onChange: (path) => setState(() {
                      vehicle.innerView = path;
                    }),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text('Owner Information'),
                  style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                    backgroundColor: MaterialStateProperty.resolveWith(
                      (states) {
                        final color = Colors.yellowAccent.shade700;
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.grey.shade400;
                        }
                        if (states.contains(MaterialState.pressed)) {
                          return color.withAlpha(100);
                        }
                        return color;
                      },
                    ),
                  ),
                  onPressed: !widget.enabled
                      ? null
                      : () {
                          showDialog(
                            context: context,
                            builder: (ctx) => OwnerInfoRegistration(
                              owner: widget.owner,
                            ),
                          );
                        },
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: SizedBox.square(
            dimension: 20,
            child: Center(
              child: ElevatedButton(
                onPressed: widget.onClose,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.red.shade400),
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                ),
                child: const Icon(Icons.close, size: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class VehiclesInfoRegistration extends StatefulWidget {
  final bool enabled;
  final List<Owner> owners;
  final int? limit;
  final void Function(Owner)? onAdded;
  final void Function(Owner)? onRemoved;
  const VehiclesInfoRegistration({
    this.enabled = true,
    required this.owners,
    this.limit,
    this.onAdded,
    this.onRemoved,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VehiclesInfoRegistrationState();
}

class _VehiclesInfoRegistrationState extends State<VehiclesInfoRegistration> {
  final List<VehicleClass> _classes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadVehicleTypes();
  }

  void _loadVehicleTypes() async {
    _classes.addAll(await getVehicleClasses());
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final notAddable =
        widget.limit != null && widget.owners.length >= widget.limit!;
    return SingleChildScrollView(
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                ...widget.owners
                    .map(
                      (owner) => _VehicleInfo(
                        enabled: widget.enabled,
                        types: _classes,
                        owner: owner,
                        onClose: () {
                          widget.onRemoved?.call(owner);
                        },
                      ),
                    )
                    .toList(),
                ElevatedButton.icon(
                  onPressed: !widget.enabled || notAddable
                      ? null
                      : () {
                          widget.onAdded?.call(
                            Owner(
                              name: '',
                              ic: '',
                              phone: '',
                              address: '',
                              vehicle: Vehicle(),
                            ),
                          );
                        },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Vehicle'),
                ),
              ],
            ),
    );
  }
}
