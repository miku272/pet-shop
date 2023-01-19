import 'package:flutter/material.dart';

import '../app_styles.dart';

class AddressViewer extends StatelessWidget {
  final bool isDefault;
  final String name;
  final String number;
  final String pinCode;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final VoidCallback edit;
  final VoidCallback delete;

  const AddressViewer({
    Key? key,
    required this.isDefault,
    required this.name,
    required this.number,
    required this.pinCode,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.edit,
    required this.delete,
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
              ElevatedButton(
                onPressed: isDefault ? null : () {},
                child: Text(
                  isDefault ? 'Default' : 'Set as default',
                  style: sourceSansProSemiBold.copyWith(
                    fontSize: 15,
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
