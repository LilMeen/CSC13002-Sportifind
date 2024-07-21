import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/models/owner_data.dart';
import 'package:sportifind/models/stadium_data.dart';
import 'package:sportifind/search/screens/stadium_search_screen.dart';

class StadiumScreen extends StatefulWidget {
  const StadiumScreen({super.key});

  @override
  State<StadiumScreen> createState() => _StadiumScreenState();
}

class _StadiumScreenState extends State<StadiumScreen> {
  List<StadiumData> stadiums = [];
  List<OwnerData> owners = [];
  late OwnerData user;

  final int gridCol = 1;
  final double gridRatio = 1.4;
  final double imageRatio = 2;
  bool isLoadingStadiums = true;
  bool isLoadingUser = true;
  String errorMessage = '';

  Future<void> getStadiumsData() async {
    try {
      final stadiumsQuery = await FirebaseFirestore.instance
          .collection('stadiums')
          .where('owner', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
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

  Future<void> getUserData() async {
    try {
      User? userFB = FirebaseAuth.instance.currentUser;
      if (userFB != null) {
        String uid = userFB.uid;
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        if (snapshot.exists) {
          setState(() {
            user = OwnerData.fromSnapshot(snapshot);
            isLoadingUser = false;
          });
        }
      }
      owners.add(user);
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
    getUserData();
  }

  Future<void> _refreshStadiums() async {
    setState(() {
      isLoadingStadiums = true;
      isLoadingUser = true;
      errorMessage = '';
    });
    await getStadiumsData();
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
        forStadiumCreate: true,
      ),
    );
  }
}
