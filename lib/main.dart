import 'package:ai_chat/providers/auth_provider.dart';
import 'package:ai_chat/providers/knowledge_provider.dart';
import 'package:ai_chat/screens/auth/route_guard.dart';
import 'package:ai_chat/services/data_source_service.dart';
import 'package:ai_chat/services/knowledge_base_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => KnowledgeProvider()),
        Provider<KnowledgeBaseService>(
          create: (_) => KnowledgeBaseService(),
        ),
        Provider<DataSourceService>(
          create: (_) => DataSourceService(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatGem AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.purple, useMaterial3: true),
      navigatorKey: navigatorKey,
      onGenerateRoute: (settings) => RouteGuard.generateRoute(settings),
    );
  }
}
