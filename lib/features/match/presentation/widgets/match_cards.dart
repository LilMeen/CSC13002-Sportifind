import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/features/match/domain/entities/match_entity.dart';
import 'package:sportifind/features/match/domain/usecases/get_all_match.dart';
import 'package:sportifind/features/match/domain/usecases/get_nearby_match.dart';
import 'package:sportifind/features/match/domain/usecases/get_personal_match.dart';
import 'package:sportifind/features/match/presentation/widgets/match_list.dart';
import 'package:sportifind/features/profile/domain/usecases/get_player.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium_entity.dart';

// ignore: must_be_immutable
class MatchCards extends StatefulWidget {
  MatchCards({
    super.key,
    required this.yourMatch,
    required this.nearByMatch,
    required this.status,
  });

  List<MatchEntity> yourMatch;
  List<MatchEntity> nearByMatch;
  final int status;

  @override
  State<StatefulWidget> createState() => _MatchCardsState();
}

class _MatchCardsState extends State<MatchCards> {
  bool isLoadingUser = true;
  List<StadiumEntity> searchedStadiums = [];
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MatchCards oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.status != widget.status ||
        oldWidget.status == widget.status) {
      _refreshData();
    }
  }

  Future<void> _loadMatchData() async {
    final user = await UseCaseProvider.getUseCase<GetPlayer>()
        .call(GetPlayerParams(
          id: FirebaseAuth.instance.currentUser!.uid,
        ))
        .then((value) => value.data!);
    final allMatches = await UseCaseProvider.getUseCase<GetAllMatch>()
        .call(NoParams())
        .then((value) => value.data!);
    final personalMatches = await UseCaseProvider.getUseCase<GetPersonalMatch>()
        .call(NoParams())
        .then((value) => value.data!);
    var nearbyMatches = NonFutureUseCaseProvider.getUseCase<GetNearbyMatch>()
        .call(GetNearbyMatchParams(
          allMatches,
          user.location,
        ))
        .data!;
    
    for (var i = 0; i < nearbyMatches.length; ++i) {
      for (var j = 0; j < personalMatches.length; ++j) {
        if (nearbyMatches[i].id == personalMatches[j].id) {
          nearbyMatches.removeAt(i);
          nearbyMatches.length--;
        }
      }
    }
    print(nearbyMatches);

    setState(() {
      widget.yourMatch = personalMatches;
      widget.nearByMatch = nearbyMatches;
      isLoadingUser = false;
    });
  }

  Widget buildMatch(List<MatchEntity> matches) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: height - 150,
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: MatchCardList(
          matches: matches,
          status: widget.status,
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoadingUser = true;
      errorMessage = '';
    });
    await _loadMatchData();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingUser) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: widget.status == 0
          ? buildMatch(widget.yourMatch)
          : buildMatch(widget.nearByMatch),
    );
  }
}
