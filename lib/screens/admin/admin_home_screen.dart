import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() {
    return _AdminHomeScreenState();
  }
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar (
        title: const Text('User list')
      ),
      body: SafeArea (
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (ctx, AsyncSnapshot<QuerySnapshot> userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final users = userSnapshot.data!.docs;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (ctx, index) => Card(
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
                  title: Text(users[index]['email']),
                  subtitle: Text(users[index]['role']),
                  onTap: () {
                    //delete user
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Are you sure?'),
                        content: const Text('Do you want to delete this user?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              //AuthService().deleteUser(users[index]['email'], users[index]['password']);
                              Navigator.of(ctx).pop();
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                
              ),
            );
          },
        ) 
      )
    );
  }
}