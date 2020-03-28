import 'package:flutter/services.dart';
import 'package:flutter_parse/flutter_parse.dart';
import 'package:meta/meta.dart';

class ServiceResponse {
  final bool success;
  final ParseException parseException;
  final PlatformException firebaseException;

  const ServiceResponse({
    @required this.success,
    this.parseException,
    this.firebaseException,
  }) : assert(parseException == null || firebaseException == null);

  String get errorCode {
    if (parseException != null) {
      return parseException.code.toString();
    } else {
      return firebaseException.code;
    }
  }

  String get errorMessage {
    if (parseException != null) {
      return _getParseErrorMessage(parseException.code);
    } else if (firebaseException != null) {
      return _getFirebaseErrorMessage(firebaseException.code);
    } else {
      return null;
    }
  }

  String _getFirebaseErrorMessage(String code) {
    if (code == 'ERROR_INVALID_EMAIL') {
      return 'Email inválido';
    } else if (code == 'ERROR_WRONG_PASSWORD') {
      return 'Senha inválida';
    } else if (code == 'ERROR_USER_NOT_FOUND') {
      return 'Esse email não está registrado';
    } else if (code == 'ERROR_USER_DISABLED') {
      return 'Essa conta foi desativada';
    } else if (code == 'ERROR_TOO_MANY_REQUESTS') {
      return 'Nossos servidores estão sobrecarregados, tente novamente mais tarde';
    } else if (code == 'ERROR_OPERATION_NOT_ALLOWED') {
      return 'Um erro inesperado aconteceu';
    } else if (code == 'ERROR_WEAK_PASSWORD') {
      return 'Essa senha não é forte o suficiente';
    } else if (code == 'ERROR_EMAIL_ALREADY_IN_USE') {
      return 'Esse email já está em uso';
    } else {
      return 'Erro inesperado.';
    }
  }

  String _getParseErrorMessage(int code) {
    if (code == -1) {
      return 'Erro inesperado';
    } else if (code == 100) {
      return 'Conxão falhou';
    } else if (code == 101) {
      return 'Email/senha inválida';
    } else if (code == 102) {
      return 'Busca inválida';
    } else if (code == 103) {
      return 'Busca inválida';
    } else if (code == 104) {
      return 'Busca inválida';
    } else if (code == 105) {
      return 'Busca inválida';
    } else if (code == 106) {
      return 'Busca inválida';
    } else if (code == 107) {
      return 'Busca inválida';
    } else if (code == 108) {
      return 'Erro inesperado';
    } else if (code == 109) {
      return 'Erro inesperado';
    } else if (code == 111) {
      return 'Erro inesperado';
    } else if (code == 112) {
      return 'Erro inesperado';
    } else if (code == 115) {
      return 'Erro inesperado';
    } else if (code == 116) {
      return 'Erro inesperado';
    } else if (code == 119) {
      return 'Operação proibida';
    } else if (code == 120) {
      return 'Erro inesperado';
    } else if (code == 121) {
      return 'Erro inesperado';
    } else if (code == 122) {
      return 'Erro inesperado';
    } else if (code == 123) {
      return 'Erro de permissão';
    } else if (code == 124) {
      return 'Servidor demorou muito para responder';
    } else if (code == 125) {
      return 'Email inválido';
    } else if (code == 135) {
      return 'Falta algum campo obrigatório';
    } else if (code == 137) {
      return 'Algum valor está duplicado';
    } else if (code == 139) {
      return 'Valor inválido';
    } else if (code == 140) {
      return 'Cota excedida';
    } else if (code == 141) {
      return 'Erro inesperado';
    } else if (code == 142) {
      return 'Erro de validação';
    } else if (code == 153) {
      return 'Arquivo já foi deletado';
    } else if (code == 155) {
      return 'Cota excedidida';
    } else if (code == 160) {
      return 'Nome inválido';
    } else if (code == 200) {
      return 'Preencha o email';
    } else if (code == 201) {
      return 'Preencha a senha';
    } else if (code == 202) {
      return 'Esse email já está em uso';
    } else if (code == 203) {
      return 'Esse email já está em uso';
    } else if (code == 204) {
      return 'Preencha o email';
    } else if (code == 205) {
      return 'Email não encontrado';
    } else if (code == 206) {
      return 'Erro inesperado';
    } else if (code == 207) {
      return 'É necessário criar o usuário';
    } else if (code == 208) {
      return 'Conta já linkada';
    } else if (code == 209) {
      return 'Erro de sessão';
    } else if (code == 250) {
      return 'Erro inesperado';
    } else if (code == 251) {
      return 'Erro inesperado';
    } else {
      return 'Erro inesperado';
    }
  }
}
