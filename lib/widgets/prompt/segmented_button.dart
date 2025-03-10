import 'package:flutter/material.dart';

enum Prompt { public, personal }

class SegmentedButtonWidget extends StatefulWidget {
  const SegmentedButtonWidget({super.key});

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
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)){
              return Colors.purple.shade200;
            }
            return null;
          },
        ),
        foregroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            return Colors.black;
          },
        ),
      ),
      segments: const <ButtonSegment<Prompt>>[
        ButtonSegment<Prompt>(
          value: Prompt.public,
          label: Text('Public Prompt'),
          icon: Icon(Icons.public),
        ),
        ButtonSegment<Prompt>(
          value: Prompt.personal,
          label: Text('Personal Prompt'),
          icon: Icon(Icons.person),
        ),
      ],
      selected: <Prompt>{prompt},
      onSelectionChanged: (Set<Prompt> newSelection) {
        setState(() {
          prompt = newSelection.first;
        });
      },
    );
  }
}
