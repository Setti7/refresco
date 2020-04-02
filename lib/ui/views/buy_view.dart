import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:refresco/core/enums/enums.dart';
import 'package:refresco/core/dataModels/cart.dart';
import 'package:refresco/core/models/user.dart';
import 'package:refresco/core/viewModels/views/buy_model.dart';
import 'package:refresco/ui/theme.dart';
import 'package:refresco/ui/widgets/cart_sheet.dart';
import 'package:refresco/ui/widgets/store_card.dart';

import 'address_view.dart';
import 'base_view.dart';
import 'login_view.dart';

class BuyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, child) {
        return BaseView<BuyModel>(
          builder: (context, model, child) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Escolha uma revenda'),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                        user.isAnonymous ? Icons.vpn_key : Icons.exit_to_app),
                    onPressed: user.isAnonymous
                        ? () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => LoginView()))
                        : model.logout,
                  ),
                ],
              ),
              body: Stack(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Ink(
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            _buildAddress(context, user),
                          ],
                        ),
                      ),
                      _buildStoresList(context, model, user),
                    ],
                  ),
                  Consumer<Cart>(
                    builder: (context, cart, child) {
                      return cart.products.isNotEmpty
                          ? CartSheet(cart)
                          : Container();
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAddress(BuildContext context, User user) {
    return ListTile(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => AddressView()));
      },
      title: Text(
        user.address == null ? 'Endereço' : user.address.streetAndNumber,
        style: Theme.of(context).textTheme.headline6,
      ),
      subtitle: Text(
        user.address == null
            ? 'Escolha um endereço para entrega.'
            : user.address.districtAndCity,
        style: Theme.of(context).textTheme.subtitle1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Icon(
        Icons.location_on,
        color: AppColors.accent,
      ),
    );
  }

  Widget _buildStoresList(BuildContext context, BuyModel model, User user) {
    if (model.state == ViewState.busy) {
      return _buildLoading();
    } else {
      Widget child;

      if (model.errorTitle != null) {
        child = _buildError(context, model);
      } else if (model.stores.isEmpty) {
        child = _buildEmpty(context);
      } else {
        child = ListView.builder(
          itemCount: model.stores.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 32, bottom: 8),
                child: Text(
                  'As mais próximas:',
                  style: AppThemes.boldPlainHeadline6,
                ),
              );
            }

            return StoreCard(store: model.stores[index - 1]);
          },
        );
      }

      return Expanded(
        child: SmartRefresher(
          controller: model.refreshController,
          onRefresh: () => model.onRefresh(address: user.address),
          child: child,
        ),
      );
    }
  }

  Widget _buildLoading() {
    return Expanded(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildError(BuildContext context, BuyModel model) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              model.errorTitle,
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 8),
            Text(model.errorMessage ?? 'Houve um erro inesperado.'),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Não há nenhuma loja na sua área :(',
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
    );
  }
}
