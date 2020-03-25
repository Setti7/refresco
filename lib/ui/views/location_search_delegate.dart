import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/core/services/service_locator.dart';
import 'package:flutter_base/core/viewModels/address_model.dart';
import 'package:flutter_base/ui/theme.dart';
import 'package:flutter_base/ui/widgets/current_location_tile.dart';
import 'package:geocoder/geocoder.dart';

class LocationSearchDelegate extends SearchDelegate {
  AddressModel model = locator<AddressModel>();

  @override
  String get searchFieldLabel => 'Buscar endereço';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          model.updateQuery(query);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        children: <Widget>[
          CurrentLocationTile(),
        ],
      );
    }

    model.updateQuery(query);

    return StreamBuilder<List<Address>>(
      stream: model.addressesObservable,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Column(
            children: <Widget>[
              CurrentLocationTile(),
              Spacer(),
              Center(child: CircularProgressIndicator()),
              Spacer(),
            ],
          );
        }

        var results = snapshot.data
            .where((Address address) => address.thoroughfare != null)
            .toList();

        if (results.length == 0) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CurrentLocationTile(),
                Spacer(),
                Text(
                  "Endereço não encontrado",
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 8),
                Text(
                  "Confira se o endreço digitado está correto.",
                ),
                Spacer(),
              ],
            ),
          );
        } else {
          return ListView.separated(
            separatorBuilder: (context, index) {
              return Container(color: AppColors.scaffoldBackground, height: 1);
            },
            itemCount: results.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) return CurrentLocationTile();

              var result = results[index - 1];
              String streetName = result.thoroughfare;
              String streetNumber = result.subThoroughfare;
              String tileTitle;

              if (streetNumber != null) {
                streetNumber = ', $streetNumber';
              } else {
                streetNumber = '';
              }
              tileTitle = "$streetName$streetNumber";

              return Ink(
                color: Colors.white,
                child: ListTile(
                  onTap: () {},
                  title: Text(tileTitle),
                  subtitle:
                      Text(result.addressLine, overflow: TextOverflow.ellipsis),
                ),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
      children: <Widget>[
        CurrentLocationTile(),
      ],
    );
  }
}
