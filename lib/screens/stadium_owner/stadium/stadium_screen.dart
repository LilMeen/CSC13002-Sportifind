import 'package:flutter/material.dart';
import 'package:sportifind/models/owner_data.dart';
import 'package:sportifind/models/stadium_data.dart';
import 'package:sportifind/search/screens/stadium_search_screen.dart';
import 'package:sportifind/services/stadium_service.dart';
import 'package:sportifind/services/user_service.dart';

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
  
  final StadiumService stadService = StadiumService();
  final UserService userService = UserService();

  Future<void> fetchData() async {
    try {
      final stadiumsData = await stadService.getOwnerStadiumsData();
      final userData = await userService.getUserOwnerData();
      setState(() {
        stadiums = stadiumsData;
        user = userData;
        owners.add(user);
        isLoadingStadiums = false;
        isLoadingUser = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to load data: $error';
        isLoadingStadiums = false;
        isLoadingUser = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> _refreshStadiums() async {
    setState(() {
      isLoadingStadiums = true;
      isLoadingUser = true;
      errorMessage = '';
    });
    await fetchData();
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
