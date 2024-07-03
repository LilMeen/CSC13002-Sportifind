import 'package:flutter/material.dart';
import 'package:sportifind/screens/stadium_owner/stadium/create_stadium.dart';
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