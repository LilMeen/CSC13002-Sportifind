import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/core/util/team_util.dart';
import 'package:sportifind/features/profile/domain/entities/player_entity.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';
import 'package:sportifind/features/team/domain/usecases/get_team_by_player.dart';
import 'package:sportifind/features/team/presentation/widgets/team/team_add_dialog.dart';
import 'package:sportifind/features/team/presentation/widgets/team_list.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PlayerDetails extends StatefulWidget {
  const PlayerDetails({super.key, required this.user});
  final PlayerEntity user;
  @override
  State<PlayerDetails> createState() => _PlayerDetailsState();
}

class _PlayerDetailsState extends State<PlayerDetails>
    with TickerProviderStateMixin {
  List<TeamEntity?> userTeams = [];
  List<TeamEntity?> viewerTeams = [];
  bool isLoading = true;
  String role = '';
  late AnimationController animationController;
  late Future<void> _initializationFuture;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _initializationFuture = _initialize();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void whoIsViewing() {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    if (currentUserId == widget.user.id) {
      role = 'myself';
    } else {
      role = 'other';
    }
  }

  Future<void> _initialize() async {
    whoIsViewing();
    userTeams = await UseCaseProvider.getUseCase<GetTeamByPlayer>()
        .call(
          GetTeamByPlayerParams(playerId: widget.user.id),
        )
        .then((value) => value.data!);
    viewerTeams = await UseCaseProvider.getUseCase<GetTeamByPlayer>()
        .call(
          GetTeamByPlayerParams(
              playerId: FirebaseAuth.instance.currentUser!.uid),
        )
        .then((value) => value.data!);
    setState(() {
      isLoading = false;
    });
  }

  int get age {
    String dob = widget.user.dob;
    // dd/mm/yyyy get month,day, year and calculate age
    int year = int.parse(dob.substring(6, 10));
    int month = int.parse(dob.substring(3, 5));
    int day = int.parse(dob.substring(0, 2));
    DateTime now = DateTime.now();
    int age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }

  double get overallStat {
    double overall = (widget.user.stats.def +
            widget.user.stats.pace +
            widget.user.stats.pass +
            widget.user.stats.physic +
            widget.user.stats.shoot +
            widget.user.stats.drive) /
        6;
    return overall;
  }

  @override
  Widget build(context) {
    return FutureBuilder<void>(
      future: _initializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error loading data"));
        } else {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                'Player information',
                style: SportifindTheme.sportifindAppBarForFeature.copyWith(
                  fontSize: 28,
                  color: SportifindTheme.bluePurple,
                ),
                textAlign: TextAlign.center,
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
                child: Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                        child: SizedBox(
                          height: 100,
                          width: 300,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    NetworkImage(widget.user.avatar.path),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.user.name,
                                        style: SportifindTheme
                                            .sportifindAppBarForFeature
                                            .copyWith(
                                          fontSize: 25,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Overall Stat ',
                                        style: SportifindTheme.normalTextWhite
                                            .copyWith(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        '80', //  waiting for stat for player
                                        style: SportifindTheme.normalTextBlack
                                            .copyWith(
                                          fontSize: 16,
                                          color: SportifindTheme.bluePurple,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Age     ',
                                        style: SportifindTheme.normalTextWhite
                                            .copyWith(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        '${getUserAge(widget.user.dob)}',
                                        style: SportifindTheme.normalTextWhite
                                            .copyWith(
                                          fontSize: 16,
                                          color: SportifindTheme.bluePurple,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 8, bottom: 8, left: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Details',
                              style: SportifindTheme.normalTextBlack.copyWith(
                                fontSize: 24,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${widget.user.location.address}, ${widget.user.location.district}, ${widget.user.location.city}',
                                  style:
                                      SportifindTheme.normalTextWhite.copyWith(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '180', // height here
                                  style:
                                      SportifindTheme.normalTextWhite.copyWith(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Joined Teams',
                          style: SportifindTheme.normalTextBlack.copyWith(
                            fontSize: 24,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      TeamList(teams: userTeams),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TeamListDialog(viewerTeams: viewerTeams, player: widget.user),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
