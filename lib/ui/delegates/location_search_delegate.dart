import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refresco/core/models/address.dart';
import 'package:refresco/core/viewModels/views/location_search_model.dart';
import 'package:refresco/locator.dart';
import 'package:refresco/ui/theme.dart';
import 'package:refresco/ui/widgets/current_location_tile.dart';

class LocationSearchDelegate extends SearchDelegate<Address> {
  LocationSearchModel model = locator<LocationSearchModel>();

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
          CurrentLocationTile(
            closeCallback: close,
            searchContext: context,
          ),
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
              CurrentLocationTile(
                closeCallback: close,
                searchContext: context,
              ),
              Spacer(),
              Center(child: CircularProgressIndicator()),
              Spacer(),
            ],
          );
        }

        final results = snapshot.data;

        if (results.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CurrentLocationTile(
                  closeCallback: close,
                  searchContext: context,
                ),
                Spacer(),
                Text(
                  'Endereço não encontrado',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 8),
                Text(
                  'Confira se o endreço digitado está correto.',
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
              if (index == 0) {
                return CurrentLocationTile(
                  closeCallback: close,
                  searchContext: context,
                );
              }

              final result = results[index - 1];

              return Ink(
                color: Colors.white,
                child: ListTile(
                  onTap: () => close(context, result),
                  title: Text(result.simpleAddress),
                  subtitle: Text(
                    result.districtAndCity,
                    overflow: TextOverflow.ellipsis,
                  ),
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
        CurrentLocationTile(
          closeCallback: close,
          searchContext: context,
        ),
      ],
    );
  }
}
