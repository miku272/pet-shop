import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

import '../app_styles.dart';

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
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: DottedBorder(
                      radius: const Radius.circular(50),
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
                          ),
                          Text(
                            'Upload image',
                            style: sourceSansProBold.copyWith(
                              fontSize: 20,
                            ),
                          )
                        ],
                      )),
                    ),
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
