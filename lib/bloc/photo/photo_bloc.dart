import 'package:bloc/bloc.dart';
import 'package:flutter_marinabung/repository/photo_repository.dart';

part 'photo_event.dart';
part 'photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final PhotoRepository photoRepository;
  PhotoBloc(this.photoRepository) : super(PhotoState(photoUrl: {})) {
    on<UploadPhoto>((event, emit) async {
      final photoUrl = await photoRepository.uploadImage(event.userId);
      emit(PhotoState(photoUrl: photoUrl));
    });

    on<ResetPhoto>((event, emit) {
      emit(PhotoState(photoUrl: {}));
    });
  }
}
