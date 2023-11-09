import 'package:devapp/config/router/app_router.dart';
import 'package:devapp/config/theme/app_theme.dart';
import 'package:devapp/proferences/content_provider.dart';
import 'package:devapp/provider/licence_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesContentProvider.init(
    providerAuthority: "com.ksaucedo.devapp",
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ListItemValuesProvider(),
      child: MaterialApp.router(
        title: 'Licence Manager',
        theme: AppTheme().getTheme(),
        routerConfig: appRouter,
      ),
    );
  }
}
