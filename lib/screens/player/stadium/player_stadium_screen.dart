import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/screens/search/stadium_search.dart';
import 'package:sportifind/widgets/card/stadium_card.dart';

class PlayerStadiumScreen extends StatelessWidget {
  const PlayerStadiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StadiumSearch(
      stream: FirebaseFirestore.instance.collection('stadiums').snapshots(),
      buildGridView: (stadiums) {
        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: stadiums.length,
          itemBuilder: (ctx, index) {
            final stadium = stadiums[index];
            final stadiumData = stadium.data() as Map<String, dynamic>;
            return StadiumCard(stadiumData: stadiumData);
          },
        );
      },
    );
  }
}