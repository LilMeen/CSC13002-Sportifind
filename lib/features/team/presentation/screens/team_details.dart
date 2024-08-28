// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/features/profile/domain/entities/player_entity.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';
import 'package:sportifind/features/team/domain/usecases/delete_team.dart';
import 'package:sportifind/features/team/domain/usecases/get_team.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sportifind/features/team/domain/usecases/kick_player.dart';
import 'package:sportifind/features/team/domain/usecases/request_to_join_team.dart';
import 'package:sportifind/features/team/presentation/screens/edit_team_screen.dart';
import 'package:sportifind/features/team/presentation/widgets/player_list.dart';
import 'package:sportifind/features/team/presentation/screens/user_search_screen.dart';

class TeamDetails extends StatefulWidget {
  const TeamDetails({
    super.key,
    required this.teamId,
  }); // role: teamMember: normal - captain, other: have been added - have not
  final String teamId;

  @override
  State<TeamDetails> createState() => _TeamDetailsState();
}

class _TeamDetailsState extends State<TeamDetails>
    with SingleTickerProviderStateMixin {
  TeamEntity? teamInformation;
  List<PlayerEntity> teamMembers = [];
  String captain = '';
  bool isLoading = true;
  String role = '';
  late AnimationController animationController;
  late Future<void> _initializationFuture;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _initializationFuture = _initialize();
  }

  Future<void> _initialize() async {
    final teamInformation = await UseCaseProvider.getUseCase<GetTeam>()
        .call(
          GetTeamParams(id: widget.teamId),
        )
        .then((value) => value.data!);

    teamMembers = teamInformation.players;
    captain = teamInformation.captain.name;
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    if (teamInformation.captain.id == currentUserId) {
      role = 'captain';
    } else if (teamInformation.players
        .any((element) => element.id == currentUserId)) {
      role = 'member';
    } else {
      role = 'other';
    }
    setState(() {
      this.teamInformation = teamInformation;
      isLoading = false;
    });
  }

  String get foundedDate {
    return '${teamInformation!.foundedDate.day}/${teamInformation!.foundedDate.month}/${teamInformation!.foundedDate.year}';
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    return FutureBuilder<void>(
      future: _initializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error loading data"));
        } else {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                'Team Information',
                style: SportifindTheme.sportifindAppBarForFeature.copyWith(
                  fontSize: 28,
                  color: SportifindTheme.bluePurple,
                ),
                textAlign: TextAlign.center,
              ),
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    _showCustomDialog(context);
                  },
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
                child: Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                        child: SizedBox(
                          height: 100,
                          width: 300,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    NetworkImage(teamInformation!.avatar.path),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        teamInformation!.name,
                                        style: SportifindTheme
                                            .sportifindAppBarForFeature
                                            .copyWith(
                                          fontSize: 25,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Members   ',
                                        style: SportifindTheme.normalTextWhite
                                            .copyWith(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        '${teamInformation!.players.length}',
                                        style: SportifindTheme.normalTextBlack
                                            .copyWith(
                                          fontSize: 16,
                                          color: SportifindTheme.bluePurple,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Captain     ',
                                        style: SportifindTheme.normalTextWhite
                                            .copyWith(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        captain,
                                        style: SportifindTheme.normalTextWhite
                                            .copyWith(
                                          fontSize: 16,
                                          color: SportifindTheme.bluePurple,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 8, bottom: 8, left: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Details',
                              style: SportifindTheme.featureTitleBlack.copyWith(
                                fontSize: 24,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 16,
                                  child: Icon(
                                    Icons.location_on,
                                    color: SportifindTheme.bluePurple,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${teamInformation!.location.district}, ${teamInformation!.location.city} City',
                                  style:
                                      SportifindTheme.normalTextWhite.copyWith(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 16,
                                  child: Icon(
                                    Icons.date_range,
                                    color: SportifindTheme.bluePurple,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  foundedDate,
                                  style:
                                      SportifindTheme.normalTextWhite.copyWith(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Images',
                                  style: SportifindTheme.featureTitleBlack
                                      .copyWith(
                                    fontSize: 24,
                                    color: Colors.black,
                                  ),
                                ),
                                teamInformation!.images?.isEmpty ?? true
                                    ? Text(
                                        ' (No images)',
                                        style: SportifindTheme.normalTextBlack
                                            .copyWith(
                                          color: Colors.grey,
                                          fontSize: 16,
                                        ),
                                      )
                                    : const SizedBox(
                                        height: 0,
                                        width: 0,
                                      ),
                              ],
                            ),
                            const SizedBox(height: 7),
                            SizedBox(
                              height: teamInformation!.images?.isEmpty ?? true
                                  ? 0
                                  : 200, // Set the desired height for the scrollable area
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: teamInformation!.images
                                    ?.length, // Assuming teamInformation has a list of image URLs
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Card(
                                      shadowColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Image.network(
                                        teamInformation!.images![index]
                                            .path, // Replace with your image URL
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Members',
                          style: SportifindTheme.featureTitleBlack.copyWith(
                            fontSize: 24,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      PlayerList(
                        members: teamMembers,
                        role: role,
                        team: teamInformation,
                      ),

                      // create a elevated button here
                      (role == 'captain' || role == 'member')
                          ? const SizedBox(
                              height: 0,
                              width: 0,
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: SportifindTheme.bluePurple,
                                    minimumSize: const Size(200, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  onPressed: () {
                                    UseCaseProvider.getUseCase<
                                            RequestToJoinTeam>()
                                        .call(
                                      RequestToJoinTeamParams(
                                        userId: FirebaseAuth
                                            .instance.currentUser!.uid,
                                        teamId: teamInformation!.id,
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Request sent'),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Join',
                                    style: SportifindTheme.featureTitleBlack
                                        .copyWith(
                                      fontSize: 28,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(color: SportifindTheme.bluePurple, width: 2.0),
          ),
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              'Choose an Option',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: SportifindTheme.bluePurple,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              role == 'captain' || role == 'member'
                  ? Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.withOpacity(0.5),
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading:
                            Icon(Icons.edit, color: SportifindTheme.bluePurple),
                        title: Text(
                          'Find Players',
                          style: SportifindTheme.normalTextBlack.copyWith(
                            fontSize: 16,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const UserSearchScreen(),
                            ),
                          );
                          // Handle the edit action
                          //Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Moving to Edit Team'),
                            ),
                          );
                        },
                      ),
                    )
                  : const SizedBox(
                      height: 0,
                      width: 0,
                    ),
              role == 'captain'
                  ? Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.withOpacity(0.5),
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading:
                            Icon(Icons.edit, color: SportifindTheme.bluePurple),
                        title: Text(
                          'Edit Team',
                          style: SportifindTheme.normalTextBlack.copyWith(
                            fontSize: 16,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => EditTeamScreen(
                                team: teamInformation,
                              ),
                            ),
                          );
                          // Handle the edit action
                          //Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Moving to Edit Team'),
                            ),
                          );
                        },
                      ),
                    )
                  : const SizedBox(
                      height: 0,
                      width: 0,
                    ),
              role == 'captain' || role == 'member'
                  ? Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.withOpacity(0.5),
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.output_outlined,
                            color: Colors.red.withOpacity(0.9)),
                        title: Text(
                          'Leave Team',
                          style: SportifindTheme.normalTextBlack.copyWith(
                            fontSize: 16,
                          ),
                        ),
                        onTap: () {
                          UseCaseProvider.getUseCase<KickPlayer>().call(
                            KickPlayerParams(
                              team: teamInformation!,
                              player: teamInformation!.players.firstWhere(
                                (element) =>
                                    element.id ==
                                    FirebaseAuth.instance.currentUser!.uid,
                              ),
                              type: 'leave',
                            ),
                          );
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'You have left ${teamInformation!.name}'),
                            ),
                          );
                        },
                      ),
                    )
                  : const SizedBox(
                      height: 0,
                      width: 0,
                    ),
              role == 'captain'
                  ? Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.withOpacity(0.5),
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.delete,
                          color: Colors.red.withOpacity(0.9),
                        ),
                        title: Text(
                          'Delete Team',
                          style: SportifindTheme.normalTextBlack.copyWith(
                            fontSize: 16,
                          ),
                        ),
                        onTap: () async {
                          await UseCaseProvider.getUseCase<DeleteTeam>().call(
                            DeleteTeamParams(teamId: teamInformation!.id),
                          );
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'You have deleted ${teamInformation!.name}'),
                            ),
                          );
                        },
                      ),
                    )
                  : const SizedBox(
                      height: 0,
                      width: 0,
                    ),
            ],
          ),
        );
      },
    );
  }
}
