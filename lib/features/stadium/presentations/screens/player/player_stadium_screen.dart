import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/features/match/domain/entities/match_entity.dart';
import 'package:sportifind/features/profile/domain/entities/player_entity.dart';
import 'package:sportifind/features/profile/domain/entities/stadium_owner_entity.dart';
import 'package:sportifind/features/profile/domain/usecases/get_all_stadium_owner.dart';
import 'package:sportifind/features/profile/domain/usecases/get_player.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium_entity.dart';
import 'package:sportifind/features/stadium/domain/usecases/get_all_stadiums.dart';
import 'package:sportifind/features/stadium/presentations/screens/stadium_search_screen.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';

class PlayerStadiumScreen extends StatefulWidget {
  const PlayerStadiumScreen({
    super.key,
    this.forMatchCreate = false,
    this.selectedTeam,
    this.addMatchCard,
  });

  final bool forMatchCreate;
  final TeamEntity? selectedTeam;
  final void Function(MatchEntity matchcard)? addMatchCard;

  @override
  State<PlayerStadiumScreen> createState() => _PlayerStadiumScreenState();
}

class _PlayerStadiumScreenState extends State<PlayerStadiumScreen> {
  List<StadiumEntity> stadiums = [];
  List<StadiumOwnerEntity> owners = [];
  late PlayerEntity user;

  bool isLoadingStadiums = true;
  bool isLoadingUser = true;
  String errorMessage = '';

  Future<void> fetchData() async {
    try {
      final stadiumsData = await UseCaseProvider.getUseCase<GetAllStadiums>().call(NoParams()).then((value) => value.data);
      final ownersData =  await UseCaseProvider.getUseCase<GetAllStadiumOwner>().call(NoParams()).then((value) => value.data);
      final userData = await UseCaseProvider
        .getUseCase<GetPlayer>()
        .call(GetPlayerParams(id: FirebaseAuth.instance.currentUser!.uid))
        .then((value) => value.data);

      setState(() {
        stadiums = stadiumsData ?? [];
        owners = ownersData ?? [];
        user = userData!;
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
        stadiums: stadiums,
        owners: owners,
        forMatchCreate: widget.forMatchCreate,
        addMatchCard: widget.addMatchCard,
        selectedTeam: widget.selectedTeam,
      ),
    );
  }
}
