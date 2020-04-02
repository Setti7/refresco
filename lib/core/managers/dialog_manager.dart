import 'package:flutter/material.dart';
import 'package:refresco/core/dataModels/alert/alert_request.dart';
import 'package:refresco/core/dataModels/alert/alert_response.dart';
import 'package:refresco/core/services/dialog/dialog_service.dart';
import 'package:refresco/locator.dart';
import 'package:refresco/ui/theme.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DialogManager extends StatefulWidget {
  final Widget child;

  const DialogManager({Key key, this.child}) : super(key: key);

  @override
  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  final DialogService _dialogService = locator<DialogService>();

  @override
  void initState() {
    super.initState();

    /// Registering internal functions to show and close dialog with
    /// DialogService so they can be called from anywhere.
    _dialogService.registerDialogManagerCallbacks(_showDialog, _closeDialog);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _closeDialog() {
    Navigator.of(context).pop();
  }

  void _showDialog(AlertRequest alertRequest) {
    Alert(
      context: context,
      title: alertRequest.title,
      desc: alertRequest.description,
      type: alertRequest.type,
      style: AlertStyle(isCloseButton: false),
      closeFunction: () {
        _dialogService.dialogComplete(AlertResponse(confirmed: false));
      },
      content: alertRequest.content,
      buttons: [
        DialogButton(
          color: Colors.transparent,
          child: Text(
            alertRequest.cancelButtonTitle,
            style: Theme.of(context).textTheme.button,
          ),
          onPressed: () {
            _dialogService.dialogComplete(AlertResponse(confirmed: false));
            Navigator.of(context).pop();
          },
        ),
        DialogButton(
          color: AppColors.primary,
          child: Text(
            alertRequest.buttonTitle,
            style: Theme.of(context).accentTextTheme.button,
          ),
          onPressed: () {
            _dialogService.dialogComplete(AlertResponse(confirmed: true));
            Navigator.of(context).pop();
          },
        ),
      ],
    ).show();
  }
}
