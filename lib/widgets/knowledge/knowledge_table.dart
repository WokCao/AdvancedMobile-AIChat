import 'dart:math';
import 'package:ai_chat/widgets/knowledge/remove_knowledge.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/knowledge_model.dart';

class MyDataWithActions extends DataTableSource {
  final BuildContext context;
  final List<KnowledgeModel> data;
  final int totalKnowledge;
  final void Function(String) _handleDeleteKnowledge;

  MyDataWithActions(this.context, this.data, this.totalKnowledge, this._handleDeleteKnowledge);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final item = data[index];

    return DataRow.byIndex(
      onSelectChanged: (selected) {
        Navigator.pushNamed(context, "/units");
      },
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
            constraints: BoxConstraints(minWidth: 300, maxWidth: 400),
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
                Expanded(
                  child: Text(
                    item.knowledgeName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                SizedBox(width: 24,)
              ],
            ),
          ),
        ),
        DataCell(SizedBox(width: 60, child: Text(item.numUnits.toString()))),
        DataCell(SizedBox(width: 120, child: Text(item.totalSize.toString()))),
        DataCell(SizedBox(width: 180, child: Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(item.updatedAt.toLocal())))),
        DataCell(
          Tooltip(
            message: "Delete",
            child: IconButton(
              icon: Icon(Icons.delete_outline_outlined),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return RemoveKnowledge(handleDeleteKnowledge: _handleDeleteKnowledge, id: item.id,);
                    }
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => totalKnowledge;

  @override
  int get selectedRowCount => 0;
}
