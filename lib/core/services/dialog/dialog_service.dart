import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:refresco/core/dataModels/alert/alert_request.dart';
import 'package:refresco/core/dataModels/alert/alert_response.dart';

class DialogService {
  Function(AlertRequest) _showDialogCallback;
  VoidCallback _closeDialogCallback;
  Completer<AlertResponse> _dialogCompleter;

  bool dialogIsShown = false;

  /// Register the [DialogManager]'s internal functions ([_showDialog] and
  /// [_closeDialog]) to [DialogService]'s [showDialog] and [closeDialog].
  ///
  /// Because some data is needed to show a dialog (to customize the title,
  /// text, buttons, etc, the [showDialogCallback] needs to have, at least, one
  /// parameter: the request for the alert carrying all these data, or better,
  /// an [AlertRequest] instance.
  void registerDialogManagerCallbacks(
    Function(AlertRequest) showDialogCallback,
    VoidCallback closeDialogCallback,
  ) {
    _showDialogCallback = showDialogCallback;
    _closeDialogCallback = closeDialogCallback;
  }

  /// Calls the [DialogManager] callback to close the dialog.
  ///
  /// It is necessary to set the dialog as completed, with [dialogComplete],
  /// so the viewModel that called [showDialog]] can stop awaiting and resume
  /// execution.
  void closeDialog(AlertResponse response) {
    _closeDialogCallback();
    dialogComplete(response);
  }

  /// Calls the [DialogManager] callback to show the dialog and returns a future
  /// that is only completed when [dialogComplete] is called.
  Future<AlertResponse> showDialog(AlertRequest alertRequest) {
    _dialogCompleter = Completer();
    _showDialogCallback(alertRequest);
    dialogIsShown = true;
    return _dialogCompleter.future;
  }

  /// Completes the [_dialogCompleter] to resume the [Future]'s execution.
  void dialogComplete(AlertResponse response) {
    _dialogCompleter.complete(response);
    _dialogCompleter = null;
    dialogIsShown = false;
  }
}
