import 'package:flutter/material.dart';

import 'features/client_access/client_access_flow.dart';
import 'features/client_shell/client_shell.dart';
import 'theme/app_theme.dart';

class ServiProntoApp extends StatefulWidget {
  const ServiProntoApp({super.key});

  @override
  State<ServiProntoApp> createState() => _ServiProntoAppState();
}

class _ServiProntoAppState extends State<ServiProntoApp> {
  var _hasConfirmedAccess = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ServiPronto',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: _hasConfirmedAccess
          ? const ClientShell()
          : ClientAccessFlow(
              onAccessConfirmed: () => setState(() => _hasConfirmedAccess = true),
            ),
    );
  }
}
