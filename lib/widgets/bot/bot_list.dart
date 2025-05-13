import 'dart:async';

import 'package:ai_chat/models/bot_model.dart';
import 'package:ai_chat/widgets/ads/banner_ad_widget.dart';
import 'package:ai_chat/widgets/bot/single_bot.dart';
import 'package:ai_chat/widgets/bot/type_drop_down.dart';
import 'package:flutter/material.dart';

import '../../utils/get_api_utils.dart';
import 'create_bot_dialog.dart';

class BotList extends StatefulWidget {
  const BotList({super.key});

  @override
  State<BotList> createState() => _BotListState();
}

class _BotListState extends State<BotList> {
  List<BotModel> _bots = [];
  bool _loading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _fetchBots();
  }

  Future<void> _fetchBots() async {
    setState(() => _loading = true);

    final api = getKBApiService(context);
    final bots = await api.getBots(search: _searchQuery);

    setState(() {
      _bots = bots;
      _loading = false;
    });
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
              TypeDropdown(),
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
                  onPressed: () async {
                    final result = await showDialog<bool>(
                      context: context,
                      builder: (context) => CreateBotDialog(),
                    );
                    if (result == true) {
                      _fetchBots();
                    }
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
                      Text("Create Bot", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          TextField(
            controller: _searchController,
            onChanged: (value) {
              if (_debounce?.isActive ?? false) _debounce!.cancel();
              _debounce = Timer(const Duration(milliseconds: 400), () {
                setState(() => _searchQuery = value.trim());
                _fetchBots();
              });
            },
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
          SizedBox(height: 16),
          Expanded(
            child: _loading
                ? Center(child: CircularProgressIndicator(color: Colors.purple.shade200))
                : _bots.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/binoculars.png',
                              width: 128,
                              height: 128,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No bots found",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 800,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 4,
                        ),
                        itemCount: _bots.length,
                        itemBuilder: (context, index) {
                          final bot = _bots[index];
                          return SingleBot(
                            botModel: bot,
                            onBotUpdated: _fetchBots,
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
