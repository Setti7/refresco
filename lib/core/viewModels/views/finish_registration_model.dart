import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get/get.dart';
import 'package:refresco/core/enums/enums.dart';
import 'package:refresco/core/services/auth/auth_service.dart';
import 'package:refresco/core/viewModels/base_model.dart';
import 'package:refresco/locator.dart';

class FinishRegistrationModel extends BaseModel {
  AuthService authService = locator<AuthService>();

  // Controllers
  TextEditingController fullNameController = TextEditingController();
  MaskedTextController cellphoneController =
      MaskedTextController(mask: '(00) 00000-0000');

  MaskedTextController cpfController =
      MaskedTextController(mask: '000.000.000-00');

  String errorMessage;
  int currentStep = 0;
  bool reverse = false;
  bool keyboardVisible = false;

  FinishRegistrationModel() {
    KeyboardVisibilityNotification().addNewListener(onChange: (visible) {
      keyboardVisible = visible;
      setState(ViewState.idle);
    });

    cellphoneController.addListener(() {
      if (cellphoneController.text.length == 14) {
        cellphoneController.updateMask('(00) 0000-00000',
            moveCursorToEnd: false);
      } else {
        cellphoneController.updateMask('(00) 00000-0000',
            moveCursorToEnd: false);
      }
    });
  }

  void previousStep() {
    // If direction is to go forward, we need to first rebuild the screen with
    // the right animation direction
    if (reverse == false) {
      reverse = true;
      setState(ViewState.idle);
    }

    errorMessage = null;

    currentStep = currentStep - 1;
    setState(ViewState.idle);
  }

  void nextStep() async {
    if (currentStep == 0) {
      if (fullNameController.text.length < 4) {
        errorMessage = 'Insira seu nome completo';
        setState(ViewState.idle);
        return null;
      }
    } else if (currentStep == 1) {
      if (cellphoneController.text.length < 14) {
        errorMessage = 'Insira seu número de telefone';
        setState(ViewState.idle);
        return null;
      }
    } else if (currentStep == 2) {
      if (cpfController.text.length < 14) {
        errorMessage = 'Insira seu CPF';
        setState(ViewState.idle);
        return null;
      }
    }

    // Hide keyboard before animating
    if (keyboardVisible) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      await Future.delayed(kThemeAnimationDuration);
    }
    errorMessage = null;

    // If direction is to go back, we need to first rebuild the screen with the
    // right animation direction
    if (reverse == true) {
      reverse = false;
      setState(ViewState.idle);
    }

    if (currentStep == 2) {
      final oldUser = authService.getUser();
      final newUser = oldUser.clone(
        fullName: fullNameController.text,
        phone: cellphoneController.text,
        cpf: cpfController.text,
      );

      authService.updateUser(newUser);

      // Set currentStep to 0 we can pop the screen
      currentStep = 0;
      Get.back();
    } else {
      currentStep = currentStep + 1;
      setState(ViewState.idle);
    }
  }

  Future<bool> assesPop() async {
    if (currentStep == 0) {
      return true;
    } else {
      previousStep();
      return false;
    }
  }

  void reset() {
    currentStep = 0;
  }
}
