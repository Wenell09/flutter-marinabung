part of 'detail_saving_bloc.dart';

class DetailSavingState {}

final class DetailSavingInitial extends DetailSavingState {}

final class DetailSavingLoading extends DetailSavingState {}

final class DetailSavingLoaded extends DetailSavingState {
  final List<SavingModel> detailSaving;
  DetailSavingLoaded({required this.detailSaving});
}

final class DetailSavingError extends DetailSavingState {}
