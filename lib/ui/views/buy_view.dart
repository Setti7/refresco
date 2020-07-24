import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:refresco/core/dataModels/cart.dart';
import 'package:refresco/core/enums/enums.dart';
import 'package:refresco/core/models/address.dart';
import 'package:refresco/core/models/user.dart';
import 'package:refresco/core/viewModels/views/buy_model.dart';
import 'package:refresco/ui/theme.dart';
import 'package:refresco/ui/widgets/address_tile.dart';
import 'package:refresco/ui/widgets/cart_sheet.dart';
import 'package:refresco/ui/widgets/store_card.dart';
import 'package:refresco/utils/routing_constants.dart';

import 'base_view.dart';

class BuyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<BuyModel>(
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Escolha uma revenda'),
            actions: <Widget>[
              Consumer<User>(builder: (context, user, child) {
                return IconButton(
                  icon: Icon(user.isAnonymous ? Icons.vpn_key : Icons.exit_to_app),
                  onPressed:
                      user.isAnonymous ? () => Get.toNamed(Router.LoginViewRoute) : model.logout,
                );
              }),
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
                        Consumer<Address>(builder: (context, address, child) {
                          return AddressTile(
                            address: address,
                            onPressed: () => Get.toNamed(Router.AddressViewRoute),
                          );
                        }),
                      ],
                    ),
                  ),
                  _buildStoresList(context, model),
                ],
              ),
              Consumer<Cart>(
                builder: (context, cart, child) {
                  return cart.orderItems.isNotEmpty ? CartSheet(cart) : Container();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStoresList(BuildContext context, BuyModel model) {
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
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 32, bottom: 8),
                child: Text(
                  'As mais próximas:',
                  style: AppFonts.boldPlainHeadline6,
                ),
              );
            }

            return StoreCard(store: model.stores[index - 1]);
          },
        );
      }

      return Expanded(
        child: child,
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/undraw/no_close_stores.png',
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Defina o endereço de entrega!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          RaisedButton(
            onPressed: () => Get.toNamed(Router.AddressViewRoute),
            child: Text(
              'ESCOLHA UM ENDEREÇO',
            ),
          ),
        ],
      ),
    );
  }

//  Widget _buildEmpty(BuildContext context) {
//    return Center(
//      child: Column(
//        mainAxisSize: MainAxisSize.min,
//        children: <Widget>[
//          Text(
//            'Não há nenhuma loja na sua área :(',
//            style: Theme.of(context).textTheme.headline6,
//          ),
//        ],
//      ),
//    );
//  }
}
