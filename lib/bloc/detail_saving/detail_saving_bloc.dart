import 'package:bloc/bloc.dart';
import 'package:flutter_marinabung/models/saving_model.dart';
import 'package:flutter_marinabung/repository/saving_repository.dart';
part 'detail_saving_event.dart';
part 'detail_saving_state.dart';

class DetailSavingBloc extends Bloc<DetailSavingEvent, DetailSavingState> {
  final SavingRepository savingRepository;
  DetailSavingBloc(this.savingRepository) : super(DetailSavingInitial()) {
    on<GetDetailSaving>((event, emit) async {
      emit(DetailSavingLoading());
      try {
        final detailSaving = await savingRepository.getDetailSaving(
            event.userId, event.savingId);
        emit(DetailSavingLoaded(detailSaving: detailSaving));
      } catch (e) {
        emit(DetailSavingError());
      }
    });
  }
}
