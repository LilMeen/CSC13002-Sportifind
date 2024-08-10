import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/screens/player/team/models/team_information.dart';
import 'package:sportifind/screens/message/widgets/group_tile.dart';

class GroupChatList extends StatefulWidget {
  const GroupChatList({super.key});
  @override
  State<GroupChatList> createState() => _GroupChatListState();
}

class _GroupChatListState extends State<GroupChatList>
    with TickerProviderStateMixin {

  Stream<List<TeamInformation>>? myTeams; 
  AnimationController? animationController;

  Stream<List<TeamInformation>> getMyTeams() async* {
  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  final DocumentReference userRef =
      FirebaseFirestore.instance.collection('users').doc(currentUserUid);

  // Listen to changes in the user document
  await for (var userSnapshot in userRef.snapshots()) {
    if (userSnapshot.exists) {
      List<dynamic> teamIds = userSnapshot['joinedTeams'] ?? [];
      
      List<TeamInformation> teams = [];
      for (String teamId in teamIds) {
        // Fetch each team's data
        DocumentReference<Map<String, dynamic>> teamRef =
            FirebaseFirestore.instance.collection('teams').doc(teamId);

        DocumentSnapshot<Map<String, dynamic>> teamSnapshot = await teamRef.get();
        if (teamSnapshot.exists) {
          teams.add(TeamInformation.fromSnapshot(teamSnapshot));
        }
      }
      yield teams;
    }
  }
}


  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    myTeams = getMyTeams();
    super.initState();
  }

  bool isNotJoined(String team, List<String> joinedTeams) {
    return !joinedTeams.any((element) => element == team);
  }

  Widget noGroupWidget() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
                onTap: () {},
                child: Icon(Icons.add_circle,
                    color: Colors.grey[700], size: 75.0)),
            const SizedBox(height: 20.0),
            const Text(
                "You've not joined any group, tap on the 'add' icon to create a group or search for groups by tapping on the search button below."),
          ],
        ));
  }

  Widget teamList() {
    return StreamBuilder(
      stream: myTeams,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No groups yet.'));
        } else {
          final myTeams = snapshot.data!;
          return ListView.builder(
            itemCount: myTeams.length,
            itemBuilder: (context, index) {
              final team = myTeams[index];
              return GroupChatTile(
                  teamId: team.teamId,
                  teamName: team.name,
                  userName: 'Fix this later');
            },
          );
        }
      },
    );
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Teams Messages', style: TextStyle(color: Colors.white, fontSize: 27.0, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black87,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            icon: const Icon(Icons.search, color: Colors.white, size: 25.0), 
            onPressed: () {
              //Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchPage()));
            }
          )
        ],
      ),
      body: teamList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //_popupDialog(context);
        },
        backgroundColor: Colors.grey[700],
        elevation: 0.0,
        child: const Icon(Icons.add, color: Colors.white, size: 30.0),
      ),
    );
  }
}