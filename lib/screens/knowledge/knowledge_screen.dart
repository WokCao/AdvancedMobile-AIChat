import 'dart:async';

import 'package:ai_chat/models/knowledge_meta_model.dart';
import 'package:ai_chat/models/knowledge_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../services/knowledge_base_service.dart';
import '../../widgets/knowledge/create_knowledge_dialog.dart';
import '../../widgets/knowledge/knowledge_table.dart';

class KnowledgeScreen extends StatefulWidget {
  const KnowledgeScreen({super.key});

  @override
  State<KnowledgeScreen> createState() => _KnowledgeScreenState();
}

class _KnowledgeScreenState extends State<KnowledgeScreen> {
  late Future<List<KnowledgeModel>> _dataFuture;
  final List<KnowledgeModel> _data = [];
  late TextEditingController _textEditingController;
  Timer? _debounce;
  String _lastQuery = '';
  int offset = 0;
  static const limit = 7;
  bool hasNext = true;
  int total = 0;

  Future<List<KnowledgeModel>> _loadData() async {
    final kbService = Provider.of<KnowledgeBaseService>(context, listen: false);
    final result = await kbService.getKnowledge(
      query: _textEditingController.text,
      offset: offset,
      limit: limit,
    );
    final metaData =
        result["success"]
            ? KnowledgeMetaModel.fromJson(result["data"]["meta"])
            : KnowledgeMetaModel(
              limit: limit,
              offset: offset,
              total: total,
              hasNext: hasNext,
            );

    if (result["success"]) {
      final newItems = List<KnowledgeModel>.from(
        result["data"]["data"].map((e) => KnowledgeModel.fromJson(e)),
      );
      setState(() {
        _data.addAll(newItems);
        total = metaData.total;
        hasNext = metaData.hasNext;
        offset += newItems.length;
      });
    }

    return _data;
  }

  void _fetchMoreData(int firstIndexOfPage) async {
    if (firstIndexOfPage < _data.length) return;

    final kbService = Provider.of<KnowledgeBaseService>(context, listen: false);
    final result = await kbService.getKnowledge(
      query: _textEditingController.text,
      offset: offset,
      limit: limit,
    );
    if (result["success"]) {
      final newItems = List<KnowledgeModel>.from(
        result["data"]["data"].map((e) => KnowledgeModel.fromJson(e)),
      );

      setState(() {
        _data.addAll(newItems);
        offset += newItems.length;
      });
    }
  }

  void _onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      final newQuery = _textEditingController.text.trim();
      if (newQuery != _lastQuery) {
        _lastQuery = newQuery;

        setState(() {
          _data.clear();
          offset = 0;
          _dataFuture = _loadData();
        });
      }
    });
  }

  void _handleDeleteKnowledge(String id) async {
    final kbService = Provider.of<KnowledgeBaseService>(context, listen: false);
    bool result = await kbService.deleteKnowledge(id: id);
    if (result) {
      setState(() {
        // _data.removeWhere((item) => item.id == id);
        // total--;
        // offset--;
        _data.clear();
        offset = 0;
        _dataFuture = _loadData();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: '');
    _textEditingController.addListener(_onTextChanged);
    _dataFuture = _loadData();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _textEditingController.dispose();
    super.dispose();
  }

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
                        controller: _textEditingController,
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search_sharp, size: 24),
                          suffixIcon:
                              _textEditingController.text.isNotEmpty
                                  ? IconButton(
                                    icon: const FaIcon(
                                      FontAwesomeIcons.x,
                                      size: 12,
                                    ),
                                    hoverColor: Colors.transparent,
                                    onPressed: () {
                                      _textEditingController.clear();
                                      setState(() {
                                        _data.clear();
                                        offset = 0;
                                        _dataFuture = _loadData();
                                      });
                                    },
                                  )
                                  : null,
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
                      builder:
                          (context) => CreateKnowledgeDialog(
                            onSubmit: (name, instructions) async {
                              final kbService =
                                  Provider.of<KnowledgeBaseService>(
                                    context,
                                    listen: false,
                                  );
                              await kbService.createKnowledge(
                                name,
                                instructions,
                              );

                              setState(() {
                                _data.clear();
                                offset = 0;
                                _dataFuture = _loadData();
                              });
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
                      Text(
                        "Create Knowledge",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<KnowledgeModel>>(
              future: _dataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'binoculars.png',
                          width: 128,
                          height: 128,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No knowledge found",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                  ),
                  child: PaginatedDataTable(
                    onPageChanged: (int rowIndex) {
                      _fetchMoreData(rowIndex);
                    },
                    columnSpacing: 0,
                    showFirstLastButtons: true,
                    showCheckboxColumn: false,
                    columns: [
                      DataColumn(
                        label: Text(
                          "Knowledge",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Units",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Size",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Edit time",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Action",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    source: MyDataWithActions(context, _data, total, _handleDeleteKnowledge),
                    rowsPerPage: 7,
                    dividerThickness: 0.2,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
