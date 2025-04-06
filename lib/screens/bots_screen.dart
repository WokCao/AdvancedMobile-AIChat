import 'package:ai_chat/screens/knowledge/knowledge_screen.dart';
import 'package:ai_chat/widgets/bot/bot_list.dart';
import 'package:ai_chat/widgets/knowledge/knowledge_table.dart';
import 'package:flutter/material.dart';

import '../widgets/app_sidebar.dart';

class BotsScreen extends StatefulWidget {
  final int initialTabIndex;
  const BotsScreen({super.key, required this.initialTabIndex});

  @override
  State<BotsScreen> createState() => _BotsScreenState();
}

class _BotsScreenState extends State<BotsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isSidebarVisible = false;

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
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TabBar(
                    tabAlignment: TabAlignment.start,
                    controller: _tabController,
                    isScrollable: true,
                    labelColor: Colors.purple.shade300,
                    unselectedLabelColor: Colors.black87,
                    indicatorColor: Colors.purple.shade300,
                    indicatorSize: TabBarIndicatorSize.label,
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
                            Icon(Icons.data_object_outlined),
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
                    children: [BotList(), KnowledgeScreen()],
                  ),
                ),
              ],
            ),
          ),
        ),
        AppSidebar(
          isExpanded: true,
          isVisible: _isSidebarVisible,
          selectedIndex: 1,
          onItemSelected: (_) {},
          onToggleExpanded: () {},
          onClose: _closeSidebar,
        ),
      ],
    );
  }
}
