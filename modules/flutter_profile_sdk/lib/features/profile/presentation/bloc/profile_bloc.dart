import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _repository;

  ProfileBloc(this._repository) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await _repository.getUserProfile(event.userId);
    result.fold(
      (error) => emit(ProfileError(error.toString())),
      (user) => emit(ProfileLoaded(user)),
    );
  }
}
