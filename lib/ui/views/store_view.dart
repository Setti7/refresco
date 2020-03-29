import 'package:flutter/material.dart';
import 'package:flutter_base/core/enums/enums.dart';
import 'package:flutter_base/core/models/gallon.dart';
import 'package:flutter_base/core/models/store.dart';
import 'package:flutter_base/core/models/user.dart';
import 'package:flutter_base/core/viewModels/store_model.dart';
import 'package:flutter_base/ui/theme.dart';
import 'package:flutter_base/ui/views/base_view.dart';
import 'package:provider/provider.dart';

class StoreView extends StatelessWidget {
  final Store store;

  const StoreView(this.store);

  @override
  Widget build(BuildContext context) {
    return BaseView<StoreModel>(
      onModelReady: (model) {
        model.getGallons(store);
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(store.name),
          ),
          body: ListView(
            children: <Widget>[
              _buildStoreHeader(context, model),
              SizedBox(height: 32),
              model.state == ViewState.busy
                  ? _buildLoading(context)
                  : _buildItems(context, model),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStoreHeader(BuildContext context, StoreModel model) {
    return Consumer<User>(
      builder: (context, user, child) {
        return Container(
          color: Colors.white,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      store.name,
                      style: Theme.of(context).textTheme.headline5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(store.rating == null
                          ? 'Novo!'
                          : store.rating.toStringAsFixed(1)),
                      Icon(store.getStarIcon(), color: Colors.yellow, size: 20),
                    ],
                  )
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Entrega em ${store.minDeliveryTime}-${store.maxDeliveryTime} min',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Text(
                    model.getFormattedDistanceFromUser(user.address, store.address),
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildItems(BuildContext context, StoreModel model) {
    var children = <Widget>[];

    children = model.gallons.map<Widget>((g) {
      String priceDecimal =
          ((g.price % 1) * 10).truncate().toString().padRight(2, '0');
      String priceInteger = g.price.truncate().toString();
      String type = g.type == GallonType.l20 ? '20L' : '10L';

      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("${g.company} - $type",
                  textAlign: TextAlign.left,
                  style: AppThemes.boldPlainHeadline6),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyText2,
                  children: [
                    TextSpan(text: 'R\$'),
                    TextSpan(
                      text: '$priceInteger',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    TextSpan(text: ',$priceDecimal'),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();

    if (children.isEmpty) {
      return _buildEmpty(context);
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Text('Opa :(', style: Theme.of(context).textTheme.headline5),
          SizedBox(height: 8),
          Text('Houve um erro inesperado.')
        ],
      ),
    );
  }
}
