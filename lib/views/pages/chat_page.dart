import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_services.dart';
import 'package:chat_app/views/widgets/chat_bubble.dart';
import 'package:chat_app/views/widgets/my_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:share_plus/share_plus.dart';

import '../../services/permissions.dart';
import '../widgets/contacts_bottom_sheet.dart';

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
  String? _location;

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
    // _fetchContacts();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _msgController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    bool permissionGranted = await Permissions.requestLocationPermission();
    if (!permissionGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permissions are denied.')),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _location =
          "https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";
    });
  }

  void _shareContent() async {
    await _getCurrentLocation();
    if (_location != null) {
      String message = 'Here is my location: $_location\n';
      Share.share(message);
    }
  }

  // Send a regular message
  void sendMsg() async {
    if (_msgController.text.isNotEmpty) {
      await _chatService.sendMsg(widget.receiverID, _msgController.text);
      _msgController.clear();
    }
    scrollDown();
  }

  // Add method to pick contact and share it
  void chooseContact(BuildContext context, String receiverID) async {
    List<Contact> contacts = await getAllContacts();
    if (contacts.isNotEmpty) {
      print(contacts);
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return ContactListBottomSheet(
            contacts: contacts,
            onContactSelected: (contact) {
              sendContact(contact, receiverID);
            },
          );
        },
      );
    }
  }

  Future<List<Contact>> getAllContacts() async {
    bool permissionGranted = await Permissions.requestContactsPermission();
    if (!permissionGranted) {
      return [];
    }
    return await FlutterContacts.getContacts(withProperties: true);
  }

  void sendContact(Contact contact, String receiverID) async {
    String contactInfo =
        "Name: ${contact.displayName}, Phone: ${contact.phones.isNotEmpty ? contact.phones.first.number : 'No phone number'}";
    await _chatService.sendMsg(receiverID, contactInfo);
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
          // Display all the messages
          Expanded(child: _buildMsgList()),
          // Type new message or share content
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
    // If current user or not
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    // Alignment of current user's message
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
            margin: const EdgeInsets.only(left: 10),
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
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: IconButton(
              onPressed: () => _showActionMenu(context),
              icon: const Icon(
                Icons.expand_less,
                color: Colors.white,
              ),
              style: IconButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Show the action menu with options
  void _showActionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text("Share Location"),
              onTap: () {
                _shareContent();
                Navigator.pop(context); // Close menu after selecting
              },
            ),
            ListTile(
              leading: const Icon(Icons.contacts),
              title: const Text("Share Contact"),
              onTap: () async {
                chooseContact(context, widget.receiverID);
                Navigator.pop(context); // Close menu after selecting
              },
            ),
          ],
        );
      },
    );
  }
}
