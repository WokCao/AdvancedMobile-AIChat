import 'dart:async';

import 'package:ai_chat/models/meta_model.dart';
import 'package:ai_chat/models/knowledge_model.dart';
import 'package:ai_chat/utils/knowledge_exception.dart';
import 'package:ai_chat/widgets/ads/banner_ad_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../main.dart';
import '../../providers/bot_provider.dart';
import '../../providers/knowledge_provider.dart';
import '../../services/knowledge_base_service.dart';
import '../../widgets/knowledge/create_knowledge_dialog.dart';
import '../../widgets/knowledge/knowledge_table.dart';

class KnowledgeScreen extends StatefulWidget  {
  const KnowledgeScreen({super.key});

  @override
  State<KnowledgeScreen> createState() => _KnowledgeScreenState();
}

class _KnowledgeScreenState extends State<KnowledgeScreen> with RouteAware {
  late Future<List<KnowledgeModel>> _dataFuture;
  final List<KnowledgeModel> _data = [];
  final TextEditingController _textEditingController = TextEditingController();
  Timer? _debounce;
  String _lastQuery = '';
  int offset = 0, total = 0;
  bool hasNext = true;

  void _resetAndReloadData() {
    setState(() {
      _data.clear();
      offset = 0;
      _dataFuture = _loadData();
    });
  }

  /* To load knowledge first time */
  Future<List<KnowledgeModel>> _loadData() async {
    final kbService = Provider.of<KnowledgeBaseService>(context, listen: false);
    try {
      final result = await kbService.getKnowledge(
        query: _textEditingController.text,
        offset: offset,
      );
      final metaData = MetaModel.fromJson(result["meta"]);
      final newItems = List<KnowledgeModel>.from(
        result["data"].map((e) => KnowledgeModel.fromJson(e)),
      );

      if (mounted) {
        setState(() {
          _data.addAll(newItems);
          total = metaData.total;
          hasNext = metaData.hasNext;
          offset += newItems.length;
        });
      }
    } on KnowledgeException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }

    return _data;
  }

  /* To load more knowledge */
  Future<void> _fetchMoreData(int firstIndexOfPage) async {
    if (firstIndexOfPage < _data.length) return;

    final kbService = Provider.of<KnowledgeBaseService>(context, listen: false);
    try {
      final result = await kbService.getKnowledge(
        query: _textEditingController.text,
        offset: offset,
      );

      final newItems = List<KnowledgeModel>.from(
        result["data"].map((e) => KnowledgeModel.fromJson(e)),
      );

      setState(() {
        _data.addAll(newItems);
        offset += newItems.length;
      });
    } on KnowledgeException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      final newQuery = _textEditingController.text.trim();
      if (newQuery != _lastQuery) {
        _lastQuery = newQuery;
        _resetAndReloadData();
      }
    });
  }

  void _handleDeleteKnowledge(String id) async {
    final kbService = Provider.of<KnowledgeBaseService>(context, listen: false);
    try {
      await kbService.deleteKnowledge(id: id);
      _resetAndReloadData();
    } on KnowledgeException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _handleDeleteQuery() {
    _textEditingController.clear();
    _resetAndReloadData();
  }

  void _handleCreateKnowledge(String knowledgeName, String description) async {
    final kbService = Provider.of<KnowledgeBaseService>(context, listen: false);
    try {
      await kbService.createKnowledge(knowledgeName: knowledgeName, description: description,);
      _resetAndReloadData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Knowledge has been created successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } on KnowledgeException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _updateKnowledgeItem(KnowledgeModel updated) {
    final index = _data.indexWhere((k) => k.id == updated.id);
    if (index != -1) {
      setState(() {
        _data[index] = updated;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(_onTextChanged);
    _dataFuture = _loadData();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _debounce?.cancel();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    final provider = Provider.of<KnowledgeProvider>(context, listen: false);

    if (provider.wasUpdated) {
      final updated = provider.selectedKnowledge;
      if (updated != null) {
        _updateKnowledgeItem(updated);
      }
      provider.clearUpdateFlag();
    }

    provider.setSelectedKnowledgeRow(null);
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
                        maxWidth: MediaQuery.of(context).size.width * 0.6,
                      ),
                      child: TextField(
                        controller: _textEditingController,
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          isDense: true,
                          prefixIcon: const Icon(Icons.search_sharp, size: 24),
                          suffixIcon:
                              _textEditingController.text.isNotEmpty
                                  ? IconButton(
                                    icon: const FaIcon(
                                      FontAwesomeIcons.x,
                                      size: 12,
                                    ),
                                    hoverColor: Colors.transparent,
                                    onPressed: _handleDeleteQuery,
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
                            onSubmit: _handleCreateKnowledge,
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
                      if(context.read<BotProvider>().botModel != null)
                        DataColumn(label: Text(
                          "Status",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
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
          BannerAdWidget()
        ],
      ),
    );
  }
}
