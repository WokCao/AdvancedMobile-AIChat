import 'package:flutter/material.dart';

import '../../widgets/knowledge/create_knowledge_dialog.dart';
import '../../widgets/knowledge/knowledge_table.dart';

class KnowledgeScreen extends StatefulWidget {
  const KnowledgeScreen({super.key});

  @override
  State<KnowledgeScreen> createState() => _KnowledgeScreenState();
}

class _KnowledgeScreenState extends State<KnowledgeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        children: [
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.3,
                      ),
                      child: TextField(
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search_sharp, size: 24),
                          hintText: "Search...",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.purpleAccent,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ),
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
                    showDialog(
                      context: context,
                      builder: (context) => CreateKnowledgeDialog(
                        onSubmit: (name, instructions) {
                          // Handle knowledge creation
                        },
                        type: "Create",
                      ),
                    );
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
                      Text("Create Knowledge", style: TextStyle(color: Colors.white)),
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
                  DataColumn(label: Text("Knowledge", style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text("Units", style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text("Size", style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text("Edit time", style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text("Action", style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                source: MyDataWithActions(context),
                rowsPerPage: 7,
                dividerThickness: 0.2,
              ),
            )
          ),
        ],
      ),
    );
  }
}
