import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SourceListScreen extends StatefulWidget {
  const SourceListScreen({super.key});

  @override
  State<SourceListScreen> createState() => _SourceListScreenState();
}

class _SourceListScreenState extends State<SourceListScreen> {
  int _selectedIndex = -1;

  final List<DataSourceOption> _options = [
    DataSourceOption(
      icon: FontAwesomeIcons.fileLines,
      title: 'Local files',
      description: 'Upload pdf, docx, ...',
      iconColor: Colors.black,
    ),
    DataSourceOption(
      icon: FontAwesomeIcons.slack,
      title: 'Slack',
      description: 'Connect Slack to get data',
      iconColor: Colors.purple,
    ),
    DataSourceOption(
      icon: FontAwesomeIcons.confluence,
      title: 'Confluence',
      description: 'Connect Confluence to get data',
      iconColor: Colors.purple,
    ),
    DataSourceOption(
      icon: FontAwesomeIcons.globe,
      title: 'Website',
      description: 'Connect Website to get data',
      iconColor: Colors.blue,
      disabled: true,
    ),
    DataSourceOption(
      icon: FontAwesomeIcons.googleDrive,
      title: 'Google drive',
      description: 'Connect Google drive to get data',
      iconColor: Colors.blue,
      disabled: true,
    ),
    DataSourceOption(
      icon: FontAwesomeIcons.jira,
      title: 'Jira',
      description: 'Connect Jira to get data',
      iconColor: Colors.blue,
      disabled: true,
    ),
    DataSourceOption(
      icon: FontAwesomeIcons.hubspot,
      title: 'Hubspot',
      description: 'Connect Hubspot to get data',
      iconColor: Colors.orange,
      disabled: true,
    ),
    DataSourceOption(
      icon: FontAwesomeIcons.noteSticky,
      title: 'Notion',
      description: 'Connect Notion to get data',
      iconColor: Colors.black,
      disabled: true,
    ),
    DataSourceOption(
      icon: FontAwesomeIcons.github,
      title: 'Github repositories',
      description: 'Connect Github repositories to get data',
      iconColor: Colors.black,
      disabled: true,
    ),
    DataSourceOption(
      icon: FontAwesomeIcons.gitlab,
      title: 'Gitlab repositories',
      description: 'Connect Gitlab repositories to get data',
      iconColor: Colors.orange,
      disabled: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Source'),
        elevation: 0,
        backgroundColor: Colors.purple.shade200,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Choose source to import data', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),),
            SizedBox(height: 16,),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 550,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _options.length,
                itemBuilder: (context, index) {
                  return DataSourceCard(
                    option: _options[index],
                    isSelected: _selectedIndex == index && !_options[index].disabled,
                    onTap: () {
                      if (!_options[index].disabled) {
                        setState(() {
                          _selectedIndex = index;
                        });
                        if (index == 0) {
                          Navigator.pushNamed(context, '/local');
                        } else if (index == 1) {
                          Navigator.pushNamed(context, '/website');
                        } else if (index == 2) {
                          Navigator.pushNamed(context, '/google-drive');
                        } else if (index == 3) {
                          Navigator.pushNamed(context, '/slack');
                        } else if (index == 4) {
                          Navigator.pushNamed(context, '/confluence');
                        }
                      }
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DataSourceOption {
  final IconData icon;
  final String title;
  final String description;
  final Color iconColor;
  final bool disabled;

  DataSourceOption({
    required this.icon,
    required this.title,
    required this.description,
    required this.iconColor,
    this.disabled = false,
  });
}

class DataSourceCard extends StatelessWidget {
  final DataSourceOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const DataSourceCard({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final opacity = option.disabled ? 0.5 : 1.0;

    return MouseRegion(
      cursor: option.disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Opacity(
          opacity: opacity,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Colors.blue.shade300 : Colors.grey.shade200,
                width: 1.5,
              ),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: isSelected,
                      activeColor: Colors.blue,
                      onChanged: option.disabled ? null : (_) => onTap(),
                    ),
                    SizedBox(width: 8),
                    FaIcon(option.icon, color: option.iconColor, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        option.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: Text(
                    option.description,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ),
                if (option.disabled)
                  Padding(
                    padding: EdgeInsets.only(left: 40, top: 8),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Coming Soon',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}