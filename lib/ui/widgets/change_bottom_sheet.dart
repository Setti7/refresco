import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refresco/core/dataModels/cart.dart';
import 'package:refresco/core/viewModels/widgets/change_bottom_sheet_model.dart';
import 'package:refresco/ui/theme.dart';
import 'package:refresco/ui/views/base_view.dart';

/// [ChangeBottomSheet] is used to set the change needed for this purchase,
/// if the user selected to pay with money.
///
/// Will return the amount the user will pay in cash as [int] if the user set a
/// value and confirmed it, otherwise, will return null.
///
/// The user is not allowed to set a value lower than the cart's full price.
class ChangeBottomSheet extends StatefulWidget {
  final Cart cart;

  ChangeBottomSheet({
    Key key,
    @required this.cart,
  }) : super(key: key);

  @override
  _ChangeBottomSheetState createState() => _ChangeBottomSheetState();
}

class _ChangeBottomSheetState extends State<ChangeBottomSheet>
    with SingleTickerProviderStateMixin {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseView<ChangeBottomSheetModel>(onModelReady: (model) {
      model.cart = widget.cart;
      model.controller = controller;
    }, builder: (context, model, child) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 24.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Troco para quanto?',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 4),
              Text(
                'Digite abaixo o quanto irá pagar em dinheiro para o entregador',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              SizedBox(height: 24),
              Text(
                'Seu pedido deu R\$ ${model.cart.priceIntegers},${model.cart.priceDecimals}',
                style: Theme.of(context).textTheme.caption,
              ),
              SizedBox(height: 8),
              Row(
                children: <Widget>[
                  Flexible(
                    flex: 2,
                    child: TextFormField(
                      controller: model.controller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        isDense: true,
                        prefix: Text('R\$ '),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    fit: FlexFit.loose,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        onPressed: () => Get.back(result: model.cart.totalPrice),
                        child: Text('Não preciso'),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  AnimatedSize(
                    duration: Duration(milliseconds: 100),
                    vsync: this,
                    child: model.errorMessage != null
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              model.errorMessage ?? '',
                              style: AppFonts.normalPlainHeadline6Smaller,
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Container(),
                  ),
                  RaisedButton(
                    onPressed: model.validateField,
                    child: Text('Confirmar'),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
