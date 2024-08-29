import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/features/profile/domain/entities/player_entity.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';
import 'package:sportifind/features/team/domain/usecases/get_team_by_player.dart';
import 'package:sportifind/features/team/presentation/screens/team_add_list.dart';
import 'package:sportifind/features/team/presentation/widgets/team_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sportifind/features/user/presentation/screens/report_form.dart';

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

  Future<void> _initialize() async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    if (currentUserId == widget.user.id) {
      role = 'myself';
    } else {
      role = 'other';
    }
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
    List<String> parts = widget.user.dob.split('/');

    // Parse day, month, and year as integers
    int day = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int year = int.parse(parts[2]);
    // Get the current date
    DateTime today = DateTime.now();

    // Calculate the age
    int age = today.year - year;

    // Adjust the age if the birthday hasn't occurred yet this year
    if (today.month < month || (today.month == month && today.day < day)) {
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
              actions: role == 'other'
                  ? <Widget>[
                      IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {
                          _showCustomDialog(context);
                        },
                      )
                    ]
                  : null,
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
                                        overallStat == 0
                                            ? 'unknow'
                                            : overallStat.toStringAsFixed(2),
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
                                        '$age',
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
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 16,
                                  child: Icon(
                                    Icons.directions_run_sharp,
                                    color: SportifindTheme.bluePurple,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  widget.user.preferredFoot == ''
                                      ? 'unknow'
                                      : widget
                                          .user.preferredFoot, // height here
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
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 16,
                                  child: Icon(
                                    Icons.location_on,
                                    color: SportifindTheme.bluePurple,
                                  ),
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
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 16,
                                  child: Icon(
                                    Icons.height,
                                    color: SportifindTheme.bluePurple,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  widget.user.height == ''
                                      ? 'unknow'
                                      : widget.user.height, // height here
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
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 16,
                                  child: Icon(
                                    Icons.scale,
                                    color: SportifindTheme.bluePurple,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  widget.user.weight == ''
                                      ? 'unknow'
                                      : widget.user.weight, // height here
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
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddToTeamList(
                                    player: widget.user,
                                    viewerTeams: viewerTeams,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: const Size(200, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              'Add',
                              style: SportifindTheme.featureTitleBlack.copyWith(
                                fontSize: 28,
                                color: Colors.white,
                              ),
                            ),
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

  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(color: SportifindTheme.bluePurple, width: 2.0),
          ),
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              'Choose an Option',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: SportifindTheme.bluePurple,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              role == 'other'
                  ? Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.withOpacity(0.5),
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.bug_report_outlined,
                            color: SportifindTheme.bluePurple),
                        title: Text(
                          'Report',
                          style: SportifindTheme.normalTextBlack.copyWith(
                            fontSize: 16,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => ReportDialog(
                                reportedUserId: widget.user.id,
                              ),
                            ),
                          );
                          // Handle the edit action
                          //Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Moving to Edit Team'),
                            ),
                          );
                        },
                      ),
                    )
                  : const SizedBox(
                      height: 0,
                      width: 0,
                    ),
            ],
          ),
        );
      },
    );
  }
}
