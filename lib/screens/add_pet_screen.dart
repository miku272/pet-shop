import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:pet_shop/services/database_service.dart';

import '../app_styles.dart';

import '../services/helper_function.dart';

import '../widgets/custom_textbox.dart';
import '../widgets/image_list_tile.dart';
import '../widgets/my_snackbar.dart';

class AddPetScreen extends StatefulWidget {
  static const routeName = '/app-pet-screen';

  const AddPetScreen({super.key});

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();

  final Map<int, String> months = {
    1: 'jan',
    2: 'feb',
    3: 'mar',
    4: 'apr',
    5: 'may',
    6: 'jun',
    7: 'jul',
    8: 'aug',
    9: 'sep',
    10: 'oct',
    11: 'nov',
    12: 'dec',
  };

  List<File> imageList = [];
  String? petType;
  var postingForAdoption = false;
  var petName = 'unspecified';
  var petBreed = 'unspecified';
  var petAge = 0;
  var petWeight = 0;
  var userLocation = '';
  var petDescription = '';

  var _isLoading = false;

  Future _uploadImage() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: <Widget>[
          InkWell(
            onTap: () async {
              final image = await HelperFunction.getImage('gallery');

              if (image != null) {
                setState(() {
                  imageList.add(image);
                });

                if (mounted) {
                  Navigator.of(context).pop();
                }
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: paddingHorizontal),
              child: Text(
                'Upload from gallery',
                style: sourceSansProSemiBold.copyWith(
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          InkWell(
            onTap: () async {
              final image = await HelperFunction.getImage('camera');

              if (image != null) {
                setState(() {
                  imageList.add(image);
                });

                if (mounted) {
                  Navigator.of(context).pop();
                }
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: paddingHorizontal),
              child: Text(
                'Upload from camera',
                style: sourceSansProSemiBold.copyWith(
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _getCurrentUserLocation() async {
    final location = Location();
    var permission = await location.hasPermission();

    if (permission == PermissionStatus.denied ||
        permission == PermissionStatus.deniedForever) {
      permission = await location.requestPermission();

      if (permission == PermissionStatus.denied ||
          permission == PermissionStatus.deniedForever) {
        return;
      }
    } else {
      final locationData = await location.getLocation();

      if (locationData.latitude != null && locationData.longitude != null) {
        final addr = await HelperFunction.getPlaceAddress(
          locationData.latitude!,
          locationData.longitude!,
        );

        setState(() {
          userLocation = addr;
        });
      }
    }
  }

  Future postPet() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      if (imageList.isEmpty) {
        MySnackbar.showSnackbar(
          context,
          black,
          'Please upload at least 1 image',
        );

        setState(() {
          _isLoading = false;
        });

        return;
      }

      if (userLocation == '') {
        MySnackbar.showSnackbar(
          context,
          black,
          'Please specify your current location',
        );

        setState(() {
          _isLoading = false;
        });

        return;
      }

      await DatabaseService().addPet(
        FirebaseAuth.instance.currentUser!.uid,
        '${DateTime.now().day} ${months[DateTime.now().month]} ${DateTime.now().year}',
        imageList,
        petType!,
        postingForAdoption,
        petName,
        petBreed,
        petAge,
        petWeight,
        userLocation,
        petDescription,
      );

      if (mounted) {
        MySnackbar.showSnackbar(context, black, 'Upload Complete');

        Navigator.of(context).pop();
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

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
                              onPressed: _uploadImage,
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
                  imageList.isNotEmpty
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5,
                          ),
                          height: 100,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 0.5,
                              color: lightGrey,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: imageList.length,
                            itemBuilder: (context, index) => ImageListTile(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => SimpleDialog(
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        height: 500,
                                        width: 500,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: FileImage(
                                              imageList[index],
                                            ),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              onLongPress: () async {
                                showDialog(
                                  context: context,
                                  builder: (context) => SimpleDialog(
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            imageList.removeAt(index);
                                          });

                                          if (mounted) {
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: paddingHorizontal,
                                          ),
                                          child: Text(
                                            'Remove',
                                            style:
                                                sourceSansProSemiBold.copyWith(
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              image: imageList[index],
                            ),
                          ),
                        )
                      : const SizedBox(),
                  imageList.isNotEmpty
                      ? const SizedBox(height: 20)
                      : const SizedBox(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                      validator: (value) {
                        if (value == null) {
                          return 'Please choose your pet type';
                        }

                        return null;
                      },
                      onChanged: (value) {
                        petType = value!;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        postingForAdoption = !postingForAdoption;
                      });
                    },
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                        left: 20,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 0.5,
                          color: lightGrey,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Availabe for adoption',
                            style: sourceSansProMedium.copyWith(
                              fontSize: 17,
                              color: grey,
                            ),
                          ),
                          Checkbox(
                            value: postingForAdoption,
                            onChanged: (value) {
                              setState(() {
                                postingForAdoption = value!;
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomTextbox(
                    prefixIcon: Icons.pets,
                    labelData: 'Pet Name',
                    onSave: (value) {
                      if (value != null) {
                        petName = value;
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTextbox(
                    prefixIcon: Icons.pets,
                    labelData: 'Pet Breed',
                    onSave: (value) {
                      if (value != null) {
                        petBreed = value;
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTextbox(
                    prefixIcon: Icons.numbers,
                    labelData: 'PetAge (In Months)',
                    textInputType: TextInputType.number,
                    onSave: (value) {
                      if (value != null) {
                        petAge = int.tryParse(value) ?? 0;
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTextbox(
                    prefixIcon: Icons.monitor_weight_rounded,
                    labelData: 'Pet Weight (In KGs)',
                    textInputType: TextInputType.number,
                    onSave: (value) {
                      if (value != null) {
                        petWeight = int.tryParse(value) ?? 0;
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    radius: 10,
                    onTap: _getCurrentUserLocation,
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                        left: 20,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 0.5,
                          color: lightGrey,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: <Widget>[
                          const Icon(
                            Icons.location_pin,
                            color: grey,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            userLocation == '' ? 'Get Location' : userLocation,
                            style: sourceSansProMedium.copyWith(
                              fontSize: 17,
                              color: grey,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 250,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: paddingHorizontal,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.5,
                        color: lightGrey,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SingleChildScrollView(
                      child: TextFormField(
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        cursorColor: grey,
                        decoration: const InputDecoration(
                          label: Text('Tell us more about your pet'),
                          labelStyle: TextStyle(
                            color: lightGrey,
                          ),
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 20) {
                            return 'Please tell us something about your pet';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          petDescription = value!;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: _isLoading ? () {} : postPet,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 65,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 63,
                      ),
                      decoration: BoxDecoration(
                        color: grey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: boxShadowColor,
                              )
                            : Text(
                                'Post',
                                style: sourceSansProBold.copyWith(
                                  color: boxShadowColor,
                                  fontSize: 20,
                                  letterSpacing: 2,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
