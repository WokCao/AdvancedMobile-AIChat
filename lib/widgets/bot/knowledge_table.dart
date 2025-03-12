import 'dart:math';
import 'package:flutter/material.dart';

class MyDataWithActions extends DataTableSource {
  final List<Map<String, dynamic>> _data = List.generate(
    50,
    (index) => {
      "knowledge": "Knowledge ${index + 1}",
      "units": index,
      "size": "${Random.secure().nextInt(2000)} Kb",
      "edit_time": DateTime.now().toString(),
    },
  );

  @override
  DataRow? getRow(int index) {
    if (index >= _data.length) return null;
    final item = _data[index];

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
                      colors: [Colors.yellow.shade300, Colors.orange.shade300],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                  ),
                  child: Icon(Icons.data_object_outlined, color: Colors.white),
                ),
                SizedBox(width: 8),
                Text(item["knowledge"], overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ),
        DataCell(SizedBox(width: 60, child: Text(item["units"].toString()))),
        DataCell(SizedBox(width: 120, child: Text(item["size"]))),
        DataCell(SizedBox(width: 180, child: Text(item["edit_time"]))),
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
