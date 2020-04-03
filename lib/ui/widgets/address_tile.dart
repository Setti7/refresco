import 'package:flutter/material.dart';
import 'package:refresco/core/models/address.dart';
import 'package:refresco/ui/theme.dart';

class AddressTile extends StatelessWidget {
  const AddressTile({
    Key key,
    @required this.onPressed,
    @required this.address,
    this.contentPadding
  }) : super(key: key);

  final VoidCallback onPressed;
  final Address address;
  final EdgeInsets contentPadding;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: contentPadding,
      onTap: onPressed,
      title: Text(
        address == null ? 'Endereço' : address.streetAndNumber,
        style: Theme.of(context).textTheme.headline6,
      ),
      subtitle: Text(
        address == null
            ? 'Escolha um endereço para entrega.'
            : address.districtAndCity,
        style: Theme.of(context).textTheme.subtitle1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Icon(
        Icons.location_on,
        color: AppColors.accent,
      ),
    );
  }
}
