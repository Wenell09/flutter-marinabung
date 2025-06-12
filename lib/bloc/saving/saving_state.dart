part of 'saving_bloc.dart';

class SavingState {}

final class SavingInitial extends SavingState {}

final class SavingLoading extends SavingState {}

final class SavingLoaded extends SavingState {
  final List<SavingModel> dataSaving;
  final List<SavingModel> filteredDataSaving;
  SavingLoaded({
    required this.dataSaving,
    required this.filteredDataSaving,
  });
}

final class SavingError extends SavingState {}
