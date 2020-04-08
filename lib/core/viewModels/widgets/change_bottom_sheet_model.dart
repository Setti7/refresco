import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refresco/core/dataModels/cart.dart';
import 'package:refresco/core/enums/enums.dart';
import 'package:refresco/core/viewModels/base_model.dart';
import 'package:refresco/utils/money.dart';

class ChangeBottomSheetModel extends BaseModel {
  String errorMessage;
  TextEditingController controller;
  Cart cart;

  void validateField() {
    final value = MoneyUtils.intMoneyFromDouble(
      double.tryParse(controller.text),
    );

    if (value == null || value < cart.totalPrice) {
      errorMessage = 'O valor deve ser maior que R\$ ${cart.priceIntegers},${cart.priceDecimals}';
      setState(ViewState.idle);
    } else {
      return Get.back(result: value);
    }
  }
}
