import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refresco/ui/theme.dart';

class OrderSuccessDialog extends StatelessWidget {
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
              // TODO: add animation
              Icons.check_circle_outline,
              color: Colors.green,
              size: 100,
            ),
            SizedBox(height: 8),
            Text(
              'Pedido registrado!',
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Agora é só esperar a loja responder :)',
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.center,
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text('Voltar!'),
                  onPressed: Get.back,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
