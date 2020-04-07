class MoneyUtils {
  static String intMoneyAsString(int value) {
    String valueString = value.toString();
    String decimal = valueString.substring(valueString.length - 2);
    String integer = valueString.substring(0, valueString.length - 2);
    return '$integer,$decimal';
  }

  static int intMoneyFromDouble(double value) {
    return (value * 100).truncate();
  }
}
