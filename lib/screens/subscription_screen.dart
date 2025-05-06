import 'package:ai_chat/providers/auth_provider.dart';
import 'package:ai_chat/providers/subscription_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/app_sidebar.dart';
import '../widgets/subscription/account_section.dart';
import '../widgets/subscription/plan_section.dart';
import '../widgets/subscription/token_section.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool _isSidebarVisible = false;
  final Uri _url = Uri.parse('https://dev.jarvis.cx/pricing');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarVisible = !_isSidebarVisible;
    });
  }

  void _closeSidebar() {
    setState(() {
      _isSidebarVisible = false;
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<SubscriptionProvider>().getSubscription();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>();
    final subscriptionModel = context.watch<SubscriptionProvider>().subscription;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(5.0),
            child: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: _toggleSidebar,
              tooltip: 'Toggle sidebar',
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 56),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Subscription',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A2540),
                      ),
                    ),
                    const SizedBox(height: 16),
                    AccountSection(
                      userName: user.username ?? 'Unidentified',
                      userEmail: user.email ?? 'Unidentified',
                      onChangePassword: () {},
                    ),
                    const SizedBox(height: 16),
                    SubscriptionPlanSection(
                      currentPlan: subscriptionModel.name,
                      planLevel: subscriptionModel.name == 'Basic' ? 1 : 2,
                      endDateTime: subscriptionModel.endDateTime,
                      onUpgrade: _launchUrl,
                    ),
                    const SizedBox(height: 16),
                    TokenUsageSection(
                      currentUsage: subscriptionModel.totalTokens - subscriptionModel.availableTokens,
                      totalLimit: subscriptionModel.totalTokens,
                      onRedeemGift: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
          AppSidebar(
            isExpanded: true,
            isVisible: _isSidebarVisible,
            selectedIndex: 2,
            onItemSelected: (_) {},
            onToggleExpanded: () {},
            onClose: _closeSidebar,
          ),
        ],
      )
    );
  }
}
