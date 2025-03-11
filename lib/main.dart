import 'package:ai_chat/screens/auth/register_screen.dart';
import 'package:ai_chat/screens/auth/login_screen.dart';
import 'package:ai_chat/screens/bots_screen.dart';
import 'package:ai_chat/screens/home_screen.dart';
import 'package:ai_chat/screens/chat_history_screen.dart';
import 'package:ai_chat/screens/prompt_sample_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatGem AI',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: true,
      ),
      initialRoute: '/home',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/history': (context) => const ChatHistoryScreen(),
        '/prompts': (context) => const PromptSampleScreen(),
        '/bots': (context) => const BotsScreen(initialTabIndex: 0),
        '/knowledge': (context) => const BotsScreen(initialTabIndex: 1),
      },
    );
  }
}
