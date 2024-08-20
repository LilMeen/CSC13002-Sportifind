import 'package:flutter/material.dart';
import 'package:sportifind/main.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/screens/player/team/models/team_information.dart';
import 'package:sportifind/screens/player/team/screens/edit_team.dart';
import 'package:sportifind/widgets/dropdown_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sportifind/screens/player/team/widgets/app_bar.dart';
import 'package:sportifind/adapter/hex_color.dart';
import 'package:sportifind/screens/player/team/models/team_information.dart';
import 'package:sportifind/screens/player/team/screens/player_details.dart';
import 'package:sportifind/util/team_service.dart';
import 'package:sportifind/models/player_data.dart';
import 'package:sportifind/screens/player/team/widgets/player_list.dart';
import 'package:sportifind/util/object_handling.dart';

class TeamDetails extends StatefulWidget {
  const TeamDetails(
      {super.key,
      required this.teamId,
      required this.role}); // role: teamMember: normal - captain, other: have been added - have not
  final String teamId;
  final String role;

  @override
  State<TeamDetails> createState() => _TeamDetailsState();
}

class _TeamDetailsState extends State<TeamDetails>
    with SingleTickerProviderStateMixin {
  TeamService teamService = TeamService();
  TeamHandling teamHandling = TeamHandling();
  TeamInformation? teamInformation;
  List<PlayerData> teamMembers = [];
  String captain = '';
  bool isLoading = true;
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
    final teamInformation = await teamService.getTeamInformation(widget.teamId);
    List<String> teamMems = teamInformation!.members;
    captain = await teamService.getTeamCaptain(widget.teamId);
    teamMembers = await teamService.getPlayersData(teamMems);
    setState(() {
      this.teamInformation = teamInformation;
      isLoading = false;
    });
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
                (widget.role == 'normal' || widget.role == 'captain')
                    ? IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {
                          _showCustomDialog(context);
                        },
                      )
                    : const SizedBox(width: 0, height: 0),
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
                                backgroundImage: NetworkImage(
                                    teamInformation!.avatarImageUrl),
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
                                        'Members ',
                                        style: SportifindTheme.normalTextWhite
                                            .copyWith(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        '${teamService.getTeamMemberCount(teamInformation!)}',
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
                                        'Captain   ',
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
                              style: SportifindTheme.normalTextBlack.copyWith(
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
                                  radius: 16,
                                  backgroundColor: Colors.grey,
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
                                  radius: 16,
                                  backgroundColor: Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  teamInformation!.foundedDate.toString(),
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
                              children: [
                                Text(
                                  'Images',
                                  style:
                                      SportifindTheme.normalTextBlack.copyWith(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                teamInformation!.images.isEmpty
                                    ? Text(
                                        '       No image yet',
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
                            const SizedBox(height: 5),
                            teamInformation!.images.isNotEmpty
                                ? SizedBox(
                                    height:
                                        200, // Set the desired height for the scrollable area
                                    child: ListView.builder(
                                      itemCount: teamInformation!.images
                                          .length, // Assuming teamInformation has a list of image URLs
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: Image.network(
                                            teamInformation!.images[
                                                index], // Replace with your image URL
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : const SizedBox(
                                    height: 0,
                                    width: 0,
                                  )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Members',
                          style: SportifindTheme.normalTextBlack.copyWith(
                            fontSize: 24,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      PlayerList(
                        members: teamMembers,
                        type: 'view',
                        team: teamInformation,
                      ),

                      // create a elevated button here
                      (widget.role == 'captain' || widget.role == 'normal')
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
                                    teamHandling.sendUserRequest(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        teamInformation!.teamId);
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
              widget.role == 'captain'
                  ? ListTile(
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
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Moving to Edit Team'),
                          ),
                        );
                      },
                    )
                  : const SizedBox(
                      height: 0,
                      width: 0,
                    ),
              widget.role == 'captain'
                  ? const Divider()
                  : const SizedBox(
                      height: 0,
                      width: 0,
                    ),
              ListTile(
                leading: Icon(Icons.output_outlined,
                    color: Colors.red.withOpacity(0.9)),
                title: Text(
                  'Leave Team',
                  style: SportifindTheme.normalTextBlack.copyWith(
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  teamHandling.removePlayerFromTeam(
                    teamInformation!.teamId,
                    FirebaseAuth.instance.currentUser!.uid,
                    'left',
                  );
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('You have left ${teamInformation!.name}'),
                    ),
                  );
                },
              ),
              const Divider(),
              widget.role == 'captain'
                  ? ListTile(
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
                      onTap: () {
                        teamHandling.deleteTeam(teamInformation!.teamId);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'You have deleted ${teamInformation!.name}'),
                          ),
                        );
                      },
                    )
                  : const SizedBox(
                      height: 0,
                      width: 0,
                    ),
              widget.role == 'captain'
                  ? const Divider()
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
