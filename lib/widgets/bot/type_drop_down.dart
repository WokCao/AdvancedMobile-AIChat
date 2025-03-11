import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TypeDropdown extends StatefulWidget {
  const TypeDropdown({super.key});

  @override
  State<TypeDropdown> createState() => _TypeDropdownState();
}

class _TypeDropdownState extends State<TypeDropdown> {
  String selectedValue = 'All';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Type:',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
          const SizedBox(width: 8),
          DropdownMenu<String>(
            textAlign: TextAlign.center,
            enableFilter: false,
            requestFocusOnTap: false,
            inputDecorationTheme: InputDecorationTheme(
              outlineBorder: BorderSide.none,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            menuStyle: MenuStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            alignmentOffset: Offset(0, 5),
            initialSelection: selectedValue,
            textStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            onSelected: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedValue = newValue;
                });
              }
            },
            dropdownMenuEntries:
                <String>[
                  'All',
                  'Published',
                  'Favorite',
                ].map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(
                    value: value,
                    label: value,
                    style: ButtonStyle(
                      alignment: Alignment.center,
                      backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                        (states) =>
                            value == selectedValue
                                ? Colors.purple.shade100
                                : Colors.white,
                      ),
                      overlayColor: WidgetStateProperty.resolveWith<Color?>(
                        (states) =>
                            states.contains(WidgetState.focused)
                                ? Colors.purple.shade100
                                : Colors.grey.shade100,
                      ),
                      padding: WidgetStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 8),
                      ),
                      textStyle: WidgetStateProperty.all(
                        TextStyle(
                          fontSize: 14,
                          fontWeight:
                              value == selectedValue
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
