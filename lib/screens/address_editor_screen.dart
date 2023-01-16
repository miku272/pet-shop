import 'package:flutter/material.dart';

import '../app_styles.dart';

import '../widgets/custom_textbox.dart';

class AddressEditorScreen extends StatelessWidget {
  static const routeName = '/address-editor-screen';

  const AddressEditorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map? modalArgs =
        ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>?;

    return AddressEditor(modalArgs);
  }
}

class AddressEditor extends StatefulWidget {
  final Map? args;

  const AddressEditor(this.args, {Key? key}) : super(key: key);

  @override
  State<AddressEditor> createState() => _AddressEditorState();
}

class _AddressEditorState extends State<AddressEditor> {
  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String fullName= '';
  String mobNumber = '' ;
  String pinCode = '';
  String addressLine1 = '';
  String addressLine2 = '';
  String city = '';
  String state = '';


  @override
  void initState() {
    if (widget.args != null && widget.args?['isEditing'] != null) {
      isEditing = widget.args?['isEditing'];
    }

    super.initState();
  }

  void addAddress () async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = false;
      });

      _formKey.currentState!.save();
    }
  }
  void updateAddress() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Address' : 'Add Address'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: paddingHorizontal),
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    CustomTextbox(
                      initValue: isEditing ? widget.args!['name'] : null,
                      prefixIcon: Icons.person,
                      labelData: 'Full Name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Name';
                        }

                        return null;
                      },
                      onSave: (value) {
                        fullName = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextbox(
                      initValue: isEditing ? widget.args!['number'] : null,
                      prefixIcon: Icons.phone,
                      textInputType: TextInputType.number,
                      labelData: 'Mobile Number',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Phone Number';
                        }

                        if (value.length < 10 || value.length > 10) {
                          return 'Number should be exactly 10 digits';
                        }

                        return null;
                      },
                      onSave: (value){
                        mobNumber = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextbox(
                      initValue: isEditing ? widget.args!['pinCode'] : null,
                      prefixIcon: Icons.confirmation_number,
                      textInputType: TextInputType.number,
                      labelData: 'Pin Code',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter pin code';
                        }

                        if (value.length < 6 || value.length > 6) {
                          return 'Number should be exactly 6 digits';
                        }

                        return null;
                      },
                      onSave: (value) {
                        pinCode =value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextbox(
                      initValue:
                          isEditing ? widget.args!['addressLine1'] : null,
                      prefixIcon: Icons.home,
                      labelData: 'Flat, House no, Building...',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter your flat no or house no';
                        }

                        return null;
                      },
                      onSave: (value) {
                        addressLine1 = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextbox(
                      initValue:
                          isEditing ? widget.args!['addressLine2'] : null,
                      prefixIcon: Icons.home,
                      labelData: 'Area, Street, Sector, Village...',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter your area';
                        }

                        return null;
                      },
                      onSave: (value) {
                        addressLine2 = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextbox(
                      initValue: isEditing ? widget.args!['city'] : null,
                      prefixIcon: Icons.home,
                      labelData: 'City',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter your city';
                        }

                        return null;
                      },
                      onSave: (value) {
                        city = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextbox(
                      initValue: isEditing ? widget.args!['state'] : null,
                      prefixIcon: Icons.home,
                      labelData: 'State',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter your State';
                        }

                        return null;
                      },
                      onSave: (value) {
                        state = value!;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              InkWell(
                onTap: isEditing ? updateAddress : addAddress,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 19,
                    horizontal: 63,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      isEditing ? 'Update Address' : 'Add Address',
                      style: sourceSansProBold.copyWith(
                        color: boxShadowColor,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
