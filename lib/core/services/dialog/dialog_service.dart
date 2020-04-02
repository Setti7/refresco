import 'dart:async';

import 'package:refresco/core/dataModels/alert/alert_request.dart';
import 'package:refresco/core/dataModels/alert/alert_response.dart';

class DialogService {
  Function(AlertRequest) _showDialogListener;
  Completer<AlertResponse> _dialogCompleter;

  /// Registers a callback function to show the dialog
  void registerDialogListener(Function(AlertRequest) showDialogListener) {
    _showDialogListener = showDialogListener;
  }

  /// Class the dialog listener and returns a Future that will wait for
  /// dialogComplete
  Future<AlertResponse> showDialog(AlertRequest alertRequest) {
    _dialogCompleter = Completer();
    _showDialogListener(alertRequest);
    return _dialogCompleter.future;
  }

  /// Completes the dialogCompleter to resume the Future's execution
  void dialogComplete(AlertResponse response) {
    _dialogCompleter.complete(response);
    _dialogCompleter = null;
  }
}
