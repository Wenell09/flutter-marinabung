import 'package:flutter_bloc/flutter_bloc.dart';

class SelectEstimationCubit extends Cubit<int> {
  SelectEstimationCubit() : super(0);

  void changeIndex(int index) => emit(index);
  void resetIndex() => emit(0);
}
