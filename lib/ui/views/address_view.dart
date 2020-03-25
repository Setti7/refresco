import 'package:flutter/material.dart';
import 'package:flutter_base/core/models/user_address.dart';
import 'package:flutter_base/core/viewModels/address_model.dart';
import 'package:flutter_base/ui/theme.dart';
import 'package:flutter_base/ui/views/base_view.dart';
import 'package:flutter_base/ui/views/location_search_delegate.dart';

class AddressView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<AddressModel>(
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(title: Text("Endereço de entrega")),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: ListView(
              children: <Widget>[
                _buildAddressTile(context, model),
                SizedBox(height: 32),
                _buildNumberAndComplementFields(model),
                SizedBox(height: 24),
                _buildReferencePointField(model),
                SizedBox(height: 48),
                RaisedButton(
                  onPressed: () {
                    model.saveNewAddress();
                    Navigator.of(context).pop();
                  },
                  child: Text('SALVAR'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddressTile(BuildContext context, AddressModel model) {
    return InkWell(
      borderRadius: AppShapes.inputBorderRadius,
      onTap: () async {
        UserAddress address = await showSearch(
          context: context,
          delegate: LocationSearchDelegate(),
        );

        if (address != null) {
          model.updateSelectedAddress(address);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.07),
          borderRadius: AppShapes.inputBorderRadius,
        ),
        child: Row(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
              child: Icon(
                Icons.location_on,
                color: AppColors.primary,
                size: AppShapes.iconSize,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    model.selectedAddress?.streetName ?? 'Endereço',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 4),
                  Text(
                    model.selectedAddress?.districtAndCity ??
                        'Escolha um endereço.',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(
                Icons.chevron_right,
                color: AppColors.primary,
                size: AppShapes.iconSize,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberAndComplementFields(AddressModel model) {
    return Row(
      children: <Widget>[
        Flexible(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  "Número",
                  style: AppThemes.boldPlainHeadline6,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: model.numberController,
                decoration: InputDecoration(labelText: 'Número'),
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
        Flexible(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  "Apto / Bloco / Casa etc.",
                  style: AppThemes.boldPlainHeadline6,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: model.complementController,
                decoration: InputDecoration(labelText: 'Complemento'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReferencePointField(AddressModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 8),
          child: Text(
            "Ponto de referência",
            style: AppThemes.boldPlainHeadline6,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: model.pointOfReferenceController,
          decoration: InputDecoration(labelText: 'Ponto de referência'),
        ),
      ],
    );
  }
}