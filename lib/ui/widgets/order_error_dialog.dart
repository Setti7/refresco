import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refresco/ui/theme.dart';

class OrderErrorDialog extends StatelessWidget {
  final String errorMessage;
  final String errorTitle;
  final Widget button1;
  final bool showBackButton;

  const OrderErrorDialog({
    this.errorMessage,
    this.errorTitle,
    this.button1,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final buttonBar = ButtonBar(
      children: <Widget>[
        showBackButton
            ? FlatButton(
                child: Text('Voltar'),
                onPressed: Get.back,
              )
            : Container(),
        button1 ?? Container(),
      ],
    );

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
              errorTitle ?? 'Opa :(',
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              errorMessage ?? 'Um erro inesperado ocorreu. Tente novamente.',
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.center,
            ),
            buttonBar
          ],
        ),
      ),
    );
  }
}
