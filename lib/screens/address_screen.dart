import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import '../app_styles.dart';

import '../services/database_service.dart';

import '../widgets/custom_app_drawer.dart';
import '../widgets/drawer_icon_button.dart';
import '../widgets/address_viewer.dart';
import '../widgets/main_loading.dart';

import './address_editor_screen.dart';

class AddressScreen extends StatefulWidget {
  static const routeName = '/address-screen';

  const AddressScreen({Key? key}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  var defaultAddress = '';

  getDefaultAddress() async {
    defaultAddress = await DatabaseService().getDefaultAddress();
  }

  setDefaultAddress(String addressId) async {
    await DatabaseService().setDefaultAddress(addressId);

    setState(() {});
  }

  @override
  void initState() {
    getDefaultAddress();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomAppDrawer(),
      body: SafeArea(
        child: FutureBuilder(
          future: DatabaseService().getAddress(),
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? const MainLoading()
              : ListView(
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: paddingHorizontal,
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const DrawerIconButton(),
                              Text(
                                'Your Addresses',
                                style: sourceSansProBold.copyWith(
                                  fontSize: 23,
                                  color: grey,
                                ),
                              ),
                              const SizedBox(), // Place something here
                            ],
                          ),
                          const SizedBox(height: 20),
                          ListTile(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(
                                AddressEditorScreen.routeName,
                              )
                                  .then((value) {
                                setState(() {});
                              });
                            },
                            style: ListTileStyle.drawer,
                            leading: const Icon(Icons.edit_location),
                            title: Text(
                              'Add new Address',
                              style: sourceSansProRegular.copyWith(
                                fontSize: 20,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_right_rounded,
                              size: 40,
                              color: grey,
                            ),
                          ),
                          const SizedBox(height: 20),
                          snapshot.hasData ||
                                  snapshot.data == null ||
                                  snapshot.data!.isEmpty
                              ? SizedBox(
                                  height: 500,
                                  width: double.infinity,
                                  child: ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) =>
                                        AddressViewer(
                                      addressId: snapshot.data![index].id,
                                      setDefaultAddress: setDefaultAddress,
                                      name: snapshot.data![index]
                                          .data()['fullName'],
                                      number: snapshot.data![index]
                                          ['mobNumber'],
                                      pinCode: snapshot.data![index]
                                          .data()['pinCode'],
                                      addressLine1: snapshot.data![index]
                                          ['addressLine1'],
                                      addressLine2: snapshot.data![index]
                                          .data()['addressLine2'],
                                      city:
                                          snapshot.data![index].data()['city'],
                                      state:
                                          snapshot.data![index].data()['state'],
                                      edit: () async {
                                        Navigator.of(context).pushNamed(
                                          AddressEditorScreen.routeName,
                                          arguments: {
                                            'isEditing': true,
                                            'addressId':
                                                snapshot.data![index].id,
                                            'name': snapshot.data![index]
                                                .data()['fullName'],
                                            'city': snapshot.data![index]
                                                .data()['city'],
                                            'addressLine1': snapshot
                                                .data![index]
                                                .data()['addressLine1'],
                                            'addressLine2': snapshot
                                                .data![index]
                                                .data()['addressLine2'],
                                            'number': snapshot.data![index]
                                                .data()['mobNumber'],
                                            'pinCode': snapshot.data![index]
                                                .data()['pinCode'],
                                            'state': snapshot.data![index]
                                                .data()['state'],
                                          },
                                        ).then((value) {
                                          setState(() {});
                                        });
                                      },
                                      delete: () async {
                                        showAnimatedDialog(
                                          context: context,
                                          animationType: DialogTransitionType
                                              .slideFromBottom,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          builder: (context) => AlertDialog(
                                            elevation: 5,
                                            alignment: Alignment.bottomCenter,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            title: const Text('Delete'),
                                            content: Text(
                                              'Are you sure you want to delete this address?',
                                              style:
                                                  sourceSansProRegular.copyWith(
                                                color: grey,
                                                fontSize: 18,
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () async {
                                                  await DatabaseService()
                                                      .deleteUserAddress(
                                                    snapshot.data![index].id,
                                                  );

                                                  if (mounted) {
                                                    Navigator.of(context).pop();
                                                  }

                                                  setState(() {});
                                                },
                                                child: Text(
                                                  'Yes',
                                                  style: sourceSansProSemiBold
                                                      .copyWith(
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
                                                  style: sourceSansProSemiBold
                                                      .copyWith(
                                                    color: orange,
                                                    fontSize: 20,
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
                              : Text(
                                  'You have no addresses saved',
                                  style: sourceSansProSemiBold.copyWith(
                                    fontSize: 18,
                                    color: grey,
                                  ),
                                ),
                          // AddressViewer(
                          //   name: 'Naresh Sharma',
                          //   city: 'Surat',
                          //   addressLine1:
                          //       'Sarthee township, opp. pacific school of engg.',
                          //   addressLine2: 'Tantithaiya',
                          //   number: '8347386059',
                          //   pinCode: '394305',
                          //   plotNo: '242',
                          //   state: 'Gujarat',
                          //   edit: () {
                          //     Navigator.of(context).pushNamed(
                          //       AddressEditorScreen.routeName,
                          //       arguments: {
                          //         'isEditing': true,
                          //         'name': 'Naresh Sharma',
                          //         'city': 'Surat',
                          //         'addressLine1':
                          //             'Sarthee township, opp. pacific school of engg.',
                          //         'addressLine2': 'Tantithaiya',
                          //         'number': '8347386059',
                          //         'pinCode': '394305',
                          //         'state': 'Gujarat',
                          //       },
                          //     );
                          //   },
                          //   delete: () {},
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
