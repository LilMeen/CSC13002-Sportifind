import 'package:sportifind/screens/player/team/models/team_information.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/screens/player/team/models/player_information.dart';

class TeamService {
  TeamInformation? teamInformation;
  PlayerInformation? playerInformation;
  bool isLoading = true;

  // get Team information from Database
  Future<TeamInformation> fetchTeamDetails(String teamId) async {
    TeamInformation? fetchedTeam = await getTeamInformation(teamId);
    if (fetchedTeam == null) {
      return TeamInformation
          .empty(); // Replace with the appropriate default value
    }

    isLoading = false;
    return fetchedTeam;
  }

  Future<TeamInformation?> getTeamInformation(String teamId) async {
    try {
      // Reference to the specific team document
      DocumentReference<Map<String, dynamic>> teamRef =
          FirebaseFirestore.instance.collection('teams').doc(teamId);

      // Get the document
      DocumentSnapshot<Map<String, dynamic>> teamSnapshot = await teamRef.get();

      // Check if the document exists
      if (teamSnapshot.exists) {
        // Use the fromSnapshot constructor to create a TeamInformation object
        TeamInformation teamInformation =
            TeamInformation.fromSnapshot(teamSnapshot);
        return teamInformation;
      } else {
        print('No such team document exists!');
        return null;
      }
    } catch (e) {
      print('Error getting team information: $e');
      return null;
    }
  }
}
