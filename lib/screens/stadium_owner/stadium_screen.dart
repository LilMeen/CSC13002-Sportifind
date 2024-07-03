/*
import 'package:flutter/material.dart';
import 'package:sportifind/screens/stadium_owner/create_stadium.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StadiumScreen extends StatefulWidget {
  const StadiumScreen({super.key});

  @override
  State<StadiumScreen> createState() {
    return _StadiumScreenState();
  }
}

class _StadiumScreenState extends State<StadiumScreen> {

  @override
  Widget build (context){
    return  Scaffold(
      appBar: AppBar (
        title: const Text('Stadium management')
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
          .collection('stadiums')
          .where('owner', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> stadiumSnapshot) {
          if (stadiumSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final stadiums = stadiumSnapshot.data!.docs;
          return ListView.builder(
            itemCount: stadiums.length,
            itemBuilder: (ctx, index) => Card(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: ListTile(
                leading: Container (
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration (
                    shape: BoxShape.circle,
                    border: Border.all (color: Colors.black),
                  ),
                  child: const Icon(Icons.person),
                ),
                title: Text(stadiums[index]['name']),
                subtitle: Text('${stadiums[index]['address']}, ${stadiums[index]['district']}, ${stadiums[index]['city']}'),
              ),
            ),
          );
        },
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateStadium()),
          );
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(15),
        ), 
        child: Icon(Icons.add, color: Colors.amber[800], size: 30),
      ),  
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sportifind/search/stadium_search.dart';
import 'package:sportifind/widgets/card/stadium_card.dart';
import 'package:sportifind/screens/stadium_owner/create_stadium.dart';

class StadiumScreen extends StatelessWidget {
  const StadiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StadiumSearch(
        stream: FirebaseFirestore.instance
            .collection('stadiums')
            .where('owner', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        buildGridView: (stadiums) {
          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 1.4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: stadiums.length,
            itemBuilder: (ctx, index) {
              final stadium = stadiums[index];
              final stadiumData = stadium.data() as Map<String, dynamic>;
              return StadiumCard(stadiumData: stadiumData, imageRatio: 2);
            },
          );
        },
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateStadium()),
          );
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(15),
        ),
        child: Icon(Icons.add, color: Colors.amber[800], size: 30),
      ),
    );
  }
}
