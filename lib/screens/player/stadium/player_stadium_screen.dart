import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/models/owner_data.dart';
import 'package:sportifind/models/stadium_data.dart';
import 'package:sportifind/search/stadium_search_screen.dart';

// ignore: must_be_immutable
class PlayerStadiumScreen extends StatefulWidget {
  PlayerStadiumScreen({super.key, this.forMatchCreate});

  bool? forMatchCreate = false;

  @override
  State<PlayerStadiumScreen> createState() {
    return _PlayerStadiumScreenState();
  }
}

class _PlayerStadiumScreenState extends State<PlayerStadiumScreen> {
  List<StadiumData> stadiums = [];
  List<OwnerData> owners = [];

  final int gridCol = 2;
  final double gridRatio = 0.7;
  bool isLoading = true;
  String errorMessage = '';

  Future<void> getStadiumsData() async {
    try {
      final stadiumsQuery =
          await FirebaseFirestore.instance.collection('stadiums').get();
      setState(() {
        stadiums = stadiumsQuery.docs
            .map((stadium) => StadiumData.fromSnapshot(stadium))
            .toList();
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to load stadiums data: $error';
        isLoading = false;
      });
    }
  }

  Future<void> getOwnersData() async {
  final ownersQuery = await FirebaseFirestore.instance
      .collection('users')
      .where('role', isEqualTo: 'stadium_owner')
      .get();
  setState(() {
    owners = ownersQuery.docs
        .map((owner) => OwnerData.fromSnapshot(owner))
        .toList();
  });
}


  @override
  void initState() {
    super.initState();
    getStadiumsData();
    getOwnersData();
  }

  Future<void> _refreshStadiums() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    await getStadiumsData();
    await getOwnersData();
  }

  @override 
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Center(child: Text(errorMessage));
    }

    return RefreshIndicator(
      onRefresh: _refreshStadiums,
      child: StadiumSearchScreen(
        gridCol: gridCol,
        gridRatio: gridRatio,
        stadiums: stadiums,
        owners: owners,
        forMatchCreate: widget.forMatchCreate!,
      ),
    );
  }
}
