import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile6_examples/week18/ui/home_page.dart';
import 'package:mobile6_examples/week18/ui/login_page.dart';
import 'package:mobile6_examples/week9/sign_up_page.dart';

part 'router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: LoginPage, initial: true),
    AutoRoute(page: SignUpPage),
    AutoRoute(page: ProfilePage),
  ],
)
// extend the generated private router
class AppRouter extends _$AppRouter{}