import 'package:ai_chat/providers/auth_provider.dart';
import 'package:ai_chat/providers/bot_provider.dart';
import 'package:ai_chat/providers/knowledge_provider.dart';
import 'package:ai_chat/providers/prompt_provider.dart';
import 'package:ai_chat/providers/subscription_provider.dart';
import 'package:ai_chat/screens/auth/route_guard.dart';
import 'package:ai_chat/services/bot_integration_service.dart';
import 'package:ai_chat/services/data_source_service.dart';
import 'package:ai_chat/services/knowledge_base_service.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'flavor_config.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await MobileAds.instance.initialize();

  const flavorString = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  FlavorConfig.appFlavor = flavorString == 'prod' ? Flavor.prod : Flavor.dev;

  // if (FlavorConfig.appFlavor == Flavor.dev) {
  //   MobileAds.instance.updateRequestConfiguration(
  //     RequestConfiguration(
  //       testDeviceIds: [],
  //     ),
  //   );
  // }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => KnowledgeProvider()),
        ChangeNotifierProvider(create: (_) => PromptProvider()),
        ChangeNotifierProvider(create:(_) => SubscriptionProvider()),
        ChangeNotifierProvider(create: (_) => BotProvider()),
        Provider<KnowledgeBaseService>(
          create: (_) => KnowledgeBaseService(),
        ),
        Provider<DataSourceService>(
          create: (_) => DataSourceService(),
        ),
        Provider<BotIntegrationService>(
          create: (_) => BotIntegrationService(),
        )
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
      navigatorObservers: [routeObserver],
    );
  }
}
