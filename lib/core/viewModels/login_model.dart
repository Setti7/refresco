import 'package:flutter/cupertino.dart';
import 'package:flutter_base/core/enums/enums.dart';
import 'package:flutter_base/core/services/service_response.dart';
import 'package:flutter_base/core/services/auth/auth_service.dart';
import 'package:flutter_base/core/viewModels/base_model.dart';
import 'package:flutter_base/locator.dart';

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

  Future loginWithEmail(BuildContext context) async {
    if (!_validateFields()) return;
    setState(ViewState.busy);
    ServiceResponse response;

    response = await _login(
      email: emailController.text,
      password: passwordController.text,
    );

    if (response.success) {
      Navigator.pop(context);
    } else {
      errorMessage = response.message;
    }
    setState(ViewState.idle);
  }

  Future createUser(BuildContext context) async {
    if (!_validateFields()) return;
    setState(ViewState.busy);
    ServiceResponse response;

    response = await authService.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );

    if (response.success) {
      Navigator.pop(context);
    } else {
      errorMessage = response.message;
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
