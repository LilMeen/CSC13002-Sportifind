import 'package:flutter/material.dart';
import 'package:sportifind/adapter/hex_color.dart';
import 'package:sportifind/models/location_info.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/screens/player/team/models/team_information.dart';
import 'package:sportifind/screens/player/team/screens/team_details.dart';

class MyTeamsListView extends StatefulWidget {
  const MyTeamsListView({super.key, required this.callBack});
  final Function()? callBack;

  @override
  State<MyTeamsListView> createState() => _MyTeamsListViewState();
}

class _MyTeamsListViewState extends State<MyTeamsListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<TeamInformation> teamsInformation = [];
  bool isLoading = true;
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
    joinedTeam();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  Future<void> joinedTeam() async {
    try {
      final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

      final DocumentReference currentUser =
          FirebaseFirestore.instance.collection('users').doc(currentUserUid);
      final DocumentSnapshot userSnapshot = await currentUser.get();

      if (userSnapshot.exists) {
        List<dynamic> joinedTeamsDynamic = userSnapshot['joinedTeams'] ?? [];
        List<String> joinedTeams =
            joinedTeamsDynamic.map((team) => team.toString()).toList();

        List<TeamInformation> fetchedTeams = [];
        for (var team in joinedTeams) {
          final DocumentReference teamRef =
              FirebaseFirestore.instance.collection('teams').doc(team);
          final DocumentSnapshot teamSnapshot = await teamRef.get();

          if (teamSnapshot.exists) {
            final location = LocationInfo(
              address: teamSnapshot['address'],
              district: teamSnapshot['district'],
              city: teamSnapshot['city'],
            );

            final teamInformation = TeamInformation(
              name: teamSnapshot['name'],
              location: location,
              avatarImageUrl: teamSnapshot['avatarImage'],
              incoming: Map<String, bool>.from(teamSnapshot['incoming']),
              members: List<String>.from(teamSnapshot['members']),
              captain: teamSnapshot['captain'],
              teamId: teamSnapshot.id,
            );
            fetchedTeams.add(teamInformation);
          }
        }

        setState(() {
          teamsInformation = fetchedTeams;
          isLoading = false; // Update loading state
        });
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'User document does not exist. Please sign out and sign in again.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while fetching your teams list'),
        ),
      );
    }
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: SizedBox(
        height: 134,
        width: double.infinity,
        child: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return ListView.builder(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 16, left: 16),
                itemCount: teamsInformation.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final int count = teamsInformation.length > 10
                      ? 10
                      : teamsInformation.length;
                  final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: animationController!,
                              curve: Interval((1 / count) * index, 1.0,
                                  curve: Curves.fastOutSlowIn)));
                  animationController?.forward();

                  return TeamBox(
                      teamInformation: teamsInformation[index],
                      animation: animation,
                      animationController: animationController,
                      callback: widget.callBack);
                  // );
                  // } else if (index == Category.categoryList.length) {
                  //   return AddTeam(
                  //     animation: animation,
                  //     animationController: animationController,
                  //     addTeam: callBack,
                  //   );
                  // }
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class TeamBox extends StatelessWidget {
  const TeamBox(
      {super.key,
      this.teamInformation,
      this.animationController,
      this.animation,
      this.callback});

  final Function()? callback;
  final TeamInformation? teamInformation;
  final AnimationController? animationController;
  final Animation<double>? animation;

  int get getMemberCount {
    return teamInformation!.members.length;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - animation!.value), 0.0, 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return TeamDetails(teamId: teamInformation!.teamId);
                    },
                  ),
                ),
              },
              child: SizedBox(
                width: 300,
                child: Stack(
                  children: <Widget>[
                    SizedBox(
                      child: Row(
                        children: <Widget>[
                          const SizedBox(
                            width: 48,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: HexColor('#F8FAFB'),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(16.0)),
                              ),
                              child: Row(
                                children: <Widget>[
                                  const SizedBox(
                                    width: 48 + 24.0,
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 16),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  teamInformation!.name,
                                                  textAlign: TextAlign.left,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 19,
                                                    letterSpacing: 0.27,
                                                    color: SportifindTheme
                                                        .darkerText,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Expanded(
                                            child: SizedBox(),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 16, bottom: 8),
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
                                                    fontSize: 16,
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
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 6, right: 16),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Medium Level',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                    letterSpacing: 0.27,
                                                    color: SportifindTheme
                                                        .bluePurple3,
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: SportifindTheme
                                                        .bluePurple3,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                8.0)),
                                                  ),
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(4.0),
                                                    child: Icon(
                                                      Icons.notifications,
                                                      color:
                                                          SportifindTheme.white,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 24, bottom: 24, left: 16),
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16.0)),
                              child: AspectRatio(
                                aspectRatio: 1.0,
                                child: Image.network(
                                  teamInformation!.avatarImageUrl,
                                  height: 64.0,
                                  width: 64.0,
                                ),
                              ),
                            )
                          ],
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

