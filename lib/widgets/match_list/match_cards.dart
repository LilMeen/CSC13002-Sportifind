import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/models/location_info.dart';
import 'package:sportifind/models/player_data.dart';
import 'package:sportifind/models/stadium_data.dart';
import 'package:sportifind/util/location_service.dart';
import 'package:sportifind/util/match_service.dart';
import 'package:sportifind/widgets/match_list/match_list.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../models/match_card.dart';

// ignore: must_be_immutable
class MatchCards extends StatefulWidget {
  MatchCards({super.key, required this.yourMatch, required this.nearByMatch});

  List<MatchCard> yourMatch;
  List<MatchCard> nearByMatch;

  @override
  State<StatefulWidget> createState() => _MatchCardsState();
}

class _MatchCardsState extends State<MatchCards> {
  MatchService matchService = MatchService();
  LocationService locService = LocationService();
  List<StadiumData> stadiums = [];
  PlayerData? user;
  bool isLoadingStadiums = true;
  bool isLoadingUser = true;
  List<StadiumData> searchedStadiums = [];
  LocationInfo? currentLocation;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<List<List<MatchCard>>> _loadMatchData() async {
    final personalMatches = await matchService.getPersonalMatchData();
    final nearbyMatches = await matchService.getNearbyMatchData(searchedStadiums);
    print(nearbyMatches);
    return [personalMatches, nearbyMatches];
  }

  Widget buildMatch(double height, double width, List<MatchCard> matches) {
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
        print("Stadiums");
        print(searchedStadiums);
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to load data: $error';
      });
    }
  }

  Future<void> getStadiumsData() async {
    try {
      final stadiumsQuery =
          await FirebaseFirestore.instance.collection('stadiums').get();
      setState(() {
        stadiums = stadiumsQuery.docs
            .map((stadium) => StadiumData.fromSnapshot(stadium))
            .toList();
        isLoadingStadiums = false;
        searchedStadiums = stadiums;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to load stadiums data: $error';
        isLoadingStadiums = false;
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

  void sortNearbyStadiums() {
    if (currentLocation != null) {
      locService.sortByDistance<StadiumData>(
        searchedStadiums,
        currentLocation!,
        (stadium) => stadium.location,
      );
    }
  }

  int status = 0;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future: _loadMatchData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          widget.yourMatch = snapshot.data[0];
          widget.nearByMatch = snapshot.data[1];
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ToggleSwitch(
                    minWidth: 120.0,
                    minHeight: 50.0,
                    initialLabelIndex: status,
                    cornerRadius: 20.0,
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.grey,
                    inactiveFgColor: Colors.white,
                    totalSwitches: 2,
                    labels: const ['Your match', 'Nearby match'],
                    fontSize: 15.0,
                    activeBgColors: [
                      [Colors.green[800]!],
                      [Colors.red[800]!],
                    ],
                    animate:
                        true, // with just animate set to true, default curve = Curves.easeIn
                    curve: Curves
                        .bounceInOut, // animate must be set to true when using custom curve
                    onToggle: (index) {
                      setState(() {
                        status = index!;
                      });
                    },
                  ),
                ),
                status == 0
                    ? buildMatch(height, width, widget.yourMatch)
                    : buildMatch(height, width, widget.nearByMatch),
              ],
            ),
          );
        }
      },
    );
  }
}
