import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:refresco/core/dataModels/service_response.dart';
import 'package:refresco/core/enums/enums.dart';
import 'package:refresco/core/services/auth/auth_service.dart';
import 'package:refresco/core/viewModels/base_model.dart';
import 'package:refresco/locator.dart';

class LoginModel extends BaseModel {
  bool signIn = true;
  String errorMessage;

  // Services
  AuthService authService = locator<AuthService>();

  // Controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void changeAction(bool action) {
    signIn = !action;
    errorMessage = null;
    setState(ViewState.idle);
  }

  Future loginWithEmail() async {
    if (!_validateFields()) return;
    setState(ViewState.busy);
    ServiceResponse response;

    response = await _login(
      email: emailController.text,
      password: passwordController.text,
    );

    if (response.success) {
      Get.back();
    } else {
      errorMessage = response.errorMessage;
    }
    setState(ViewState.idle);
  }

  Future createUser() async {
    if (!_validateFields()) return;
    setState(ViewState.busy);
    ServiceResponse response;

    response = await authService.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );

    if (response.success) {
      Get.back();
    } else {
      errorMessage = response.errorMessage;
    }
    setState(ViewState.idle);
  }

  bool _validateFields() {
    if (passwordController.text.length < 8) {
      errorMessage = 'Essa senha não é forte o suficiente';
      setState(ViewState.idle);
      return false;
    }

    if (signIn) {
      if (emailController.text == '' || passwordController.text == '') {
        errorMessage = 'Por favor, preencha os campos';
        setState(ViewState.idle);
        return false;
      }
    } else {
      if (emailController.text == '' ||
          passwordController.text == '' ||
          confirmPasswordController.text == '') {
        errorMessage = 'Por favor, preencha os campos';
        setState(ViewState.idle);
        return false;
      } else if (passwordController.text != confirmPasswordController.text) {
        errorMessage = 'As senhas não são as mesmas';
        setState(ViewState.idle);
        return false;
      }
    }
    return true;
  }

  Future<ServiceResponse> _login(
      {@required String email, @required String password}) {
    return authService.loginWithEmail(
      email: email,
      password: password,
    );
  }
}
