import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_services.dart';
import 'package:chat_app/views/widgets/chat_bubble.dart';
import 'package:chat_app/views/widgets/my_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  const ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _msgController = TextEditingController();

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  final ScrollController _scrollController = ScrollController();

  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });
    Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _msgController.dispose();
    super.dispose();
  }

  void sendMsg() async {
    if (_msgController.text.isNotEmpty) {
      await _chatService.sendMsg(widget.receiverID, _msgController.text);
      _msgController.clear();
    }
    scrollDown();
  }

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Column(
        children: [
          //display all the msgs
          Expanded(child: _buildMsgList()),
          //type new msg
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMsgList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
        stream: _chatService.getMessages(widget.receiverID, senderID),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("snapshot.hasError ${snapshot.hasError}");
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView(
              controller: _scrollController,
              children:
                  snapshot.data!.docs.map((doc) => _buildMsgItem(doc)).toList(),
            );
          }
        });
  }

  Widget _buildMsgItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    //if current user or not
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    //alignment of current user's msg
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: ChatBubble(isCurrentUser: isCurrentUser, message: data['message']),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0, right: 25, left: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: MyTextField(
              focusNode: myFocusNode,
              hintText: "Type a message.. ",
              obscureText: false,
              controller: _msgController,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 25),
            child: IconButton(
              onPressed: sendMsg,
              icon: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
              style: IconButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
