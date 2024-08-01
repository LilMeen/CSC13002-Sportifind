import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/screens/message/util/database_service.dart';
import 'package:sportifind/screens/message/widgets/message_tile.dart';
import 'package:sportifind/screens/message/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart'; 

class GroupChatBox extends StatefulWidget {
  const GroupChatBox(
      {super.key,
      required this.teamId,
      required this.userName,
      required this.teamName});

  final String teamId;
  final String userName;
  final String teamName;

  @override
  State<GroupChatBox> createState() => _GroupChatBoxState();
}

class _GroupChatBoxState extends State<GroupChatBox> {
  TextEditingController messageEditingController = TextEditingController();
  Stream<List<Message>>? _messages; 
  
  Stream<List<Message>> getTeamMessages() {
    return MessageService()
        .teamsCollection
        .doc(widget.teamId)
        .collection('messages')
        .orderBy('time')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Message.fromDocument(doc)).toList());
  }

  Widget _sentMessages() {
    return StreamBuilder<List<Message>>(
      stream: _messages,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No messages yet.'));
        } else {
          final messages = snapshot.data!;
          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              return MessageTile(
                message: message,
              );
            },
          );
        }
      },
    );
  }

  void _sendMessage() {
    if (messageEditingController.text.isNotEmpty) {
      MessageService()
          .teamsCollection
          .doc(widget.teamId)
          .collection('messages')
          .add({
        'sender': widget.userName,
        'message': messageEditingController.text,
        'sentBy': FirebaseAuth.instance.currentUser!.uid,
        'time': Timestamp.now(),
      });
      messageEditingController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    _messages = getTeamMessages();
  }

  @override
  Widget build(context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _sentMessages(),
          // Container(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              color: Colors.grey[700],
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageEditingController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                          hintText: "Send a message ...",
                          hintStyle: TextStyle(
                            color: Colors.white38,
                            fontSize: 16,
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  GestureDetector(
                    onTap: () {
                      _sendMessage();
                    },
                    child: Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(50)),
                      child: const Center(
                          child: Icon(Icons.send, color: Colors.white)),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}