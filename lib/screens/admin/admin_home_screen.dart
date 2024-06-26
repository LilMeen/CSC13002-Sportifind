import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/screens/search.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  final List<String> _searchFields = ['email', 'role'];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchText = _searchController.text;
    });
  }

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
              // Implement user deletion logic here
              // AuthService().deleteUser(documents[index]['email'], documents[index]['password']);
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomSearchBar(
              searchController: _searchController,
              hintText: 'Search by email or role',
            ),
          ),
        ),
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
                return Center(child: Text('Error: ${userSnapshot.error}'));
              }

              final users = userSnapshot.data!.docs;
              final filteredUsers = searchAndSortDocuments(users, _searchText, _searchFields);

              if (filteredUsers.isEmpty) {
                return const Center(child: Text('No users found.'));
              }

              return ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (ctx, index) => Card(
                  elevation: 4,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Icon(Icons.person),
                    ),
                    title: Text(filteredUsers[index]['email']),
                    subtitle: Text(filteredUsers[index]['role']),
                    onTap: () => _showDeleteDialog(ctx, filteredUsers[index]),
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
