import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/core/enums/enums.dart';
import 'package:flutter_base/core/services/auth_service.dart';
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
    if (!_validateField()) return;
    setState(ViewState.busy);
    bool result;

    try {
      result = await _login(
        email: emailController.text,
        password: passwordController.text,
      );
      errorMessage = null;
    } on PlatformException catch (error) {
      errorMessage = _getErrorMessage(error.code);
    }

    setState(ViewState.idle);
    if (result == true) Navigator.pop(context);
  }

  Future createUser(BuildContext context) async {
    if (!_validateField()) return;
    setState(ViewState.busy);
    bool result;

    try {
      result = await authService.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      result = await _login(
        email: emailController.text,
        password: passwordController.text,
      );
      errorMessage = null;
    } on PlatformException catch (error) {
      errorMessage = _getErrorMessage(error.code);
    }

    setState(ViewState.idle);
    if (result == true) {
      Navigator.pop(context);
    }
  }

  bool _validateField() {
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

  Future<bool> _login({@required String email, @required String password}) {
    return authService.loginWithEmail(
      email: email,
      password: password,
    );
  }

  String _getErrorMessage(String code) {
    if (code == 'ERROR_INVALID_EMAIL')
      return "Email inválido";
    else if (code == 'ERROR_WRONG_PASSWORD')
      return 'Senha inválida';
    else if (code == 'ERROR_USER_NOT_FOUND')
      return 'Esse email não está registrado';
    else if (code == 'ERROR_USER_DISABLED')
      return 'Essa conta foi desativada';
    else if (code == 'ERROR_TOO_MANY_REQUESTS')
      return 'Nossos servidores estão sobrecarregados, tente novamente mais tarde';
    else if (code == 'ERROR_OPERATION_NOT_ALLOWED')
      return 'Um erro inesperado aconteceu';
    else if (code == 'ERROR_WEAK_PASSWORD')
      return 'Essa senha não é forte o suficiente';
    else if (code == 'ERROR_EMAIL_ALREADY_IN_USE')
      return 'Esse email já está em uso';
    else
      return "Um erro inesperado aconteceu";
  }
}
