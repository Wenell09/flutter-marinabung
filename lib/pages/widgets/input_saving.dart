import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_marinabung/helper/input_formatter.dart';

class InputSaving extends StatelessWidget {
  final String type;
  final TextEditingController controller;
  const InputSaving({
    super.key,
    required this.type,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: Colors.white,
      maxLength: maxLength(type),
      buildCounter: (context,
              {required currentLength,
              required isFocused,
              required maxLength}) =>
          null,
      keyboardType: keyboardType(type),
      inputFormatters: (type == "nama" || type == "note")
          ? null
          : [
              FilteringTextInputFormatter.digitsOnly,
              InputFormatter(),
            ],
      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText(type),
        hintStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        filled: true,
        fillColor: Colors.black,
        border: OutlineInputBorder(),
      ),
    );
  }
}

hintText(String type) {
  switch (type) {
    case "nama":
      return "Masukkan nama tabungan";
    case "note":
      return "Masukkan deskripsi";
    case "target":
      return "Masukkan target jumlah tabungan";
    case "nominal":
      return "Masukkan nominal yang ingin ditabung";
  }
}

maxLength(String type) {
  switch (type) {
    case "nama":
      return 20;
    case "note":
      return 20;
    case "target":
      return 11;
    case "nominal":
      return 11;
  }
}

keyboardType(String type) {
  switch (type) {
    case "nama":
      return TextInputType.name;
    case "note":
      return TextInputType.name;
    case "target":
      return TextInputType.number;
    case "nominal":
      return TextInputType.number;
  }
}
