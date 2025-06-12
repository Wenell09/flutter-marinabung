import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_marinabung/bloc/saving/saving_bloc.dart';

class ValidatonSavingCheck {
  inputSaving(Map<String, dynamic> data, BuildContext context) {
    if (data["name"] == "" ||
        data["target"] == "" ||
        data["nominal"] == "" ||
        data["estimation_day"] == "") {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Text(
              "Pastikan semua input telah terisi",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
        },
      );
    } else if (data["nominal"] >= data["target"]) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Text(
              "Pastikan nominal tidak melebihi target!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
        },
      );
    } else {
      context.read<SavingBloc>().add(AddSaving(data: data));
    }
  }
}
