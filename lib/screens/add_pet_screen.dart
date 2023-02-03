import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

import '../app_styles.dart';

import '../widgets/custom_textbox.dart';

class AddPetScreen extends StatefulWidget {
  static const routeName = '/app-pet-screen';

  const AddPetScreen({super.key});

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Add Pet Details',
          style: sourceSansProSemiBold.copyWith(
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: paddingHorizontal),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 20),
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300]!.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DottedBorder(
                      radius: const Radius.circular(20),
                      borderType: BorderType.RRect,
                      color: lightGrey,
                      strokeWidth: 1,
                      dashPattern: const [6, 6],
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Icon(
                              Icons.upload_file,
                              size: 50,
                            ),
                            Text(
                              'Upload image',
                              style: sourceSansProSemiBold.copyWith(
                                fontSize: 20,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                'Upload',
                                style: sourceSansProRegular.copyWith(
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.5,
                        color: lightGrey,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonFormField(
                      hint: const Text('Select type'),
                      borderRadius: BorderRadius.circular(20),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'dog',
                          child: Text('Dog'),
                        ),
                        DropdownMenuItem(
                          value: 'cat',
                          child: Text('Cat'),
                        ),
                      ],
                      onChanged: (value) {},
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomTextbox(
                    prefixIcon: Icons.pets,
                    labelData: 'Pet Name',
                    validator: (value) {
                      return null;
                    },
                    onSave: (value) {},
                  ),
                  const SizedBox(height: 10),
                  CustomTextbox(
                    prefixIcon: Icons.pets,
                    labelData: 'Pet Breed',
                    validator: (value) {
                      return null;
                    },
                    onSave: (value) {},
                  ),
                  const SizedBox(height: 10),
                  CustomTextbox(
                    prefixIcon: Icons.numbers,
                    labelData: 'PetAge (In Months)',
                    textInputType: TextInputType.number,
                    validator: (value) {
                      return null;
                    },
                    onSave: (value) {},
                  ),
                  const SizedBox(height: 10),
                  CustomTextbox(
                    prefixIcon: Icons.monitor_weight_rounded,
                    labelData: 'Pet Weight (In KGs)',
                    textInputType: TextInputType.number,
                    validator: (value) {
                      return null;
                    },
                    onSave: (value) {},
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
