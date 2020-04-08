import 'package:flutter/material.dart';
import 'package:refresco/core/enums/enums.dart';
import 'package:refresco/utils/money.dart';

class PaymentMethod {
  final String name;
  final CardType type;
  final AssetImage image;
  int change;

  PaymentMethod({this.name, this.image, this.type, this.change});

  String details(int totalCartPrice) {
    if (type == null) {
      if (change == totalCartPrice) {
        return 'Sem troco';
      } else {
        final value = MoneyUtils.intMoneyAsString(change);
        return 'Troco para R\$ $value';
      }
    } else {
      return 'Cartão de $cardTypeAsString';
    }
  }

  String get nameWithType => '$name $cardTypeAsString';

  String get cardTypeAsString {
    if (type == CardType.debit) {
      return 'Débito';
    } else if (type == CardType.credit) {
      return 'Crédito';
    }

    return '';
  }

  static List<PaymentMethod> get methods => [
        PaymentMethod(
            name: 'Dinheiro',
            type: null,
            image: AssetImage('assets/icons/money_icon_96.png')),
        PaymentMethod(
            name: 'Visa',
            type: CardType.credit,
            image: AssetImage('assets/icons/visa_icon_96.png')),
        PaymentMethod(
            name: 'Mastercard',
            type: CardType.credit,
            image: AssetImage('assets/icons/mastercard_icon_96.png')),
        PaymentMethod(
            name: 'American Express',
            type: CardType.credit,
            image: AssetImage('assets/icons/amex_icon_96.png')),
        PaymentMethod(
            name: 'Visa',
            type: CardType.debit,
            image: AssetImage('assets/icons/visa_icon_96.png')),
        PaymentMethod(
            name: 'Mastercard',
            type: CardType.debit,
            image: AssetImage('assets/icons/mastercard_icon_96.png')),
      ];
}
