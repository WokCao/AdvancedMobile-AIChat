import 'package:ai_chat/screens/auth/register_screen.dart';
import 'package:ai_chat/screens/auth/login_screen.dart';
import 'package:ai_chat/screens/bot_playground_screen.dart';
import 'package:ai_chat/screens/bots_screen.dart';
import 'package:ai_chat/screens/home_screen.dart';
import 'package:ai_chat/screens/chat_history_screen.dart';
import 'package:ai_chat/screens/knowledge/local_file.screen.dart';
import 'package:ai_chat/screens/knowledge/source_list_screen.dart';
import 'package:ai_chat/screens/knowledge/unit_screen.dart';
import 'package:ai_chat/screens/knowledge/website_screen.dart';
import 'package:ai_chat/screens/prompt_sample_screen.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatGem AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/history': (context) => const ChatHistoryScreen(),
        '/prompts': (context) => const PromptSampleScreen(),
        '/bots': (context) => const BotsScreen(initialTabIndex: 0),
        '/playground': (context) => const BotPlaygroundScreen(),
        '/knowledge': (context) => const BotsScreen(initialTabIndex: 1),
        '/units': (context) => const UnitScreen(),
        '/source': (context) => const SourceListScreen(),
        '/local': (context) => const LocalFileScreen(),
        '/website': (context) => const WebsiteScreen()
      },
    );
  }
}
