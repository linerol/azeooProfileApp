import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_profile_sdk/features/profile/domain/entities/user_entity.dart';
import 'package:flutter_profile_sdk/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_profile_sdk/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:flutter_profile_sdk/features/profile/presentation/bloc/profile_event.dart';
import 'package:flutter_profile_sdk/features/profile/presentation/bloc/profile_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  group('ProfileBloc', () {
    late ProfileBloc profileBloc;
    late MockProfileRepository mockProfileRepository;

    setUp(() {
      mockProfileRepository = MockProfileRepository();
      profileBloc = ProfileBloc(mockProfileRepository);
    });

    tearDown(() {
      profileBloc.close();
    });

    const tUserId = 1;
    const tUser = UserEntity(
      id: 1,
      firstName: 'John',
      lastName: 'Doe',
      avatarUrl: 'https://example.com/avatar.jpg',
      info: 'Test Info',
    );

    test('initial state is ProfileInitial', () {
      expect(profileBloc.state, equals(ProfileInitial()));
    });

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileLoaded] when LoadProfile is added and repository returns success',
      build: () {
        when(() => mockProfileRepository.getUserProfile(tUserId))
            .thenAnswer((_) async => const Right(tUser));
        return profileBloc;
      },
      act: (bloc) => bloc.add(const LoadProfile(tUserId)),
      expect: () => [
        ProfileLoading(),
        const ProfileLoaded(tUser),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileError] when LoadProfile is added and repository returns failure',
      build: () {
        when(() => mockProfileRepository.getUserProfile(tUserId))
            .thenAnswer((_) async => Left(Exception('Server Failure')));
        return profileBloc;
      },
      act: (bloc) => bloc.add(const LoadProfile(tUserId)),
      expect: () => [
        ProfileLoading(),
        const ProfileError('Exception: Server Failure'),
      ],
    );
  });
}
