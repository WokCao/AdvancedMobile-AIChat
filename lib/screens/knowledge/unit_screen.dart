import 'dart:async';
import 'dart:math';

import 'package:ai_chat/models/base_unit_model.dart';
import 'package:ai_chat/models/knowledge_model.dart';
import 'package:ai_chat/models/file_unit_model.dart';
import 'package:ai_chat/providers/knowledge_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../models/confluence_unit_model.dart';
import '../../models/meta_model.dart';
import '../../models/slack_unit_model.dart';
import '../../services/knowledge_base_service.dart';
import '../../widgets/knowledge/create_knowledge_dialog.dart';
import '../../widgets/knowledge/unit_table.dart';

class UnitScreen extends StatefulWidget {
  const UnitScreen({super.key});

  @override
  State<UnitScreen> createState() => _UnitScreenState();
}

class _UnitScreenState extends State<UnitScreen> {
  late Future<List<BaseUnitModel>> _dataFuture;
  final List<BaseUnitModel> _data = [];
  late TextEditingController _textEditingController;
  Timer? _debounce;
  String _lastQuery = '';
  int offset = 0;
  static const limit = 7;
  bool hasNext = true;
  int total = 0;
  late KnowledgeModel selectedKnowledgeModel;

  Future<List<BaseUnitModel>> _loadData() async {
    final kbService = Provider.of<KnowledgeBaseService>(context, listen: false);
    final result = await kbService.getUnitsOfKnowledge(
      query: _textEditingController.text,
      offset: offset,
      id: selectedKnowledgeModel.id,
    );

    final metaData =
        result["success"]
            ? MetaModel.fromJson(result["data"]["meta"])
            : MetaModel(
              limit: limit,
              offset: offset,
              total: total,
              hasNext: hasNext,
            );

    if (result["success"]) {
      final newItems = List<BaseUnitModel>.from(
        result["data"]["data"].map<BaseUnitModel>((e) {
          return e['metadata']['slack_bot_token'] != null
              ? SlackUnitModel.fromJson(e)
              : e['metadata']['wiki_page_url'] != null
              ? ConfluenceUnitModel.fromJson(e)
              : FileUnitModel.fromJson(e);
        }),
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
    final result = await kbService.getUnitsOfKnowledge(
      query: _textEditingController.text,
      offset: offset,
      id: selectedKnowledgeModel.id,
    );
    if (result["success"]) {
      final newItems = List<BaseUnitModel>.from(
        result["data"]["data"].map<BaseUnitModel>((e) {
          return e['metadata']['slack_bot_token'] != null
              ? SlackUnitModel.fromJson(e)
              : e['metadata']['wiki_page_url'] != null
              ? ConfluenceUnitModel.fromJson(e)
              : FileUnitModel.fromJson(e);
        }),
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

  void _handleDeleteUnit(String id) async {}

  void _handleUpdateKnowledge(String name, String instructions) async {
    final kbService = Provider.of<KnowledgeBaseService>(context, listen: false);
    final response = await kbService.updateKnowledge(
      name,
      instructions,
      selectedKnowledgeModel.id,
    );
    final updatedKnowledgeModel = KnowledgeModel(
      id: selectedKnowledgeModel.id,
      knowledgeName: response["data"]["knowledgeName"],
      description: response["data"]["description"],
      userId: selectedKnowledgeModel.userId,
      numUnits: selectedKnowledgeModel.numUnits,
      totalSize: selectedKnowledgeModel.totalSize,
      createdAt: selectedKnowledgeModel.createdAt,
      updatedAt: DateTime.parse(response["data"]["updatedAt"]),
    );
    Provider.of<KnowledgeProvider>(
      context,
      listen: false,
    ).setSelectedKnowledgeRow(updatedKnowledgeModel, updated: true);
    setState(() {
      selectedKnowledgeModel = updatedKnowledgeModel;
    });
  }

  String _getReadableFileSize(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    final i = (bytes != 0) ? (log(bytes) / log(1024)).floor() : 0;
    return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
  }

  @override
  void initState() {
    super.initState();
    selectedKnowledgeModel =
        Provider.of<KnowledgeProvider>(
          context,
          listen: false,
        ).selectedKnowledge;
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Units"),
        backgroundColor: Colors.purple.shade200,
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
                              colors: [
                                Colors.yellow.shade300,
                                Colors.orange.shade300,
                              ],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                            ),
                          ),
                          child: Icon(
                            Icons.data_object_outlined,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.3,
                                  ),
                                  child: Text(
                                    selectedKnowledgeModel.knowledgeName,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Tooltip(
                                    message: "Edit Knowledge",
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder:
                                              (context) =>
                                                  CreateKnowledgeDialog(
                                                    onSubmit:
                                                        _handleUpdateKnowledge,
                                                    type: "Update",
                                                  ),
                                        );
                                      },
                                      child: Icon(
                                        Icons.edit_outlined,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.purple.shade50,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: Colors.purple.shade200,
                                    ),
                                  ),
                                  child: Text(
                                    "${selectedKnowledgeModel.numUnits} Units",
                                    style: TextStyle(color: Colors.purple),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.pink.shade50,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: Colors.pink.shade200,
                                    ),
                                  ),
                                  child: Text(
                                    _getReadableFileSize(
                                      selectedKnowledgeModel.totalSize,
                                    ),
                                    style: TextStyle(color: Colors.pink),
                                  ),
                                ),
                              ],
                            ),
                          ],
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
                        Navigator.pushNamed(context, '/source');
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
                            "Add unit",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextField(
                controller: _textEditingController,
                enabled: false,
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search_sharp, size: 24),
                  suffixIcon:
                      _textEditingController.text.isNotEmpty
                          ? IconButton(
                            icon: const FaIcon(FontAwesomeIcons.x, size: 12),
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
              SizedBox(height: 16),
              Expanded(
                child: FutureBuilder<List<BaseUnitModel>>(
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
                              "No units found",
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
                              "Unit",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Source",
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
                              "Create time",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Latest update",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Enable",
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
                        source: MyUnitDataWithActions(
                          context,
                          _data,
                          total,
                          _handleDeleteUnit,
                        ),
                        rowsPerPage: 7,
                        dividerThickness: 0.2,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
