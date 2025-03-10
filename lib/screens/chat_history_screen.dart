import 'package:ai_chat/widgets/history/chat_item.dart';
import 'package:flutter/material.dart';

class ChatHistoryScreen extends StatelessWidget {
  const ChatHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Chat History",
                    style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
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
                        child: Icon(
                          Icons.close,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Expanded(
                child: ListView(
                  children: [
                    ChatItem(content: "Xin chao tat ca cac ban", time: "3 days ago", isCurrent: true,),
                    ChatItem(content: "Xây dựng mock-ui cho toàn bộ các màn hình trong đô án cuối kì, phần mock-ui bao gồm giao diện của tất cả các màn hình trong để tài + navigation/routing. Nhóm sinh viên tạo branch mock-ui và code trên branch này.", time: "3 days ago"),
                    ChatItem(content: "Xây dựng mock-ui cho toàn bộ các màn hình trong đô án cuối kì, phần mock-ui bao gồm giao diện của tất cả các màn hình trong để tài + navigation/routing. Nhóm sinh viên tạo branch mock-ui và code trên branch này.", time: "3 days ago"),
                    ChatItem(content: "Xin chao tat ca cac ban", time: "3 days ago"),
                    ChatItem(content: "Xin chao tat ca cac ban", time: "3 days ago"),
                    ChatItem(content: "Xin chao tat ca cac ban", time: "3 days ago"),
                    ChatItem(content: "Xin chao tat ca cac ban", time: "3 days ago"),
                    ChatItem(content: "Xin chao tat ca cac ban", time: "3 days ago"),
                    ChatItem(content: "Xin chao tat ca cac ban", time: "3 days ago"),
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}