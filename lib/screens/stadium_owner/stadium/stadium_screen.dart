import 'package:flutter/material.dart';
import 'package:sportifind/models/owner_data.dart';
import 'package:sportifind/models/stadium_data.dart';
import 'package:sportifind/search/screens/stadium_search_screen.dart';
import 'package:sportifind/util/stadium_service.dart';
import 'package:sportifind/util/user_service.dart';

class OwnerStadiumScreen extends StatefulWidget {
  const OwnerStadiumScreen({super.key});

  @override
  State<OwnerStadiumScreen> createState() => _OwnerStadiumScreenState();
}

class _OwnerStadiumScreenState extends State<OwnerStadiumScreen> {
  List<StadiumData> stadiums = [];
  List<OwnerData> owners = [];
  late OwnerData user;

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
        stadiums: stadiums,
        owners: owners,
        isStadiumOwnerUser: true,
      ),
    );
  }
}
