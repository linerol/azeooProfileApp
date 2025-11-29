import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_sdk/features/profile/domain/entities/user_entity.dart';
import 'package:flutter_profile_sdk/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:flutter_profile_sdk/features/profile/presentation/bloc/profile_event.dart';
import 'package:flutter_profile_sdk/features/profile/presentation/bloc/profile_state.dart';
import 'package:flutter_profile_sdk/features/profile/presentation/pages/user_profile_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileBloc extends MockBloc<ProfileEvent, ProfileState>
    implements ProfileBloc {}

void main() {
  late MockProfileBloc mockProfileBloc;

  setUp(() {
    mockProfileBloc = MockProfileBloc();
    // Register the mock bloc in GetIt because UserProfileScreen uses getIt<ProfileBloc>()
    if (GetIt.I.isRegistered<ProfileBloc>()) {
      GetIt.I.unregister<ProfileBloc>();
    }
    GetIt.I.registerFactory<ProfileBloc>(() => mockProfileBloc);
  });

  tearDown(() {
    GetIt.I.reset();
  });

  const tUser = UserEntity(
    id: 1,
    firstName: 'John',
    lastName: 'Doe',
    avatarUrl: 'https://example.com/avatar.jpg',
    info: 'Test Info',
  );

  Widget createWidgetUnderTest() {
    return const MaterialApp(
      home: UserProfileScreen(userId: 1),
    );
  }

  testWidgets('shows loading indicator when state is ProfileLoading',
      (tester) async {
    when(() => mockProfileBloc.state).thenReturn(ProfileLoading());

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows user info when state is ProfileLoaded', (tester) async {
    when(() => mockProfileBloc.state).thenReturn(const ProfileLoaded(tUser));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('Test Info'), findsOneWidget);
    expect(find.text('User ID: 1'), findsOneWidget);
  });

  testWidgets('shows error message when state is ProfileError', (tester) async {
    when(() => mockProfileBloc.state)
        .thenReturn(const ProfileError('Error Message'));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Oups, impossible de charger le profil.'), findsOneWidget);
    expect(find.text('Réessayer'), findsOneWidget);
  });
}
