import 'package:flutter/material.dart';

class ChatHistoryPage extends StatelessWidget {
  const ChatHistoryPage({super.key});

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
                        onTap: () {},
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
                      _buildChatItems(content: "Xin chao tat ca cac ban", time: "3 days ago"),
                      _buildChatItems(content: "Xây dựng mock-ui cho toàn bộ các màn hình trong đô án cuối kì, phần mock-ui bao gồm giao diện của tất cả các màn hình trong để tài + navigation/routing. Nhóm sinh viên tạo branch mock-ui và code trên branch này.", time: "3 days ago"),
                      _buildChatItems(content: "Xây dựng mock-ui cho toàn bộ các màn hình trong đô án cuối kì, phần mock-ui bao gồm giao diện của tất cả các màn hình trong để tài + navigation/routing. Nhóm sinh viên tạo branch mock-ui và code trên branch này.", time: "3 days ago"),
                      _buildChatItems(content: "Xin chao tat ca cac ban", time: "3 days ago"),
                      _buildChatItems(content: "Xin chao tat ca cac ban", time: "3 days ago"),
                      _buildChatItems(content: "Xin chao tat ca cac ban", time: "3 days ago"),
                      _buildChatItems(content: "Xin chao tat ca cac ban", time: "3 days ago"),
                      _buildChatItems(content: "Xin chao tat ca cac ban", time: "3 days ago"),
                      _buildChatItems(content: "Xin chao tat ca cac ban", time: "3 days ago"),
                      _buildChatItems(content: "Xin chao tat ca cac ban", time: "3 days ago"),
                      _buildChatItems(content: "Xin chao tat ca cac ban", time: "3 days ago"),
                      _buildChatItems(content: "Xin chao tat ca cac ban", time: "3 days ago"),
                      _buildChatItems(content: "Xin chao tat ca cac ban", time: "3 days ago"),
                    ],
                  ),
                )
              ],
            ),
          )
      ),
    );
  }

  Widget _buildChatItems({
    required String content,
    required String time
  }) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(right: 150.0),
            child: Text(
              content,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17), overflow: TextOverflow.ellipsis),
          ),
          SizedBox(height: 5,),
          Row(
            children: [
              Expanded(
                child: Text(
                  time,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Tooltip(
                    message: "Edit",
                    child: Icon(
                      Icons.edit,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 2),
                  Tooltip(
                    message: "Delete",
                    child: Icon(
                        Icons.delete_forever,
                        color: Colors.red[300],
                        size: 20,
                    ),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}