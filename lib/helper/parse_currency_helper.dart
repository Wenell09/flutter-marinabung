class ParseCurrencyHelper {
  int parseCurrencyToInt(String value) {
    return int.parse(value.replaceAll(".", "").replaceAll(" ", ""));
  }
}
