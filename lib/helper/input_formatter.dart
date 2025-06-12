import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class InputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat.decimalPattern('id');
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Hapus semua titik (separator)
    String text = newValue.text.replaceAll('.', '');
    if (text.isEmpty) {
      return newValue.copyWith(text: '');
    }
    try {
      final number = int.parse(text);
      final newString = _formatter.format(number);

      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(offset: newString.length),
      );
    } catch (e) {
      return oldValue;
    }
  }
}
