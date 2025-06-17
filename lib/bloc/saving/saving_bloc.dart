import 'package:bloc/bloc.dart';
import 'package:flutter_marinabung/models/saving_model.dart';
import 'package:flutter_marinabung/repository/saving_repository.dart';

part 'saving_event.dart';
part 'saving_state.dart';

class SavingBloc extends Bloc<SavingEvent, SavingState> {
  final SavingRepository savingRepository;
  SavingBloc(this.savingRepository) : super(SavingInitial()) {
    on<GetSaving>((event, emit) async {
      emit(SavingLoading());
      try {
        final savingData = await savingRepository.getSaving(event.userId);
        emit(SavingLoaded(
          dataSaving: savingData,
          filteredDataSaving: savingData,
        ));
      } catch (e) {
        emit(SavingError());
      }
    });
    on<SearchSaving>((event, emit) {
      if (state is SavingLoaded) {
        final currentState = state as SavingLoaded;
        final filteredDataSaving = currentState.dataSaving
            .where(
                (element) => element.name.toLowerCase().contains(event.value))
            .toList();
        emit(SavingLoaded(
          dataSaving: currentState.dataSaving,
          filteredDataSaving: filteredDataSaving,
        ));
      }
    });

    on<AddSaving>((event, emit) async {
      emit(SavingLoading());
      try {
        await savingRepository.addSaving(event.data);
        add(GetSaving(userId: event.data["user_id"]));
      } catch (e) {
        emit(SavingError());
      }
    });

    on<DeleteSaving>((event, emit) async {
      emit(SavingLoading());
      try {
        await savingRepository.deleteSaving(event.userId, event.savingId);
        add(GetSaving(userId: event.userId));
      } catch (e) {
        emit(SavingError());
      }
    });
  }
}
