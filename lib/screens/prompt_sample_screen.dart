import 'package:ai_chat/widgets/prompt/add_prompt.dart';
import 'package:ai_chat/widgets/prompt/prompt_item.dart';
import 'package:ai_chat/widgets/prompt/segmented_button.dart';
import 'package:flutter/material.dart';

class PromptSampleScreen extends StatelessWidget {
  const PromptSampleScreen({super.key});

  void _showAddPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddPrompt();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Prompt Library",
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Tooltip(
                        message: "Add Prompt",
                        child: GestureDetector(
                          onTap: () { _showAddPrompt(context); },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            // onEnter & onExit to change color
                            child: Container(
                              padding: EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.pink.shade300,
                                    Colors.purple.shade300,
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Icon(
                                Icons.add,
                                color: Colors.white70,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 6),
                      Tooltip(
                        message: "Close",
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 30,
                            height: 30,
                            alignment: Alignment.center,
                            child: Icon(Icons.close, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              SegmentedButtonWidget(),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search_sharp),
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
                  SizedBox(width: 10),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.star_border,
                        color: Colors.grey.shade500,
                        size: 25,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: [
                    PromptItem(
                      title: "Testing",
                      description:
                          "Xây dựng mock-ui cho toàn bộ các màn hình trong đô án cuối kì, phần mock-ui bao gồm giao diện của tất cả các màn hình trong để tài + navigation/routing. Nhóm sinh viên tạo branch mock-ui và code trên branch này.",
                    ),
                    PromptItem(
                      title: "Testing",
                      description:
                          "Xây dựng mock-ui cho toàn bộ các màn hình trong đô án cuối kì, phần mock-ui bao gồm giao diện",
                    ),
                    PromptItem(
                      title: "Testing",
                      description: "doing something",
                    ),
                    PromptItem(
                      title: "Testing",
                      description:
                          "Xây dựng mock-ui cho toàn bộ các màn hình trong đô án cuối kì, phần mock-ui bao gồm giao diện",
                    ),
                    PromptItem(
                      title: "Testing",
                      description: "doing something",
                    ),
                    PromptItem(
                      title: "Testing",
                      description:
                          "Xây dựng mock-ui cho toàn bộ các màn hình trong đô án cuối kì, phần mock-ui bao gồm giao diện",
                    ),
                    PromptItem(
                      title: "Testing",
                      description: "doing something",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
