import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/models/owner_data.dart';
import 'package:sportifind/models/stadium_data.dart';
import 'package:sportifind/models/player_data.dart';
import 'package:sportifind/search/screens/stadium_search_screen.dart';

class PlayerStadiumScreen extends StatefulWidget {
  const PlayerStadiumScreen({
    super.key,
    this.forMatchCreate = false,
    this.selectedTeam,
    this.addMatchCard,
  });

  final bool forMatchCreate;
  final String? selectedTeam;
  final void Function(MatchCard matchcard)? addMatchCard;


  @override
  State<PlayerStadiumScreen> createState() => _PlayerStadiumScreenState();
}

class _PlayerStadiumScreenState extends State<PlayerStadiumScreen> {
  List<StadiumData> stadiums = [];
  List<OwnerData> owners = [];
  late PlayerData user;

  final int gridCol = 2;
  final double gridRatio = 0.7;
  final double imageRatio = 1;
  bool isLoadingStadiums = true;
  bool isLoadingUser = true;
  String errorMessage = '';

  Future<void> getStadiumsData() async {
    try {
      final stadiumsQuery =
          await FirebaseFirestore.instance.collection('stadiums').get();
      setState(() {
        stadiums = stadiumsQuery.docs
            .map((stadium) => StadiumData.fromSnapshot(stadium))
            .toList();
        isLoadingStadiums = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to load stadiums data: $error';
        isLoadingStadiums = false;
      });
    }
  }

  Future<void> getOwnersData() async {
    try {
      final ownersQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'stadium_owner')
          .get();
      setState(() {
        owners = ownersQuery.docs
            .map((owner) => OwnerData.fromSnapshot(owner))
            .toList();
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to load owners data: $error';
      });
    }
  }

  Future<void> getUserData() async {
    try {
      User? userFB = FirebaseAuth.instance.currentUser;
      if (userFB != null) {
        String uid = userFB.uid;
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        if (snapshot.exists) {
          setState(() {
            user = PlayerData.fromSnapshot(snapshot);
            isLoadingUser = false;
          });
        }
      }
    } catch (error) {
      setState(() {
        isLoadingUser = false;
        errorMessage = 'Failed to load user data: $error';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getStadiumsData();
    getOwnersData();
    getUserData();
  }

  Future<void> _refreshStadiums() async {
    setState(() {
      isLoadingStadiums = true;
      isLoadingUser = true;
      errorMessage = '';
    });
    await getStadiumsData();
    await getOwnersData();
    await getUserData();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingStadiums || isLoadingUser) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Center(child: Text(errorMessage));
    }

    return RefreshIndicator(
      onRefresh: _refreshStadiums,
      child: StadiumSearchScreen(
        userLocation: user.location,
        gridCol: gridCol,
        gridRatio: gridRatio,
        imageRatio: imageRatio,
        stadiums: stadiums,
        owners: owners,
        forMatchCreate: widget.forMatchCreate,
        addMatchCard: widget.addMatchCard,
        selectedTeam: widget.selectedTeam,
      ),
    );
  }
}
