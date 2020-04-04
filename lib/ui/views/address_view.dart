import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refresco/core/models/address.dart';
import 'package:refresco/core/models/user.dart';
import 'package:refresco/core/viewModels/views/address_model.dart';
import 'package:refresco/ui/delegates/location_search_delegate.dart';
import 'package:refresco/ui/theme.dart';
import 'package:refresco/ui/views/base_view.dart';

class AddressView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<User>(builder: (context, user, child) {
      return BaseView<AddressModel>(
        onModelReady: (model) {
          model.userAddress = user.address;
        },
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(title: Text('Endereço de entrega')),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: ListView(
                children: <Widget>[
                  _buildAddressField(context, model),
                  SizedBox(height: 32),
                  _buildNumberAndComplementFields(model),
                  SizedBox(height: 24),
                  _buildReferencePointField(model),
                  SizedBox(height: 48),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Center(
                        child: Text(model.errorMessage ?? '',
                            style: AppThemes.boldPlainHeadline6),
                      ),
                      SizedBox(height: 8),
                      RaisedButton(
                        onPressed: model.saveNewAddress,
                        child: Text('SALVAR'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildAddressField(BuildContext context, AddressModel model) {
    String headline;
    String subtitle;
    var address = model.showAddress;

    headline = address?.streetName ?? 'Endereço';
    subtitle = address?.districtAndCity ?? 'Escolha um endereço.';

    return InkWell(
      borderRadius: AppShapes.inputBorderRadius,
      onTap: () async {
        model.updateSelectedAddress(
          await showSearch<Address>(
            context: context,
            delegate: LocationSearchDelegate(),
          ),
        );
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
                    headline,
                    style: Theme.of(context).textTheme.headline6,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
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
                  'Número',
                  style: AppThemes.boldPlainHeadline6,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: model.numberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Número',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
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
                  'Apto / Bloco / Casa etc.',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: AppThemes.boldPlainHeadline6,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: model.complementController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Complemento',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
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
            'Ponto de referência',
            style: AppThemes.boldPlainHeadline6,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: model.pointOfReferenceController,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: 'Ponto de referência',
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
        ),
      ],
    );
  }
}
