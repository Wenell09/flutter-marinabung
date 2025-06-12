import 'package:flutter_bloc/flutter_bloc.dart';

class IndexBottomCubit extends Cubit<int> {
  IndexBottomCubit() : super(0);

  void changeIndex(int index) => emit(index);
}
