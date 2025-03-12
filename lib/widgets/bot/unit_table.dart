import 'dart:math';
import 'package:flutter/material.dart';

class MyUnitDataWithActions extends DataTableSource {
  final BuildContext context;
  final List<Map<String, dynamic>> _data;
  final List<bool> _switchValues;

  MyUnitDataWithActions(this.context)
    : _data = List.generate(
        50,
        (index) => {
          "unit": "Unit ${index + 1}",
          "source": "Local file",
          "size": "${Random.secure().nextInt(2000)} Kb",
          "create_time": DateTime.now().toString(),
          "latest_update": DateTime.now().toString(),
        },
      ),
      _switchValues = List.generate(50, (_) => false);

  @override
  DataRow? getRow(int index) {
    if (index >= _data.length) return null;
    final item = _data[index];
    bool value = false;

    return DataRow.byIndex(
      onSelectChanged: (selected) {},
      index: index,
      color: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.pressed)) {
          return Colors.purple.shade100;
        }
        if (states.contains(WidgetState.hovered)) {
          return Colors.purple.shade50;
        }
        return Colors.transparent;
      }),
      cells: [
        DataCell(
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: 300),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: LinearGradient(
                      colors: [Colors.cyan.shade300, Colors.blue.shade300],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                  ),
                  child: Icon(Icons.file_open, color: Colors.white),
                ),
                SizedBox(width: 8),
                Text(item["unit"], overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ),
        DataCell(SizedBox(width: 120, child: Text(item["source"].toString()))),
        DataCell(SizedBox(width: 120, child: Text(item["size"]))),
        DataCell(SizedBox(width: 240, child: Text(item["create_time"]))),
        DataCell(SizedBox(width: 240, child: Text(item["latest_update"]))),
        DataCell(
          SizedBox(
            width: 120,
            child: Switch(
              hoverColor: Colors.transparent,
              activeColor: Colors.green,
              value: _switchValues[index],
              onChanged: (bool newValue) {
                _switchValues[index] = newValue;
                notifyListeners();
              },
            ),
          ),
        ),
        DataCell(
          Tooltip(
            message: "Delete",
            child: IconButton(
              icon: Icon(Icons.delete_outline_outlined),
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;
}
