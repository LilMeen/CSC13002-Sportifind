import 'package:flutter/material.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';
import 'package:sportifind/features/team/domain/usecases/get_all_team.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/features/team/presentation/screens/team_details.dart';

class TeamSearchScreen extends StatefulWidget {
  const TeamSearchScreen({super.key});

  @override
  State<TeamSearchScreen> createState() => _TeamSearchScreenState();
}

class _TeamSearchScreenState extends State<TeamSearchScreen> {
  List<TeamEntity> teamsInformation = [];
  List<TeamEntity> _foundedTeams = [];
  bool isLoading = true;
  late Future<void> initializationFuture;

  @override
  void initState() {
    super.initState();
    initializationFuture = _initialize();
  }

  Future<void> _initialize() async {
    List<TeamEntity> fetchedInformation =
        await UseCaseProvider.getUseCase<GetAllTeam>()
            .call(NoParams())
            .then((value) => value.data!);

    setState(() {
      teamsInformation = fetchedInformation;
      isLoading = false;
    });
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<TeamEntity> results = [];
    if (enteredKeyword.isEmpty) {
      // If the search field is empty or only contains white-space, display all users
      results = teamsInformation;
    } else {
      results = teamsInformation
          .where(
            (team) => team.name.toLowerCase().contains(
                  enteredKeyword.toLowerCase(),
                ),
          )
          .toList();
    }

    // Refresh the UI with the new results
    setState(() {
      _foundedTeams = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SportifindTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Search for team',
          style: SportifindTheme.sportifindAppBarForFeature.copyWith(
            fontSize: 28,
            color: SportifindTheme.bluePurple,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: SportifindTheme.bluePurple),
        elevation: 0,
        surfaceTintColor: SportifindTheme.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.all(Radius.circular(13.0)),
              ),
              child: TextField(
                onChanged: (value) => _runFilter(value),
                decoration: const InputDecoration(
                  labelText: 'Search',
                  suffixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: _foundedTeams.isNotEmpty
                  ? ListView.builder(
                      itemCount: _foundedTeams.length,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          // Navigate to the team details screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TeamDetails(
                                teamId: _foundedTeams[index].id,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          key: ValueKey(_foundedTeams[index].id),
                          color: Colors.white,
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                _foundedTeams[index].avatar.path,
                              ),
                            ),
                            title: Text(
                              _foundedTeams[index].name,
                              style: SportifindTheme.normalTextBlack
                                  .copyWith(color: Colors.black),
                            ),
                            subtitle: Text(
                              '${teamsInformation[index].players.length} members',
                              style: SportifindTheme.normalTextBlack
                                  .copyWith(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Text(
                      'No results found',
                      style: SportifindTheme.normalTextBlack
                          .copyWith(fontSize: 18, color: Colors.grey),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
