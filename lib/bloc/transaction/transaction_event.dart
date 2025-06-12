part of 'transaction_bloc.dart';

class TransactionEvent {}

final class AddTransaction extends TransactionEvent {
  final Map<String, dynamic> data;
  AddTransaction({required this.data});
}

final class GetTransaction extends TransactionEvent {
  final String savingId;
  final String userId;
  GetTransaction({
    required this.savingId,
    required this.userId,
  });
}
