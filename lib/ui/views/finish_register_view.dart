import 'package:flutter/material.dart';
import 'package:refresco/core/models/order.dart';
import 'package:refresco/core/models/user.dart';
import 'package:refresco/core/viewModels/views/finish_registration_model.dart';
import 'package:refresco/ui/views/base_view.dart';

/// [FinishRegistrationView] is used to complete the [User] information that is
/// missing for placing an [Order].
///
/// Receiver a [User] instance to initialize the field to the values already
/// used.
class FinishRegistrationView extends StatelessWidget {
  // full name
  // cell phone
  // cpf
  // gender?
  // age?

  @override
  Widget build(BuildContext context) {
    return BaseView<FinishRegistrationModel>(
      builder: (context, model, child) {
        return Scaffold(
          body: Center(
            child: Text('Finish registration'),
          ),
        );
      },
    );
  }
}
