import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminHomeScreen extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const AdminHomeScreen());
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {

  void _showDeleteDialog(BuildContext context, DocumentSnapshot user) {
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
              FirebaseFirestore.instance.collection('users').doc(user.id).delete();
              Navigator.of(ctx).pop();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User list'),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (ctx, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (userSnapshot.hasError) {
                return AlertDialog(
                    title: const Text('Delete complete'),
                    content: const Text('Press continue to return to the user list.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminHomeScreen()));
                        },
                        child: const Text('Continue'),
                      ),
                    ],
                  ); 
                //return Center(child: Text('Error: ${userSnapshot.error}'));
              } 
              final users = userSnapshot.data!.docs;

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (ctx, index) => Card(
                  elevation: 4,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Icon(Icons.person),
                    ),
                    title: Text(users[index]['email']),
                    subtitle: Text(users[index]['role']),
                    onTap: () => _showDeleteDialog(ctx, users[index]),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
