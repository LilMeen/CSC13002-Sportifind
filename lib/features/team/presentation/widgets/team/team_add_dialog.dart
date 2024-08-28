import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/core/util/team_util.dart';
import 'package:sportifind/features/profile/domain/entities/player_entity.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';
import 'package:sportifind/features/team/domain/usecases/get_team_by_player.dart';
import 'package:sportifind/features/team/presentation/widgets/team_list.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TeamListDialog extends StatefulWidget {
  const TeamListDialog(
      {super.key, required this.viewerTeams, required this.player});
  final List<TeamEntity?> viewerTeams;
  final PlayerEntity player;

  @override
  State<TeamListDialog> createState() => _TeamListDialogState();
}

class _TeamListDialogState extends State<TeamListDialog> {
  // Initialize a list to track the button states for each team
  late List<int> _buttonStates;

  void buttonStateInit() {
    for (int i = 0; i < widget.viewerTeams.length; i++) {
      if (_isJoined(widget.player, widget.viewerTeams[i]!)) {
        _buttonStates[i] = 0; // joined
      } else if (_hasSentInvitation(widget.player, widget.viewerTeams[i]!)) {
        _buttonStates[i] = 1; // sent invited request
      } else {
        _buttonStates[i] = 2; // not joined
      }
    }
  }

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
    buttonStateInit(); 
    super.initState();
    // Initialize the button states to false (not joined) for all teams
  }

  void _showTeamDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(color: SportifindTheme.bluePurple, width: 2.0),
          ),
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              'Team List',
              style: SportifindTheme.featureTitlePurple.copyWith(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: SportifindTheme.bluePurple,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [_buildTeamList()],
            ),
          ),
        );
      },
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
        return ListTile(
          title: Text(
            widget.viewerTeams[index]!.name,
            style: SportifindTheme.normalTextBlack.copyWith(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          subtitle:
              Text('${widget.viewerTeams[index]!.players.length} members'),
          trailing: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                _getButtonColor(
                    _buttonStates[index]), // Set the color based on the state
              ),
            ),
            onPressed: _buttonStates[index] == 2
                ? () {
                    setState(() {
                      // Toggle the state of the button when tapped
                      _buttonStates[index] = 1;
                    });
                  }
                : () {},
            child: _getButtonText(_buttonStates[index]),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showTeamDialog(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        minimumSize: const Size(200, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        'Add',
        style: SportifindTheme.featureTitleBlack.copyWith(
          fontSize: 28,
          color: Colors.white,
        ),
      ),
    );
  }
}
