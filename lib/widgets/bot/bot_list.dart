import 'package:ai_chat/widgets/bot/single_bot.dart';
import 'package:ai_chat/widgets/bot/type_drop_down.dart';
import 'package:flutter/material.dart';

class BotList extends StatefulWidget {
  const BotList({super.key});

  @override
  State<BotList> createState() => _BotListState();
}

class _BotListState extends State<BotList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        children: [
          SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    TypeDropdown(),
                    SizedBox(width: 8),
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
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    Colors.purple.shade300,
                  ),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  padding: WidgetStatePropertyAll(EdgeInsets.all(8)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.add_circle_outline, color: Colors.white),
                    SizedBox(width: 5),
                    Text("Create Bot", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 600,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3,
              ),
              itemCount: 10,
              itemBuilder: (context, index) {
                return SingleBot(
                  name: "Bot $index",
                  description:
                      "his example shows a custom implementation of selection in list and grid views. Use the button in the top right (possibly hidden under the DEBUG banner) to toggle between ListView and GridView. Long press any ListTile or GridTile to enable selection mode.",
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
