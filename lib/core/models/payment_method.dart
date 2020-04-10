import 'package:json_annotation/json_annotation.dart';
import 'package:refresco/core/enums/enums.dart';
import 'package:refresco/ui/views/payment_method_view.dart';
import 'package:refresco/ui/widgets/change_bottom_sheet.dart';
import 'package:refresco/utils/money.dart';

part 'payment_method.g.dart';


/// [PaymentMethod] is a class to represent how the user will pay for its
/// purchase.
///
/// If the user chose to pay with money, [type] will be null.
///
/// [change] is always null until the user goes to the [PaymentMethodView],
/// where, if he chooses to pay with money, a [ChangeBottomSheet] will appear.
///
/// [change] should only be null when the payment method is not money. If the
/// payment method was changed to money, the [PaymentMethod] should be updated
/// immediately after, setting [change] to an appropriate value (no lower than
/// the current cart price, and certainly not null).
@JsonSerializable(explicitToJson: true)
class PaymentMethod {
  @JsonKey(name: 'objectId')
  final String id;
  final String name;
  final CardType type;
  final String imageUri;
  final int change;

  PaymentMethod({this.id, this.name, this.imageUri, this.type, this.change});

  PaymentMethod clone({
    String id,
    String name,
    CardType type,
    String imageUri,
    int change,
  }) {
    return PaymentMethod(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        imageUri: imageUri ?? this.imageUri,
        change: change ?? this.change);
  }

  String details(int totalCartPrice) {
    if (type == null) {
      if (change < totalCartPrice) {
        return 'Defina o troco';
      }
      else if (change == totalCartPrice) {
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
            imageUri: 'assets/icons/money_icon_96.png'),
        PaymentMethod(
            name: 'Visa',
            type: CardType.credit,
            imageUri: 'assets/icons/visa_icon_96.png'),
        PaymentMethod(
            name: 'Mastercard',
            type: CardType.credit,
            imageUri: 'assets/icons/mastercard_icon_96.png'),
        PaymentMethod(
            name: 'American Express',
            type: CardType.credit,
            imageUri: 'assets/icons/amex_icon_96.png'),
        PaymentMethod(
            name: 'Visa',
            type: CardType.debit,
            imageUri: 'assets/icons/visa_icon_96.png'),
        PaymentMethod(
            name: 'Mastercard',
            type: CardType.debit,
            imageUri: 'assets/icons/mastercard_icon_96.png'),
      ];

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentMethodToJson(this);
}
