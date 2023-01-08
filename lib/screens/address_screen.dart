import 'package:flutter/material.dart';

import '../app_styles.dart';

import '../widgets/custom_app_drawer.dart';
import '../widgets/drawer_icon_button.dart';
import '../widgets/address_viewer.dart';

import './address_editor_screen.dart';

class AddressScreen extends StatefulWidget {
  static const routeName = '/address-screen';

  const AddressScreen({Key? key}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomAppDrawer(),
      body: SafeArea(
        child: ListView(
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
                      Navigator.of(context).pushNamed(
                        AddressEditorScreen.routeName,
                      );
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
                  AddressViewer(
                    name: 'Naresh Sharma',
                    city: 'Surat',
                    addressLine1:
                        'Sarthee township, opp. pacific school of engg.',
                    addressLine2: 'Tantithaiya',
                    number: '8347386059',
                    pinCode: '394305',
                    plotNo: '242',
                    state: 'Gujarat',
                    edit: () {
                      Navigator.of(context).pushNamed(
                        AddressEditorScreen.routeName,
                        arguments: {
                          'isEditing': true,
                          'name': 'Naresh Sharma',
                          'city': 'Surat',
                          'addressLine1':
                              'Sarthee township, opp. pacific school of engg.',
                          'addressLine2': 'Tantithaiya',
                          'number': '8347386059',
                          'pinCode': '394305',
                          'plotNo': '242',
                          'state': 'Gujarat',
                        },
                      );
                    },
                    delete: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
