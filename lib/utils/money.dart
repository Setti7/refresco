class MoneyUtils {
  static String intMoneyAsString(int value) {
    final valueString = value.toString();
    final decimal = valueString.substring(valueString.length - 2);
    final integer = valueString.substring(0, valueString.length - 2);
    return '$integer,$decimal';
  }

  static int intMoneyFromDouble(double value) {
    if (value == null) return null;
    return (value * 100).truncate();
  }
}
