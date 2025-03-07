import 'package:ai_chat/screens//chat_history_screen.dart';
import 'package:ai_chat/screens/login_screen.dart';
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
      title: 'Your AI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const PromptSamplePage(),
    );
  }
}

