import 'package:flutter/material.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/features/chat/domain/entities/message_entity.dart';
import 'package:sportifind/features/chat/domain/usecases/get_message_by_team.dart';
import 'package:sportifind/features/chat/domain/usecases/send_message.dart';
import 'package:sportifind/features/chat/presentation/widgets/message_tile.dart';
import 'package:sportifind/features/user/domain/entities/user_entity.dart'; 

class GroupChatBox extends StatefulWidget {
  const GroupChatBox(
      {super.key,
      required this.teamId,
      required this.currentUser,
      required this.teamName});

  final String teamId;
  final UserEntity currentUser;
  final String teamName;

  @override
  State<GroupChatBox> createState() => _GroupChatBoxState();
}

class _GroupChatBoxState extends State<GroupChatBox> {
  TextEditingController messageEditingController = TextEditingController();
  List<MessageEntity> _messages = []; 
  
  Future<List<MessageEntity>> getTeamMessages() async{
    return await 
      UseCaseProvider.getUseCase<GetMessageByTeam>().call(
        GetMessageByTeamParams(teamId: widget.teamId)
      ).then((value) => value.data ?? []);
  }

  Widget _loadTeamMessage() {
    return ListView.builder(
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return MessageTile(
          message: message,
        );
      },
    );
  }
        
  Future<void> _sendMessage() async {
    if (messageEditingController.text.isNotEmpty) {
      await UseCaseProvider.getUseCase<SendMessage>().call(
        SendMessageParams(
          teamId: widget.teamId,
          message: MessageEntity(
              sender: widget.currentUser,
              message: messageEditingController.text,
              time: DateTime.now()
          )
        )
      );
      messageEditingController.clear();
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    _messages = await getTeamMessages();
    setState(() {});
  }

  @override
  Widget build(context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _loadTeamMessage(),
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
                    onTap: () async{
                      await _sendMessage();
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