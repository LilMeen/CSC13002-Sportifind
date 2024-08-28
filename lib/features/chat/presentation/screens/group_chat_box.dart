import 'package:flutter/material.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/features/chat/domain/entities/message_entity.dart';
import 'package:sportifind/features/chat/domain/usecases/get_message_by_team.dart';
import 'package:sportifind/features/chat/domain/usecases/send_message.dart';
import 'package:sportifind/features/chat/presentation/widgets/message_tile.dart';
import 'package:sportifind/features/user/domain/entities/user_entity.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';

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
  Widget teamMessages = Container();
  final ScrollController _scrollController = ScrollController();

  Stream<List<MessageEntity>> getMessagesStream() async* {
    final result = await UseCaseProvider.getUseCase<GetMessageByTeam>()
        .call(GetMessageByTeamParams(teamId: widget.teamId));

    if (result.isSuccess) {
      yield result.data ?? [];
    } else {
      yield [];
    }
  }

  Widget _loadTeamMessage() {
    return StreamBuilder<List<MessageEntity>>(
      stream: getMessagesStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          ); 
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error loading messages'),
          );
        }
        _messages = snapshot.data!;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent);
          }
        });
        return ListView.builder(
          controller: _scrollController,
          itemCount: _messages.length + 1,
          itemBuilder: (context, index) {
            if (index == _messages.length) {
              return const SizedBox(height: 75);
            } else {
              final message = _messages[index];
              return MessageTile(
                message: message,
              );
            }
          },
        );
      },
    );
  }

  Future<void> _sendMessage(context) async {
    if (messageEditingController.text.isNotEmpty) {
      await UseCaseProvider.getUseCase<SendMessage>().call(SendMessageParams(
          teamId: widget.teamId,
          message: MessageEntity(
              sender: widget.currentUser,
              message: messageEditingController.text,
              time: DateTime.now())));
      messageEditingController.clear();
      FocusScope.of(context).unfocus();
    }
    setState(() {
      _initialize();
    });
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    teamMessages = _loadTeamMessage();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
    setState(() {});
  }

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.teamName,
          style: SportifindTheme.sportifindAppBarForFeature.copyWith(
            fontSize: 28,
            color: SportifindTheme.bluePurple,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        shadowColor: Colors.black.withOpacity(0.8),
        leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context, _messages.last);
        },
      ),
      ),
      body: Stack(
        children: <Widget>[
          teamMessages,
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 246, 242, 242),
                border: Border(
                  top: BorderSide(
                      color: Colors.grey.withOpacity(0.5), width: 0.5),
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageEditingController,
                      style: SportifindTheme.normalTextBlack.copyWith(
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                          hintText: "  Send a message ...",
                          hintStyle: SportifindTheme.normalTextBlack.copyWith(
                            fontSize: 16,
                            color: const Color.fromARGB(255, 113, 110, 110),
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  GestureDetector(
                    onTap: () async {
                      await _sendMessage(context);
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
