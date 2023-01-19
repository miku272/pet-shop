import 'package:flutter/material.dart';

import '../app_styles.dart';

import '../services/database_service.dart';

class AddressViewer extends StatelessWidget {
  final String addressId;
  final String name;
  final String number;
  final String pinCode;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final VoidCallback edit;
  final VoidCallback delete;
  final Function(String) setDefaultAddress;

  const AddressViewer({
    Key? key,
    required this.addressId,
    required this.name,
    required this.number,
    required this.pinCode,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.edit,
    required this.delete,
    required this.setDefaultAddress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: sourceSansProBold.copyWith(
                  fontSize: 20,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            addressLine1,
            maxLines: 5,
            style: sourceSansProRegular.copyWith(
              fontSize: 20,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            addressLine2,
            maxLines: 2,
            style: sourceSansProRegular.copyWith(
              fontSize: 20,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '$city, $state, $pinCode',
            maxLines: 2,
            style: sourceSansProRegular.copyWith(
              fontSize: 20,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            'Phone Number: $number',
            style: sourceSansProRegular.copyWith(
              fontSize: 20,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              ElevatedButton(
                onPressed: edit,
                child: Text(
                  'Edit',
                  style: sourceSansProSemiBold.copyWith(
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              ElevatedButton(
                onPressed: delete,
                child: Text(
                  'Remove',
                  style: sourceSansProSemiBold.copyWith(
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              FutureBuilder(
                future: DatabaseService().getDefaultAddress(),
                builder: (context, snapshot) =>
                    snapshot.connectionState == ConnectionState.waiting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: boxShadowColor,
                            ),
                          )
                        : ElevatedButton(
                            onPressed: snapshot.data!.trim() == addressId.trim()
                                ? null
                                : () async {
                                    setDefaultAddress(addressId);
                                  },
                            child: Text(
                              snapshot.data!.trim() == addressId.trim()
                                  ? 'Default'
                                  : 'Set as default',
                              style: sourceSansProSemiBold.copyWith(
                                fontSize: 15,
                              ),
                            ),
                          ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
