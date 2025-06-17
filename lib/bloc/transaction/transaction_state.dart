part of 'transaction_bloc.dart';

sealed class TransactionState {}

final class TransactionInitial extends TransactionState {}

final class TransactionLoading extends TransactionState {}

final class TransactionLoaded extends TransactionState {
  final List<TransactionModel> dataTransaction;
  TransactionLoaded({required this.dataTransaction});
}

final class TransactionAddSuccess extends TransactionState {}

final class TransactionDeleteSuccess extends TransactionState {}

final class TransactionError extends TransactionState {}
