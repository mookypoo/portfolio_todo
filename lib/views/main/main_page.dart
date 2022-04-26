import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/todo_provider.dart';
import '../auth/auth_page.dart';
import '../loading/loading_page.dart';
import 'android_main.dart';
import 'ios_main.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);
  static const String routeName = "/";

  @override
  Widget build(BuildContext context) {
    AuthProvider _authProvider = Provider.of<AuthProvider>(context);
    TodoProvider _todoProvider = Provider.of<TodoProvider>(context);

    if (_authProvider.authState == AuthState.loggedOut) return AuthPage();
    if (_authProvider.authState == AuthState.await) return LoadingPage();
    if (_authProvider.user != null && _todoProvider.state == ProviderState.open) {
      print("user is not null anymre!!");
      /* 요럴때...null error 처리 어떻게 해야되나욥..null이 아닐때 라고 했으니 괜츈? */
      _todoProvider.getTodos(user: _authProvider.user!);
    }
    if (_todoProvider.state != ProviderState.complete) return LoadingPage();

    return Platform.isAndroid
        ? AndroidMain()
        : IosMain(authProvider: _authProvider, todoProvider: _todoProvider,);
  }
}
