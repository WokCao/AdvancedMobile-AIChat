import 'package:ai_chat/widgets/bot/bot_list.dart';
import 'package:ai_chat/widgets/bot/knowledge_table.dart';
import 'package:flutter/material.dart';

class BotsScreen extends StatefulWidget {
  final int initialTabIndex;
  const BotsScreen({super.key, required this.initialTabIndex});

  @override
  State<BotsScreen> createState() => _BotsScreenState();
}

class _BotsScreenState extends State<BotsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (!_tabController.indexIsChanging) {
      String newRouteName = _tabController.index == 0 ? '/bots' : '/knowledge';

      if (ModalRoute.of(context)?.settings.name != newRouteName) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          newRouteName,
          (route) => false,
        );
      }
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.purple.shade300,
                unselectedLabelColor: Colors.black87,
                indicatorColor: Colors.purple.shade300,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.grey.shade300,
                tabs: [
                  Tab(
                    icon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.smart_toy_outlined),
                        SizedBox(width: 8),
                        Text('Bots'),
                      ],
                    ),
                  ),
                  Tab(
                    icon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.data_array_outlined),
                        SizedBox(width: 8),
                        Text('Knowledge'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [ BotList(), KnowledgeTable()]
              ),
            ),
          ],
        ),
      ),
    );
  }
}