// class AddTeam extends StatelessWidget {
//   const AddTeam(
//       {super.key, this.animationController, this.animation, this.addTeam});

//   final Function()? addTeam;
//   final AnimationController? animationController;
//   final Animation<double>? animation;

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: animationController!,
//       builder: (BuildContext context, Widget? child) {
//         return FadeTransition(
//           opacity: animation!,
//           child: Transform(
//             transform: Matrix4.translationValues(
//                 100 * (1.0 - animation!.value), 0.0, 0.0),
//             child: InkWell(
//               splashColor: Colors.transparent,
//               onTap: addTeam,
//               child: SizedBox(
//                 width: 270,
//                 child: Stack(
//                   children: <Widget>[
//                     SizedBox(
//                       child: Row(
//                         children: <Widget>[
//                           const SizedBox(
//                             width: 48,
//                           ),
//                           Expanded(
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: HexColor('#F8FAFB'),
//                                 borderRadius: const BorderRadius.all(
//                                     Radius.circular(16.0)),
//                               ),
//                               child: const Row(
//                                 children: <Widget>[
//                                   SizedBox(
//                                     width: 48 + 24.0,
//                                   ),
//                                   Expanded(
//                                     child: SizedBox(
//                                       child: Column(
//                                         children: <Widget>[
//                                           const Padding(
//                                             padding: EdgeInsets.only(top: 16),
//                                             child: Text(
//                                               'Add new team',
//                                               textAlign: TextAlign.left,
//                                               style: TextStyle(
//                                                 fontWeight: FontWeight.w600,
//                                                 fontSize: 16,
//                                                 letterSpacing: 0.27,
//                                                 color:
//                                                     SportifindTheme.darkerText,
//                                               ),
//                                             ),
//                                           ),
//                                           Expanded(
//                                             child: SizedBox(),
//                                           ),
//                                           Padding(
//                                             padding: EdgeInsets.only(
//                                                 right: 16, bottom: 8),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.center,
//                                               children: <Widget>[
//                                                 Text(
//                                                   '... members',
//                                                   textAlign: TextAlign.left,
//                                                   style: TextStyle(
//                                                     fontWeight: FontWeight.w200,
//                                                     fontSize: 12,
//                                                     letterSpacing: 0.27,
//                                                     color: SportifindTheme.grey,
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   child: Row(
//                                                     children: <Widget>[
//                                                       Text(
//                                                         'rating',
//                                                         textAlign:
//                                                             TextAlign.left,
//                                                         style: TextStyle(
//                                                           fontWeight:
//                                                               FontWeight.w200,
//                                                           fontSize: 18,
//                                                           letterSpacing: 0.27,
//                                                           color: SportifindTheme
//                                                               .grey,
//                                                         ),
//                                                       ),
//                                                       Icon(
//                                                         Icons.star,
//                                                         color: SportifindTheme
//                                                             .nearlyBlue,
//                                                         size: 20,
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: EdgeInsets.only(
//                                                 bottom: 6, right: 16),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: <Widget>[
//                                                 Text(
//                                                   'Age: 18 - 20',
//                                                   textAlign: TextAlign.left,
//                                                   style: TextStyle(
//                                                     fontWeight: FontWeight.w600,
//                                                     fontSize: 18,
//                                                     letterSpacing: 0.27,
//                                                     color: SportifindTheme
//                                                         .nearlyBlue,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       child: Padding(
//                         padding: const EdgeInsets.only(
//                             top: 24, bottom: 24, left: 16),
//                         child: Row(
//                           children: <Widget>[
//                             ClipRRect(
//                               borderRadius:
//                                   const BorderRadius.all(Radius.circular(16.0)),
//                               child: AspectRatio(
//                                   aspectRatio: 1.0,
//                                   child: Image.asset(
//                                       'lib/assets/button_icon/tab_3s.png')),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
