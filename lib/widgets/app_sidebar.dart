import 'package:ai_chat/utils/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class AppSidebar extends StatelessWidget {
  final bool isExpanded;
  final bool isVisible;
  final int selectedIndex;
  final Function(int) onItemSelected;
  final VoidCallback onToggleExpanded;
  final VoidCallback onClose;

  const AppSidebar({
    super.key,
    required this.isExpanded,
    required this.isVisible,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onToggleExpanded,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    // If sidebar is not visible, return an empty container
    if (!isVisible) {
      return const SizedBox.shrink();
    }

    final menuItems = [
      {'icon': Icons.message, 'title': 'Chat'},
      {'icon': Icons.smart_toy_outlined, 'title': 'BOT'},
    ];

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Dark overlay that covers the entire screen
          Positioned.fill(
            child: GestureDetector(
              onTap: onClose, // Close sidebar when tapping outside
              child: AnimatedOpacity(
                opacity: isVisible ? 0.5 : 0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  color: Colors.black,
                ),
              ),
            ),
          ),

          // Sidebar
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: isVisible ? 0 : -280, // Slide in/out
            top: 0,
            bottom: 0,
            width: 280,
            child: Material(
              elevation: 16,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Name Section
                  Container(
                    padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 10.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.diamond,
                          size: 28,
                          color: Colors.purple,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'ChatGEM',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        const Spacer(),
                        // Close button
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: onClose,
                          tooltip: 'Close sidebar',
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),

                  // Items Section
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      itemCount: menuItems.length,
                      itemBuilder: (context, index) {
                        final item = menuItems[index];
                        final isSelected = selectedIndex == index;

                        return ListTile(
                          leading: Icon(
                            item['icon'] as IconData,
                            color: isSelected ? Colors.purple[700] : Colors.grey[700],
                          ),
                          title: Text(
                            item['title'] as String,
                            style: TextStyle(
                              color: isSelected ? Colors.purple[700] : Colors.grey[800],
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          selected: isSelected,
                          selectedTileColor: Colors.purple.withValues(alpha: 0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          onTap: () {
                            onItemSelected(index);
                            if (index == 1) {
                              Navigator.pushReplacementNamed(context, "/bots");
                            } else {
                              Navigator.pushReplacementNamed(context, "/home");
                            }
                            // Close sidebar after selection on mobile
                            if (MediaQuery.of(context).size.width < 600) {
                              onClose();
                            }
                          },
                        );
                      },
                    ),
                  ),

                  // Footer
                  Container(
                    padding: const EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border(
                        top: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.purple,
                          child: Text(
                            'U',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'User Name',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'user@example.com',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.logout),
                          onPressed: () async {
                            final authProvider = Provider.of<AuthProvider>(context, listen: false);
                            final user = authProvider.user;

                            if (user == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('No user found')),
                              );
                              Navigator.pushReplacementNamed(context, '/login');
                              return;
                            }

                            final success = await authProvider.logout(
                              user.refreshToken
                            );

                            await clearTokens();

                            if (success) {
                              Navigator.pushReplacementNamed(context, '/login');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(authProvider.error ?? 'Logout failed. Please try again')),
                              );
                            }
                          },
                          tooltip: 'Logout',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}