part of 'detail_saving_bloc.dart';

class DetailSavingEvent {}

final class GetDetailSaving extends DetailSavingEvent {
  final String userId;
  final String savingId;
  GetDetailSaving({required this.userId, required this.savingId});
}
