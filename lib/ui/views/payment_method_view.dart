import 'package:flutter/material.dart';
import 'package:refresco/core/dataModels/cart.dart';
import 'package:refresco/core/models/payment_method.dart';
import 'package:refresco/core/viewModels/views/payment_method_model.dart';
import 'package:refresco/ui/theme.dart';
import 'package:refresco/ui/views/base_view.dart';

class PaymentMethodView extends StatelessWidget {
  final Cart cart;

  PaymentMethodView(this.cart);

  @override
  Widget build(BuildContext context) {
    return BaseView<PaymentMethodModel>(
      onModelReady: (model) => model.cart = cart,
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(title: Text('Forma de pagamento')),
          body: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 16),
                    Text(
                      'Pague na entrega',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Escolha uma das opções abaixo',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
              ),
              ...buildListView(context, model)
            ],
          ),
        );
      },
    );
  }

  List<Widget> buildListView(BuildContext context, PaymentMethodModel model) {
    return PaymentMethod.methods.map((paymentMethod) {
      return Ink(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            ListTile(
              onTap: () => model.setPaymentMethod(paymentMethod),
              title: Text(
                paymentMethod.nameWithType,
                style: AppFonts.normalPlainHeadline6Smaller,
              ),
              trailing: Image(
                image: AssetImage(paymentMethod.imageUri),
                width: AppShapes.cardIconSize,
              ),
            ),
            Divider(height: 0, indent: 16, endIndent: 16),
          ],
        ),
      );
    }).toList();
  }
}
