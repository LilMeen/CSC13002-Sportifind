import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/core/util/team_util.dart';
import 'package:sportifind/features/profile/domain/entities/player_entity.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';
import 'package:sportifind/features/team/domain/usecases/get_team_by_player.dart';
import 'package:sportifind/features/team/presentation/widgets/team_list.dart';

class PlayerDetails extends StatefulWidget {
  const PlayerDetails({super.key, required this.user, required this.role});
  final PlayerEntity user;
  final String role;

  @override
  State<PlayerDetails> createState() => _PlayerDetailsState();
}

class _PlayerDetailsState extends State<PlayerDetails>
    with TickerProviderStateMixin {
  List<TeamEntity?> userTeams = [];
  bool isLoading = true;
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

  Future<void> _initialize() async {
    userTeams = await UseCaseProvider.getUseCase<GetTeamByPlayer>().call(
      GetTeamByPlayerParams(playerId: widget.user.id),
    ).then((value) => value.data!);
    setState(() {
      isLoading = false;
    });
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
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: const Size(200, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {},
                            child: widget.role == 'other'
                                ? Text(
                                    'Add',
                                    style: SportifindTheme.featureTitleBlack
                                        .copyWith(
                                      fontSize: 28,
                                      color: Colors.white,
                                    ),
                                  )
                                : const SizedBox(height: 15),
                          ),
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
