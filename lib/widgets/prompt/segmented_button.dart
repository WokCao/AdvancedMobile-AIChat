import 'package:flutter/material.dart';

enum Prompt { public, personal }

class SegmentedButtonWidget extends StatefulWidget {
  final Function(Prompt) promptCallback ;
  final Prompt prompt;
  const SegmentedButtonWidget({super.key, required this.promptCallback, required this.prompt});

  @override
  State<SegmentedButtonWidget> createState() => _SegmentedButtonWidget();
}

class _SegmentedButtonWidget extends State<SegmentedButtonWidget> {

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<Prompt>(
      showSelectedIcon: false,
      style: ButtonStyle(
        iconColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)){
              return Colors.white;
            }
            return Colors.black;
          },
        ),
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)){
              return Colors.purple.shade200;
            }
            return null;
          },
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)){
              return Colors.white;
            }
            return Colors.black;
          },
        ),
      ),
      segments: const <ButtonSegment<Prompt>>[
        ButtonSegment<Prompt>(
          value: Prompt.public,
          label: Text('Public Prompts'),
          icon: Icon(Icons.public),
        ),
        ButtonSegment<Prompt>(
          value: Prompt.personal,
          label: Text('My Prompts'),
          icon: Icon(Icons.person),
        ),
      ],
      selected: <Prompt>{widget.prompt},
      onSelectionChanged: (Set<Prompt> newSelection) {
        setState(() {
          widget.promptCallback(newSelection.first);
        });
      },
    );
  }
}
