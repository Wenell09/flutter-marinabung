part of 'photo_bloc.dart';

class PhotoEvent {}

final class UploadPhoto extends PhotoEvent {
  final String userId;
  UploadPhoto({required this.userId});
}

final class ResetPhoto extends PhotoEvent {}
