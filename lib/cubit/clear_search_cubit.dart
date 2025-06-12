import 'package:flutter_bloc/flutter_bloc.dart';

class ClearSearchCubit extends Cubit<bool> {
  ClearSearchCubit() : super(false);

  void switchBool(String text) {
    if (text.isEmpty) {
      emit(false);
    } else {
      emit(true);
    }
  }
}
