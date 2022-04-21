String formatNumberString(String value) {
  double doubleValue = double.parse(value);
  if (doubleValue.floor() == doubleValue) return doubleValue.toInt().toString();
  return ((doubleValue * 1000).round() / 1000.0).toString();
}
