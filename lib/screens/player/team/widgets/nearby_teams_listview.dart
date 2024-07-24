import 'package:flutter/material.dart';
import 'package:sportifind/adapter/hex_color.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/screens/player/team/models/team_information.dart';

class NearbyTeamListView extends StatefulWidget {
  const NearbyTeamListView({super.key, this.callBack});
  final Function()? callBack;

  @override
  State<NearbyTeamListView> createState() => _NearbyTeamListViewState();
}

class _NearbyTeamListViewState extends State<NearbyTeamListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<TeamInformation> teams = [];
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
    getAllTeams();
  }

  bool isNotJoined(String team, List<String> joinedTeams) {
    return !joinedTeams.any((element) => element == team);
  }

  Future<void> getAllTeams() async {
    List<TeamInformation> fetchedTeam = [];

    try {
      final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
      final DocumentReference currentUser =
          FirebaseFirestore.instance.collection('users').doc(currentUserUid);
      final DocumentSnapshot userSnapshot = await currentUser.get();

      if (userSnapshot.exists) {
        List<dynamic> joinedTeamsDynamic = userSnapshot['joinedTeams'] ?? [];
        List<String> joinedTeams =
            joinedTeamsDynamic.map((team) => team.toString()).toList();

        // Get the collection reference
        CollectionReference teamsCollection =
            FirebaseFirestore.instance.collection('teams');
        QuerySnapshot querySnapshot = await teamsCollection.get();

        // Iterate through the documents
        for (DocumentSnapshot doc in querySnapshot.docs) {
          if (isNotJoined(doc.id, joinedTeams)) {
            fetchedTeam.add(
              TeamInformation(
                name: doc['name'],
                address: doc['address'],
                district: doc['district'],
                city: doc['city'],
                avatarImageUrl: doc['avatarImage'],
                members: List<String>.from(doc['members']),
                captain: doc['captain'],
                teamId: doc.id,
              ),
            );
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while fetching nearby teams!'),
        ),
      );
    }

    setState(() {
      teams = fetchedTeam;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: GridView(
          padding: const EdgeInsets.all(8),
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 32.0,
            crossAxisSpacing: 32.0,
            childAspectRatio: 0.8,
          ),
          children: List<Widget>.generate(
            teams.length,
            (int index) {
              final int count = teams.length;
              final Animation<double> animation =
                  Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: animationController!,
                  curve: Interval((1 / count) * index, 1.0,
                      curve: Curves.fastOutSlowIn),
                ),
              );
              animationController?.forward();
              return NearbyTeamBox(
                callback: widget.callBack,
                team: teams[index],
                animation: animation,
                animationController: animationController,
              );
            },
          ),
        ));
  }
}

class NearbyTeamBox extends StatelessWidget {
  const NearbyTeamBox(
      {super.key,
      this.team,
      this.animationController,
      this.animation,
      this.callback});

  final VoidCallback? callback;
  final TeamInformation? team;
  final AnimationController? animationController;
  final Animation<double>? animation;

  int get getMemberCount {
    return team!.members.length;
  }

  // void switchToTeamDetails(context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => TeamMainScreen(
  //           team:
  //               team), // can't do like this cause can't show team new member if we add
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: callback,
              child: SizedBox(
                height: 280,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    SizedBox(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: HexColor('#F8FAFB'),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(16.0)),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: SizedBox(
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16, left: 16, right: 16),
                                            child: Text(
                                              team!.name,
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                letterSpacing: 0.27,
                                                color:
                                                    SportifindTheme.darkerText,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8,
                                                left: 16,
                                                right: 16,
                                                bottom: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  '$getMemberCount members',
                                                  textAlign: TextAlign.left,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 14,
                                                    letterSpacing: 0.27,
                                                    color: SportifindTheme.grey,
                                                  ),
                                                ),
                                                 SizedBox(
                                                  child: Row(
                                                    children: <Widget>[
                                                      const Text(
                                                        '5',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w200,
                                                          fontSize: 18,
                                                          letterSpacing: 0.27,
                                                          color: SportifindTheme
                                                              .grey,
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons.star,
                                                        color: SportifindTheme
                                                            .bluePurple1,
                                                        size: 20,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 48,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 48,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 24, right: 16, left: 16),
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0)),
                          ),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16.0)),
                            child: AspectRatio(
                              aspectRatio: 1.28,
                              child: Image.network(
                                team!.avatarImageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
