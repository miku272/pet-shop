import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import '../app_styles.dart';

import '../services/helper_function.dart';
import '../services/database_service.dart';

import '../widgets/custom_textbox.dart';
import '../widgets/file_image_list_tile.dart';
import '../widgets/network_image_list_tile.dart';
import '../widgets/my_snackbar.dart';

class PetEditorScreen extends StatelessWidget {
  static const routeName = '/app-pet-screen';

  const PetEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map? modalArgs =
        ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>?;

    return PetEditor(modalArgs);
  }
}

class PetEditor extends StatefulWidget {
  final Map? args;

  const PetEditor(this.args, {super.key});

  @override
  State<PetEditor> createState() => _PetEditorState();
}

class _PetEditorState extends State<PetEditor> {
  var _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;

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
  var petColor = 'unspecified';
  var petAge = 0;
  var petWeight = 0;
  var userLocation = '';
  var petDescription = '';

  @override
  void initState() {
    if (widget.args != null && widget.args?['isEditing'] != null) {
      _isEditing = widget.args?['isEditing'];

      postingForAdoption = widget.args?['avlForAdopt'];

      userLocation = widget.args?['location'];
    }

    super.initState();
  }

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
        petColor,
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

  Future updatePet(String petId) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

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

      await DatabaseService().updatePet(
        petId,
        postingForAdoption,
        petName,
        petBreed,
        petAge,
        petColor,
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
          _isEditing ? 'Edit Pet Details' : 'Add Pet Details',
          style: sourceSansProSemiBold.copyWith(
            fontSize: 18,
          ),
        ),
        actions: _isEditing
            ? [
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: Tooltip(
                    message: 'Delete',
                    child: InkWell(
                      onTap: () {
                        showAnimatedDialog(
                          context: context,
                          barrierDismissible: true,
                          animationType: DialogTransitionType.slideFromBottom,
                          duration: const Duration(milliseconds: 300),
                          builder: (context) => AlertDialog(
                            elevation: 5,
                            alignment: Alignment.bottomCenter,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            title: const Text('Delete'),
                            content: Text(
                              'Are you sure you want to delete this post?',
                              style: sourceSansProRegular.copyWith(
                                color: grey,
                                fontSize: 18,
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () async {
                                  await DatabaseService().deletePetDataUsingUid(
                                    widget.args!['petId'],
                                  );

                                  if (mounted) {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: Text(
                                  'Yes',
                                  style: sourceSansProSemiBold.copyWith(
                                    color: orange,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'No',
                                  style: sourceSansProSemiBold.copyWith(
                                    color: orange,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.delete,
                        color: red,
                      ),
                    ),
                  ),
                ),
              ]
            : null,
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
                  !_isEditing
                      ? Container(
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
                        )
                      : const SizedBox(),
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
                            itemBuilder: (context, index) => FileImageListTile(
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
                  _isEditing
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
                            itemCount: widget.args!['imageList'].length,
                            itemBuilder: (context, index) =>
                                NetworkImageListTile(
                              imageUrl: widget.args!['imageList'][index],
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
                                            image: NetworkImage(
                                              widget.args!['imageList'][index],
                                            ),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      : const SizedBox(),
                  _isEditing ? const SizedBox(height: 20) : const SizedBox(),
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
                    child: !_isEditing
                        ? DropdownButtonFormField(
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
                            validator: _isEditing
                                ? (value) {
                                    if (value == null) {
                                      return 'Please choose your pet type';
                                    }

                                    return null;
                                  }
                                : null,
                            onChanged: (value) {
                              petType = value!;
                            },
                          )
                        : Container(
                            padding: const EdgeInsets.only(left: 20),
                            width: double.infinity,
                            height: 40,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Type: ${widget.args!['petType']}',
                              style: sourceSansProMedium.copyWith(
                                color: grey,
                                fontSize: 20,
                              ),
                            ),
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
                    initValue: _isEditing ? widget.args!['petName'] : null,
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
                    initValue: _isEditing ? widget.args!['petBreed'] : null,
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
                    initValue:
                        _isEditing ? widget.args!['petAge'].toString() : null,
                    prefixIcon: Icons.numbers,
                    labelData: 'Pet Age (In Months)',
                    textInputType: TextInputType.number,
                    onSave: (value) {
                      if (value != null) {
                        petAge = int.tryParse(value) ?? 0;
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTextbox(
                    initValue:
                        _isEditing ? widget.args!['petColor'].toString() : null,
                    prefixIcon: Icons.color_lens,
                    labelData: 'Pet Color',
                    onSave: (value) {
                      if (value != null) {
                        petColor = value;
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTextbox(
                    initValue: _isEditing
                        ? widget.args!['petWeight'].toString()
                        : null,
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
                        initialValue:
                            _isEditing ? widget.args!['description'] : null,
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
                    onTap: () {
                      if (!_isLoading) {
                        if (_isEditing) {
                          updatePet(widget.args!['petId']);
                        } else {
                          postPet();
                        }
                      } else {
                        () {};
                      }
                    },
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
                                _isEditing ? 'Update' : 'Post',
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
