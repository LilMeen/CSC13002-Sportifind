import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/models/location_info.dart';
import 'package:sportifind/models/player_data.dart';
import 'package:sportifind/models/stadium_data.dart';
import 'package:sportifind/util/location_service.dart';
import 'package:sportifind/util/match_service.dart';
import 'package:sportifind/widgets/match_list/match_list.dart';
import '../../models/match_card.dart';

class MatchCards extends StatefulWidget {
  MatchCards({
    super.key,
    required this.yourMatch,
    required this.nearByMatch,
    required this.status,
  });

  List<MatchCard> yourMatch;
  List<MatchCard> nearByMatch;
  int status;

  @override
  State<StatefulWidget> createState() => _MatchCardsState();
}

class _MatchCardsState extends State<MatchCards> {
  MatchService matchService = MatchService();
  LocationService locService = LocationService();
  List<StadiumData> stadiums = [];
  PlayerData? user;
  bool isLoadingUser = true;
  List<StadiumData> searchedStadiums = [];
  LocationInfo? currentLocation;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void didUpdateWidget(covariant MatchCards oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.status != widget.status || oldWidget.status == widget.status) {
      _refreshData();
    }
  }

  Future<void> _loadMatchData() async {
    final personalMatches = await matchService.getPersonalMatchData();
    final nearbyMatches =
        await matchService.getNearbyMatchData(searchedStadiums);
    setState(() {
      widget.yourMatch = personalMatches;
      widget.nearByMatch = nearbyMatches;
    });
  }

  Widget buildMatch(List<MatchCard> matches) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: height - 150,
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: MatchCardList(matches: matches),
      ),
    );
  }

  Future<void> fetchData() async {
    try {
      await getStadiumsData();
      await getUserData();
      if (user != null) {
        currentLocation = user!.location;
        sortNearbyStadiums();
      }
      _loadMatchData();
    } catch (error) {
      print('Failed to load data: $error');
    }
  }

  Future<void> getStadiumsData() async {
    try {
      final stadiumsQuery =
          await FirebaseFirestore.instance.collection('stadiums').get();
      stadiums = stadiumsQuery.docs
          .map((stadium) => StadiumData.fromSnapshot(stadium))
          .toList();
      searchedStadiums = stadiums;
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to load stadiums data: $error';
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
          user = PlayerData.fromSnapshot(snapshot);
        }
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to load user data: $error';
      });
    }
  }

  void sortNearbyStadiums() {
    if (currentLocation != null) {
      locService.sortByDistance<StadiumData>(
        searchedStadiums,
        currentLocation!,
        (stadium) => stadium.location,
      );
    }
  }

  Future<void> _refreshData() async {
    await _loadMatchData();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: widget.status == 0
          ? buildMatch(widget.yourMatch)
          : buildMatch(widget.nearByMatch),
    );
  }
}
