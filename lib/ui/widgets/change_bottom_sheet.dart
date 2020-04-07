import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refresco/core/dataModels/cart.dart';
import 'package:refresco/utils/money.dart';

/// Bottom sheet to set the change needed for this purchase, if the user
/// selected to pay with money.
///
/// Will return the amount the user will pay in cash as [int] if the user set a
/// value and confirm it, or explicitly says doesn't need it, otherwise, will
/// return null
///
///   TODO:
///   - Set a validator for the field, so an error appears if the user set a
///   value lower than the total price of the order.
class ChangeBottomSheet extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final Cart cart;

  ChangeBottomSheet({
    Key key,
    @required this.cart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
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
              'Seu pedido deu R\$ ${cart.priceIntegers},${cart.priceDecimals}',
              style: Theme.of(context).textTheme.caption,
            ),
            SizedBox(height: 8),
            Row(
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: TextFormField(
                    controller: controller,
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
                      onPressed: () => Get.back(result: 0),
                      child: Text('Não preciso'),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 40),
            RaisedButton(
              onPressed: () {
                int value = MoneyUtils.intMoneyFromDouble(
                  double.tryParse(controller.text),
                );

                return Get.back(result: value);
              },
              child: Text('Confirmar'),
            )
          ],
        ),
      ),
    );
  }
}
