import 'dart:math';
import 'package:ai_chat/models/base_unit_model.dart';
import 'package:ai_chat/widgets/knowledge/remove_unit.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class MyUnitDataWithActions extends DataTableSource {
  final BuildContext context;
  final List<BaseUnitModel> data;
  final int totalUnit;
  final void Function(String) _handleDeleteKnowledge;

  MyUnitDataWithActions(this.context, this.data, this.totalUnit, this._handleDeleteKnowledge);

  String _getReadableFileSize(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    final i = (bytes != 0) ? (log(bytes) / log(1024)).floor() : 0;
    return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'local_file':
        return FontAwesomeIcons.fileLines;
      case 'web':
        return FontAwesomeIcons.globe;
      case 'slack':
        return FontAwesomeIcons.slack;
      case 'confluence':
        return FontAwesomeIcons.confluence;
      default:
        return FontAwesomeIcons.googleDrive;
    }
  }

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final item = data[index];

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
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(_getIconForType(item.type), color: Colors.blue),
                ),
                SizedBox(width: 8),
                Text(item.displayName, overflow: TextOverflow.ellipsis),
                SizedBox(width: 24,)
              ],
            ),
          ),
        ),
        DataCell(SizedBox(width: 120, child: Text(item.type))),
        DataCell(SizedBox(width: 120, child: Text(_getReadableFileSize(item.size)))),
        DataCell(SizedBox(width: 240, child: Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(item.createdAt.toLocal())))),
        DataCell(SizedBox(width: 240, child: Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(item.updatedAt.toLocal())))),
        DataCell(
          SizedBox(
            width: 120,
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Switch(
                hoverColor: Colors.transparent,
                activeColor: Colors.green,
                value: item.status,
                onChanged: (bool newValue) {

                  notifyListeners();
                },
              ),
            ),
          ),
        ),
        DataCell(
          Tooltip(
            message: "Delete",
            child: IconButton(
              icon: Icon(Icons.delete_outline_outlined),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return RemoveUnit();
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
  int get rowCount => totalUnit;

  @override
  int get selectedRowCount => 0;
}
