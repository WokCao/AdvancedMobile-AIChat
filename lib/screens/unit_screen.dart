import 'package:flutter/material.dart';
import '../widgets/bot/create_knowledge_dialog.dart';
import '../widgets/bot/unit_table.dart';

class UnitScreen extends StatefulWidget {
  const UnitScreen({super.key});

  @override
  State<UnitScreen> createState() => _UnitScreenState();
}

class _UnitScreenState extends State<UnitScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Units"),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            children: [
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
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
                          child: Icon(Icons.data_object_outlined, color: Colors.white, size: 36,),
                        ),
                        SizedBox(width: 16,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text("Knowledge 1", style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(width: 8,),
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Tooltip(
                                    message: "Edit Knowledge",
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => CreateKnowledgeDialog(
                                            onSubmit: (name, instructions) {
                                              // Handle knowledge edit
                                            },
                                            type: "Update",
                                          ),
                                        );
                                      },
                                      child: Icon(Icons.edit_outlined, size: 16,),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 8,),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.purple.shade50,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.purple.shade200)
                                  ),
                                  child: Text("2 Units", style: TextStyle(color: Colors.purple),),
                                ),
                                SizedBox(width: 8,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                      color: Colors.pink.shade50,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: Colors.pink.shade200)
                                  ),
                                  child: Text("28382 Kb", style: TextStyle(color: Colors.pink),),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.pink.shade300, Colors.purple.shade300],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ElevatedButton(
                      onPressed: () {

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.add_circle_outline, color: Colors.white),
                          SizedBox(width: 5),
                          Text("Add unit", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                    child: PaginatedDataTable(
                      columnSpacing: 0,
                      showFirstLastButtons: true,
                      showCheckboxColumn: false,
                      columns: [
                        DataColumn(label: Text("Unit", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Source", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Size", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Create time", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Latest update", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Enable", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Action", style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      source: MyUnitDataWithActions(context),
                      rowsPerPage: 8,
                      dividerThickness: 0.2,
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
