import 'package:flutter/material.dart';
import '../widgets/app_sidebar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSidebarVisible = false;
  int _selectedIndex = 0;

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

  void _selectMenuItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _getMenuItemTitle(int index) {
    switch (index) {
      case 0: return 'Chat';
      case 1: return 'Bots';
      default: return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          SafeArea(
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: IconButton(
                icon: const Icon(Icons.menu),
                iconSize: 30,
                onPressed: _toggleSidebar,
                tooltip: 'Toggle sidebar',
              ),
            ),
          ),

          // Floating Sidebar
          AppSidebar(
            isExpanded: true, // Always expanded in this modal style
            isVisible: _isSidebarVisible,
            selectedIndex: _selectedIndex,
            onItemSelected: _selectMenuItem,
            onToggleExpanded: () {}, // Not used in this implementation
            onClose: _closeSidebar,
          ),
        ],
      ),
    );
  }
}