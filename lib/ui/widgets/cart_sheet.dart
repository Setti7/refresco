import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:refresco/core/dataModels/cart.dart';
import 'package:refresco/core/models/user.dart';
import 'package:refresco/core/viewModels/widgets/cart_sheet_model.dart';
import 'package:refresco/ui/theme.dart';
import 'package:refresco/ui/views/base_view.dart';
import 'package:refresco/ui/widgets/address_tile.dart';
import 'package:refresco/utils/routing_constants.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class CartSheet extends StatelessWidget {
  final Cart cart;

  const CartSheet(
    this.cart, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<CartSheetModel>(
      builder: (context, model, child) {
        return SlidingSheet(
          controller: model.sheetController,
          closeSheetOnBackButtonPressed: true,
          cornerRadiusOnFullscreen: 0,
          cornerRadius: 16,
          elevation: 8,
          duration: Duration(milliseconds: 500),
          padding: EdgeInsets.zero,
          listener: model.sheetListener,
          snapSpec: const SnapSpec(
            snappings: [0.1, 1.0],
          ),
          headerBuilder: (context, state) => _buildHeader(context, model),
          builder: (context, state) {
            // This is the content of the sheet that will get
            // scrolled, if the content is bigger than the available
            // height of the sheet.
            return ColorFiltered(
              colorFilter: ColorFilter.mode(
                AppColors.primary.withOpacity(model.cartSheetOpacity),
                BlendMode.srcOver,
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    color: AppColors.scaffoldBackground,
                    height: MediaQuery.of(context).size.height,
                    child: _buildBody(context, model),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, CartSheetModel model) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Consumer<User>(builder: (context, user, child) {
            return Container(
              padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Entregar em',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  AddressTile(
                    contentPadding: EdgeInsets.zero,
                    address: user.address,
                    onPressed: () => Get.toNamed(AddressViewRoute),
                  ),
                ],
              ),
            );
          }),
        ),
        _buildProductList(context),
        Text('Total: ${cart.totalPrice}, subtotal, delivery fee'),
        Text('Pay'),
      ],
    );
  }

  Widget _buildProductList(BuildContext context) {
    var children = <Widget>[];

    cart.products.forEach((orderItem) {
      children.add(
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyText2,
                  children: [
                    TextSpan(
                        text: '${orderItem.amount}x ',
                        style: TextStyle(color: Colors.black45)),
                    TextSpan(
                        text: '${orderItem.product.company} - '
                            '${orderItem.product.typeAsString}',
                        style: AppThemes.boldPlainHeadline6),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyText2,
                  children: [
                    TextSpan(text: 'R\$'),
                    TextSpan(
                      text: '${orderItem.product.priceIntegers}',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    TextSpan(text: ',${orderItem.product.priceDecimals}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        color: Colors.white,
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, CartSheetModel model) {
    return Container(
      // Reduces padding as sheet expands
      padding: EdgeInsets.only(
        bottom: 16 * (1 - model.cartSheetScrollProgress),
      ),
      decoration: BoxDecoration(
        // Turns blue into white as sheet expands
        color: AppColors.primary.withOpacity(model.cartSheetOpacity),
      ),
      child: ListTile(
        onTap: model.toggleCart,

        /// As sheet expands, the first child begins to fade ou, while the
        /// second child begins to fade in.
        title: Stack(
          children: <Widget>[
            Opacity(
              opacity: model.cartSheetOpacity,
              child: Row(
                children: <Widget>[
                  Icon(Icons.shopping_cart, color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    'Carrinho',
                    style: Theme.of(context).accentTextTheme.headline6,
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_up, color: Colors.white),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: cart.totalItemAmount.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          TextSpan(
                            text: ' items',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Opacity(
              opacity: 1 - model.cartSheetOpacity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Detalhes',
                    style: AppThemes.boldPlainHeadline6,
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down, color: Colors.black45),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
