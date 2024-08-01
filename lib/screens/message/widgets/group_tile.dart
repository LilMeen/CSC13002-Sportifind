import 'package:flutter/material.dart';
import 'package:sportifind/screens/message/screens/group_chat_box.dart';

class GroupChatTile extends StatelessWidget {
  const GroupChatTile(
      {super.key,
      required this.userName,
      required this.teamName,
      required this.teamId});

  final String userName;
  final String teamName;
  final String teamId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GroupChatBox(
                    teamId: teamId, teamName: teamName, userName: userName)));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30.0,
            backgroundColor: Colors.blueAccent,
            child: Text(teamName.substring(0, 1).toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white)),
          ),
          title: Text(teamName,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("Join the conversation as $userName",
              style: const TextStyle(fontSize: 13.0)),
        ),
      ),
    );
  }
}