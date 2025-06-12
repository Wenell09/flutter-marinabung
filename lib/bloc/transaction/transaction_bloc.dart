import 'package:bloc/bloc.dart';
import 'package:flutter_marinabung/models/transaction_model.dart';
import 'package:flutter_marinabung/repository/transaction_repository.dart';
part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository transactionRepository;
  TransactionBloc(this.transactionRepository) : super(TransactionInitial()) {
    on<GetTransaction>((event, emit) async {
      emit(TransactionLoading());
      try {
        final dataTransaction = await transactionRepository.getTransaction(
            event.savingId, event.userId);
        emit(TransactionLoaded(dataTransaction: dataTransaction));
      } catch (e) {
        emit(TransactionError());
      }
    });
    on<AddTransaction>((event, emit) async {
      emit(TransactionLoading());
      try {
        await transactionRepository.addTransaction(event.data);
        emit(TransactionAddSuccess());
        add(GetTransaction(
            savingId: event.data["saving_id"], userId: event.data["user_id"]));
      } catch (e) {
        emit(TransactionError());
      }
    });
  }
}
