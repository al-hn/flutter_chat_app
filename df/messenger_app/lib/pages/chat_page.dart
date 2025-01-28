import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../chat_bubble.dart';
import '../components/my_text_field.dart';
import '../services/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String recieverUserEmail;
  final String recieverUserID;

  const ChatPage({super.key, required this.recieverUserEmail, required this.recieverUserID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool _isSearching = false; // To track if search mode is active
  String _searchQuery = ""; // To store the search query

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.recieverUserID, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !_isSearching
            ? Text(
                widget.recieverUserEmail,
              )
            : TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.trim().toLowerCase();
                  });
                },
                decoration: const InputDecoration(
                  hintText: "Search messages...",
                  border: InputBorder.none,
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _searchQuery = "";
                  _searchController.clear();
                }
                _isSearching = !_isSearching;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

  // Message list with search functionality
  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _chatService.getMessages(
            widget.recieverUserID, _firebaseAuth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');
          }

          final List<DocumentSnapshot> allMessages = snapshot.data!.docs;
          final List<DocumentSnapshot> filteredMessages = allMessages.where((doc) {
            final message = (doc.data() as Map<String, dynamic>)['message'].toString().toLowerCase();
            return message.contains(_searchQuery);
          }).toList();

          return ListView(
            children: filteredMessages
                .map((document) => _buildMessageItem(document))
                .toList(),
          );
        });
  }

  // Message input field
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: "Enter Message",
              obscureText: false,
            ),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.arrow_upward,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }

  // Format the timestamp
  String formatTimestamp(Timestamp timestamp) {
    return DateFormat('h:mm a').format(timestamp.toDate());
  }

  // Message item UI
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // Get the timestamp from the data and format it
    Timestamp timestamp = data['timestamp'];
    String formattedTime = formatTimestamp(timestamp);

    // Align messages
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          children: [
            ChatBubble(message: data['message']),
            const SizedBox(height: 5),
            Text(
              formattedTime,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
