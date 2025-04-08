import 'package:flutter/material.dart';

enum Prompt { public, personal }

class SegmentedButtonWidget extends StatefulWidget {
  final Function(Prompt) promptCallback ;
  const SegmentedButtonWidget({super.key, required this.promptCallback});

  @override
  State<SegmentedButtonWidget> createState() => _SegmentedButtonWidget();
}

class _SegmentedButtonWidget extends State<SegmentedButtonWidget> {
  Prompt prompt = Prompt.public;

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
      selected: <Prompt>{prompt},
      onSelectionChanged: (Set<Prompt> newSelection) {
        setState(() {
          prompt = newSelection.first;
          widget.promptCallback(prompt);
        });
      },
    );
  }
}
