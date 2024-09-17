import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';
import 'package:sportifind/home/player_home_screen.dart';

class TeamListItem extends StatefulWidget {
  const TeamListItem({
    super.key,
    required this.team,
    required this.hostId,
    required this.matchId,
  });

  final TeamEntity team;
  final String hostId;
  final String matchId;

  @override
  State<StatefulWidget> createState() => _TeamListItemState();
}

class _TeamListItemState extends State<TeamListItem> {
  final user = FirebaseAuth.instance.currentUser!;
  late ImageProvider teamImageProvider;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Ensure the image is loaded and the team data is updated
    preloadImage();
  }

  Future<void> preloadImage() async {
    teamImageProvider = NetworkImage(widget.team.avatar.path);
    await precacheImage(teamImageProvider, context);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (isLoading) {
      return const SizedBox();
    } else {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: SportifindTheme.bluePurple, width: 4),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: teamImageProvider,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.team.name,
                          style: SportifindTheme.teamDisplay,
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.compare_arrows),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              widget.team.captain.name,
                              style: SportifindTheme.body,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: SportifindTheme.bluePurple,
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Expanded(
                              child: Text(
                                "${widget.team.location.district}, ${widget.team.location.city}, ${widget.team.location.address}",
                                style: SportifindTheme.body,
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: width - 70,
              child: const Divider(
                thickness: 1,
                color: SportifindTheme.smokeScreen,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: SportifindTheme.bluePurple,
              ),
              width: width - 70,
              height: 40,
              child: TextButton(
                onPressed: () {
                  // UseCaseProvider.getUseCase<SendInvitationToMatch>().call(
                  //   SendInvitationToMatchParams(
                  //     teamSendId: widget.hostId,
                  //     teamReceiveId: widget.team.id,
                  //     matchId: widget.matchId,
                  //   ),
                  // );

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PlayerHomeScreen(),
                    ),
                  );
                },
                child: Text(
                  "Invite",
                  style: SportifindTheme.teamItem,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    }
  }
}
