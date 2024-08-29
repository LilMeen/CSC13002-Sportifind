import 'package:flutter/material.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/features/profile/domain/entities/player_entity.dart';
import 'package:sportifind/features/profile/domain/usecases/get_all_player.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/features/team/presentation/screens/player_details.dart';

class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen({super.key});

  @override
  State<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  List<PlayerEntity> playersInformation = [];
  List<PlayerEntity> _foundedPlayers = [];
  bool isLoading = true;
  late Future<void> initializationFuture;

  @override
  void initState() {
    super.initState();
    initializationFuture = _initialize();
  }

  Future<void> _initialize() async {
    List<PlayerEntity> fetchedInformation =
        await UseCaseProvider.getUseCase<GetAllPlayer>()
            .call(NoParams())
            .then((value) => value.data!);

    setState(() {
      playersInformation = fetchedInformation;
      isLoading = false;
    });
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<PlayerEntity> results = [];
    if (enteredKeyword.isEmpty) {
      // If the search field is empty or only contains white-space, display all users
      results = playersInformation;
    } else {
      results = playersInformation
          .where(
            (team) => team.name.toLowerCase().contains(
                  enteredKeyword.toLowerCase(),
                ),
          )
          .toList();
    }

    // Refresh the UI with the new results
    setState(() {
      _foundedPlayers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Search for players',
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
              child: _foundedPlayers.isNotEmpty
                  ? ListView.builder(
                      itemCount: _foundedPlayers.length,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          // Navigate to the team details screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlayerDetails(
                                user: _foundedPlayers[index],
                              ),
                            ),
                          );
                        },
                        child: Card(
                          key: ValueKey(_foundedPlayers[index].id),
                          color: Colors.white,
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                _foundedPlayers[index].avatar.path,
                              ),
                            ),
                            title: Text(
                              _foundedPlayers[index].name,
                              style: SportifindTheme.normalTextBlack
                                  .copyWith(color: Colors.black),
                            ),
                            subtitle: Text(
                              // Display the user's address
                              '${_foundedPlayers[index].location.address}, ${_foundedPlayers[index].location.district}, ${_foundedPlayers[index].location.city}',
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
