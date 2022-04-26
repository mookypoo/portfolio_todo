import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio_todo/providers/auth_provider.dart';
import 'package:portfolio_todo/providers/todo_provider.dart';
import 'package:portfolio_todo/views/main/main_page.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(const PortfolioTodo());
}

class PortfolioTodo extends StatelessWidget {
  const PortfolioTodo({Key? key}) : super(key: key);

  Widget _androidApp() => MaterialApp(
    home: MainPage(),
  );

  Widget _iosApp() => CupertinoApp(
    theme: CupertinoThemeData(
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(fontSize: 17.0, color: CupertinoColors.black),
        )
    ),
    home: MainPage(),
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<TodoProvider>(create: (_) => TodoProvider()),
      ],
      child: Platform.isAndroid ? this._androidApp() : this._iosApp(),
    );
  }
}

