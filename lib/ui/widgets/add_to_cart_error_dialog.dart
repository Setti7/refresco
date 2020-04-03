import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refresco/ui/theme.dart';

class AddToCartErrorDialog extends StatelessWidget {
  VoidCallback onConfirm;

  AddToCartErrorDialog({this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: AppShapes.cardBorderRadius),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.error_outline,
              color: AppColors.accent,
              size: 100,
            ),
            SizedBox(height: 8),
            Text(
              'Seu carrinho já tem produtos de outra loja',
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Caso queira comprar os produtos dessa loja, limpe antes o seu carrinho.',
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.center,
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text("Voltar"),
                  onPressed: () {
                    return Get.back(result: true);
                  },
                ),
                RaisedButton(
                  child: Text("Limpar"),
                  onPressed: () {
                    if (onConfirm != null) onConfirm();

                    return Get.back(result: true);
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
