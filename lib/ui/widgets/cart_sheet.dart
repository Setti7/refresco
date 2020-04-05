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
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CartSheet extends StatelessWidget {
  final Cart cart;
  final PanelController panelController = PanelController();

  CartSheet(
    this.cart, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var panelMaxHeight = MediaQuery.of(context).size.height -
        kToolbarHeight -
        MediaQuery.of(context).padding.top;

    return BaseView<CartSheetModel>(
      onModelReady: (model) => model.panelController = panelController,
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: model.assesPop,
          child: SlidingUpPanel(
            controller: model.panelController,
            backdropEnabled: true,
            minHeight: kBottomNavigationBarHeight,
            borderRadius: AppShapes.bottomSheetBorderRadius,
            maxHeight: panelMaxHeight,
            onPanelSlide: model.sheetListener,
            panelBuilder: (scrollController) {
              return _buildBody(context, model, scrollController);
            },
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, CartSheetModel model,
      ScrollController scrollController) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius:
            AppShapes.bottomSheetBorderRadius * model.cartSheetOpacity,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildHeader(context, model),
          Expanded(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                AppColors.primary.withOpacity(model.cartSheetOpacity),
                BlendMode.srcOver,
              ),
              child: ListView(
                controller: scrollController,
                padding: EdgeInsets.only(bottom: 40),
                children: <Widget>[
                  _buildAddressTile(),
                  SizedBox(height: 8),
                  _buildStore(),
                  _buildProductList(context, model),
                  _buildPaymentDetails(context),
                  SizedBox(height: 8),
                  _buildPayment(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildPayment(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Pagamento',
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(height: 24),
          Material(
            child: InkWell(
              borderRadius: AppShapes.inputBorderRadius,
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.07),
                  borderRadius: AppShapes.inputBorderRadius,
                ),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 24),
                      child: Icon(
                        Icons.credit_card,
                        color: AppColors.primary,
                        size: AppShapes.iconSize,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Forma de pagamento',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Escolha uma forma',
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
            ),
          ),
          SizedBox(height: 24),
          Center(
            child: RaisedButton(
              onPressed: cart.products.isEmpty ? null : () {},
              child: Text('Finalizar pagamento'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStore() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                cart.store?.name ?? 'Seu carrinho está vazio!',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary[900]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressTile() {
    return Consumer<User>(builder: (context, user, child) {
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
    });
  }

  Widget _buildPaymentDetails(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(bottom: 16, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          cart.products.isEmpty ? Container() : Divider(),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Subtotal:',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black38),
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black38,
                  ),
                  children: [
                    TextSpan(
                      text: 'R\$ ',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    TextSpan(text: cart.priceIntegers),
                    TextSpan(text: ',${cart.priceDecimals}'),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Taxa de entrega:',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black38),
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black38,
                  ),
                  children: [
                    TextSpan(
                      text: 'R\$ ',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    TextSpan(text: '0'),
                    TextSpan(text: ',00'),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Total:',
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                'R\$ ${cart.priceIntegers},${cart.priceDecimals}',
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildProductList(BuildContext context, CartSheetModel model) {
    var children = <Widget>[];

    children.add(
      Column(
        children: <Widget>[
          Divider(),
          FlatButton(
            onPressed: cart.store == null
                ? null
                : () => Get.toNamed(
                      StoreViewRoute,
                      arguments: cart.store,
                    ),
            child: Text('Adicionar mais itens'),
          ),
          Divider(),
        ],
      ),
    );

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
                  style: AppThemes.boldPlainHeadline6,
                  children: [
                    TextSpan(
                      text: 'R\$ ',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    TextSpan(text: orderItem.product.priceIntegers),
                    TextSpan(text: ',${orderItem.product.priceDecimals}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });

    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 8),
      child: Column(
        children: children,
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
        borderRadius:
            AppShapes.bottomSheetBorderRadius * model.cartSheetOpacity,
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
