import 'package:flutter/material.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/models/owner_data.dart';
import 'package:sportifind/models/stadium_data.dart';
import 'package:sportifind/models/player_data.dart';
import 'package:sportifind/search/screens/stadium_search_screen.dart';
import 'package:sportifind/util/stadium_service.dart';
import 'package:sportifind/util/user_service.dart';

class PlayerStadiumScreen extends StatefulWidget {
  const PlayerStadiumScreen({
    super.key,
    this.forMatchCreate = false,
    this.selectedTeamId,
    this.selectedTeamName,
    this.selectedTeamAvatar,
    this.addMatchCard,
  });

  final bool forMatchCreate;
  final String? selectedTeamId;
  final String? selectedTeamName;
  final String? selectedTeamAvatar;
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

  final StadiumService stadService = StadiumService();
  final UserService userService = UserService();

  Future<void> fetchData() async {
    try {
      final stadiumsData = await stadService.getStadiumsData();
      final ownersData = await userService.getOwnersData();
      final userData = await userService.getUserPlayerData();
      setState(() {
        stadiums = stadiumsData;
        owners = ownersData;
        user = userData;
        isLoadingStadiums = false;
        isLoadingUser = false;
      });
    } catch (error) {
      errorMessage = 'Failed to load data: $error';
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> _refreshData() async {
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
      onRefresh: _refreshData,
      child: StadiumSearchScreen(
        userLocation: user.location,
        gridCol: gridCol,
        gridRatio: gridRatio,
        imageRatio: imageRatio,
        stadiums: stadiums,
        owners: owners,
        forMatchCreate: widget.forMatchCreate,
        addMatchCard: widget.addMatchCard,
        selectedTeamId: widget.selectedTeamId,
        selectedTeamName: widget.selectedTeamName,
        selectedTeamAvatar: widget.selectedTeamAvatar,
      ),
    );
  }
}
