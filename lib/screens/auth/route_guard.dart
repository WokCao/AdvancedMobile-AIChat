import 'package:ai_chat/screens/knowledge/confluence_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ai_chat/screens/auth/register_screen.dart';
import 'package:ai_chat/screens/auth/login_screen.dart';
import 'package:ai_chat/screens/bot_playground_screen.dart';
import 'package:ai_chat/screens/bots_screen.dart';
import 'package:ai_chat/screens/home_screen.dart';
import 'package:ai_chat/screens/chat_history_screen.dart';
import 'package:ai_chat/screens/knowledge/local_file_screen.dart';
import 'package:ai_chat/screens/knowledge/source_list_screen.dart';
import 'package:ai_chat/screens/knowledge/unit_screen.dart';
import 'package:ai_chat/screens/knowledge/website_screen.dart';
import 'package:ai_chat/screens/prompt_sample_screen.dart';

import '../../providers/auth_provider.dart';
import 'package:ai_chat/screens/knowledge/slack_screen.dart';

class RouteGuard {
  static Future<bool> isLoggedIn(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    if (accessToken == null) return false;

    final refreshToken = prefs.getString('refreshToken');
    if (refreshToken == null) return false;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final result = await authProvider.isLoggedIn(accessToken, refreshToken);

    return result;
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final path = settings.name == '/' ? Uri.base.path : settings.name;

    // Always allow these
    final publicRoutes = ['/login', '/register'];

    return MaterialPageRoute(
      builder: (context) {
        return FutureBuilder<bool>(
          future: isLoggedIn(context),
          builder: (context, snapshot) {
            final isAuth = snapshot.data ?? false;

            // Show loading while checking
            if (!snapshot.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            // If not logged in and trying to access private route
            if (!isAuth && !publicRoutes.contains(path)) {
              return const LoginScreen();
            }

            // Now route as normal
            switch (path) {
              case '/login':
                return const LoginScreen();
              case '/register':
                return const RegisterScreen();
              case '/':
              case '/home':
                return const HomeScreen();
              case '/history':
                final args = settings.arguments as Map<String, dynamic>?;
                final lastConversationId = args?['lastConversationId'] as String?;
                return ChatHistoryScreen(lastConversationId: lastConversationId);
              case '/prompts':
                return const PromptSampleScreen();
              case '/bots':
                return const BotsScreen(initialTabIndex: 0);
              case '/playground':
                return const BotPlaygroundScreen();
              case '/knowledge':
                return const BotsScreen(initialTabIndex: 1);
              case '/units':
                return const UnitScreen();
              case '/source':
                return const SourceListScreen();
              case '/local':
                return const LocalFileScreen();
              case '/website':
                return const WebsiteScreen();
              case '/google-drive':
                return const WebsiteScreen();
              case '/slack':
                return const SlackScreen();
              case '/confluence':
                return const ConfluenceScreen();
              default:
                return const LoginScreen();
            }
          },
        );
      },
    );
  }
}
