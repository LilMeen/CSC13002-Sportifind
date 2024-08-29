import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/features/team/domain/usecases/invite_player_to_team.dart';
import 'package:sportifind/features/profile/domain/entities/player_entity.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';

class AddToTeamList extends StatefulWidget {
  const AddToTeamList(
      {super.key, required this.viewerTeams, required this.player});
  final List<TeamEntity?> viewerTeams;
  final PlayerEntity player;

  @override
  State<AddToTeamList> createState() => _AddToTeamListState();
}

class _AddToTeamListState extends State<AddToTeamList> {
  // Initialize a list to track the button states for each team
  final List<int> _buttonStates = [];

  bool _isJoined(PlayerEntity player, TeamEntity team) {
    return team.players.contains(player);
  }

  bool _hasSentInvitation(PlayerEntity playerId, TeamEntity team) {
    if (team.invitedPlayers == null) {
      return false;
    }

    return team.invitedPlayers!.contains(playerId);
  }

  @override
  void initState() {
    for (int i = 0; i < widget.viewerTeams.length; i++) {
      if (_isJoined(widget.player, widget.viewerTeams[i]!)) {
        _buttonStates.add(0); // joined
      } else if (_hasSentInvitation(widget.player, widget.viewerTeams[i]!)) {
        _buttonStates.add(1); // sent invited request
      } else {
        _buttonStates.add(2); // not joined
      }
    }

    super.initState();
    // Initialize the button states to false (not joined) for all teams
  }

  Widget _showTeamAddList() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTeamList(),
              ],
            ),
          ))
        ],
      ),
    );
  }

  Color _getButtonColor(int index) {
    switch (_buttonStates[index]) {
      case 0:
        return Colors.grey; // Joined
      case 1:
        return Colors.grey; // Sent invitation
      case 2:
        return Colors.green; // Not joined
      default:
        return Colors.green;
    }
  }

  Text _getButtonText(int index) {
    switch (_buttonStates[index]) {
      case 0:
        return Text(
          'Joined',
          style: SportifindTheme.featureTitleBlack.copyWith(
            fontSize: 16,
            color: Colors.white,
          ),
        );
      case 1:
        return Text(
          'Invited',
          style: SportifindTheme.featureTitleBlack.copyWith(
            fontSize: 16,
            color: Colors.white,
          ),
        );
      case 2:
        return Text(
          'Add',
          style: SportifindTheme.featureTitleBlack.copyWith(
            fontSize: 16,
            color: Colors.white,
          ),
        );
      default:
        return Text(
          'Add',
          style: SportifindTheme.featureTitleBlack.copyWith(
            fontSize: 16,
            color: Colors.white,
          ),
        );
    }
  }

  Widget _buildTeamList() {
    return ListView.builder(
      shrinkWrap:
          true, // Prevents the list from taking infinite height inside the dialog
      itemCount: widget.viewerTeams.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black.withOpacity(0.5),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                ' ${index + 1}',
                style: SportifindTheme.normalTextBlack.copyWith(
                  fontSize: 20,
                  color: SportifindTheme.bluePurple.withOpacity(0.7),
                ),
              ),
              Expanded(
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      widget.viewerTeams[index]!.avatar.path,
                    ),
                  ),
                  title: Text(
                    widget.viewerTeams[index]!.name,
                    style: SportifindTheme.normalTextBlack.copyWith(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                      '${widget.viewerTeams[index]!.players.length} members'),
                  trailing: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        _getButtonColor(
                            index), // Set the color based on the state
                      ),
                    ),
                    onPressed: _buttonStates[index] == 2
                        ? () {
                            // Toggle the state of the button when tapped
                            setState(() {
                              _buttonStates[index] = 1;
                            });
                            // Add player here
                            setState(() async {
                              await UseCaseProvider.getUseCase<
                                      InvitePlayerToTeam>()
                                  .call(
                                InvitePlayerToTeamParams(
                                  teamId: widget.viewerTeams[index]!.id,
                                  userId: widget.player.id,
                                ),
                              );
                            });
                          }
                        : null,
                    child: _getButtonText(index),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Team List',
          style: SportifindTheme.sportifindAppBarForFeature.copyWith(
            fontSize: 28,
            color: SportifindTheme.bluePurple,
          ),
          textAlign: TextAlign.left,
        ),
      ),
      body: _showTeamAddList(),
    );
  }
}
