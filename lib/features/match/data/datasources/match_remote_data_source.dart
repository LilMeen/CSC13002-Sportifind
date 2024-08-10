import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/features/match/data/models/match_model.dart';

abstract interface class MatchRemoteDataSource {
  Future<MatchModel> getMatch(String id);
}

class MatchRemoteDataSourceImpl implements MatchRemoteDataSource {

  /// GET MATCH
  /// Get match by id
  @override
  Future<MatchModel> getMatch(String id) async {
    final matchDoc = await FirebaseFirestore.instance.collection('matches').doc(id).get();
    return MatchModel.fromFirestore(matchDoc);
  }
}