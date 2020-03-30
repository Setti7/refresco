import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/core/viewModels/cart_sheet_model.dart';
import 'package:flutter_base/ui/theme.dart';
import 'package:flutter_base/ui/views/base_view.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class CartSheet extends StatelessWidget {
  const CartSheet({
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
            return Column(
              children: <Widget>[
                Container(
                  color: model.sheetController.state?.isExpanded == true
                      ? Colors.white
                      : AppColors.primary.withOpacity(model.cartSheetOpacity),
                  height: MediaQuery.of(context).size.height,
                  child: _buildBody(),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildBody() {
    return Center(
      child: Text('This is the content of the sheet'),
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
                            text: '1',
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
