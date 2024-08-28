import 'package:flutter/material.dart';
import 'package:sportifind/features/chat/presentation/screens/group_chat_box.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';
import 'package:sportifind/features/user/domain/entities/user_entity.dart';
import 'package:sportifind/features/chat/domain/entities/message_entity.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/features/chat/domain/usecases/get_message_by_team.dart';

class GroupChatTile extends StatefulWidget {
  const GroupChatTile({
    super.key,
    required this.currentUser,
    required this.team,
  });

  final UserEntity currentUser;
  final TeamEntity team;

  @override
  State<GroupChatTile> createState() => _GroupChatTileState();
}

class _GroupChatTileState extends State<GroupChatTile> {
  List<MessageEntity> _messages = [];
  MessageEntity? _latestMessage;
  bool isLoading = true;

  Future<List<MessageEntity>> getTeamMessages() async {
    return await UseCaseProvider.getUseCase<GetMessageByTeam>()
        .call(GetMessageByTeamParams(teamId: widget.team.id))
        .then((value) => value.data ?? []);
  }

  Future<MessageEntity> getLatestMessage() async {
    return _messages.last;
  }

  Future<void> _initialize() async {
    _messages = await getTeamMessages();
    _latestMessage = await getLatestMessage();
    setState(() {
      isLoading = false;
    });
  }

  String get getFirstCharacters {
    return _latestMessage!.message.substring(0, 12);
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return GestureDetector(
      onTap: () async {
        _latestMessage = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupChatBox(
                teamId: widget.team.id,
                teamName: widget.team.name,
                currentUser: widget.currentUser),
          ),
        );
        setState(() {
          _initialize();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30.0,
            backgroundImage: NetworkImage(widget.team.avatar.path),
          ),
          title: Text(widget.team.name,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _latestMessage!.message.length < 13
                  ? Text(
                      "${_latestMessage!.sender.name}: ${_latestMessage!.message}",
                      style: const TextStyle(fontSize: 13.0),
                    )
                  : Text(
                      "${_latestMessage!.sender.name}: $getFirstCharacters...",
                      style: const TextStyle(fontSize: 13.0),
                    ),
              Text(
                "${_latestMessage!.time.hour}:${_latestMessage!.time.minute}",
                style: const TextStyle(fontSize: 13.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
