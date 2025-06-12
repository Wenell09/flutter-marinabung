part of 'saving_bloc.dart';

class SavingEvent {}

final class AddSaving extends SavingEvent {
  final Map<String, dynamic> data;
  AddSaving({required this.data});
}

final class GetSaving extends SavingEvent {
  final String userId;
  GetSaving({required this.userId});
}

final class EditSaving extends SavingEvent {
  final Map<String, dynamic> data;
  EditSaving({required this.data});
}

final class DeleteSaving extends SavingEvent {
  final String userId, savingId;
  DeleteSaving({
    required this.userId,
    required this.savingId,
  });
}

final class SearchSaving extends SavingEvent {
  final String value;
  SearchSaving({required this.value});
}
