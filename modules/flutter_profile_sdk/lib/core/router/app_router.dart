import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../features/profile/presentation/pages/user_profile_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: UserProfileRoute.page, initial: true),
      ];
}
