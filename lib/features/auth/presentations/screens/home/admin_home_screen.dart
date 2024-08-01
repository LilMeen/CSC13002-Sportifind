import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:sportifind/search/widgets/custom_search_bar.dart';
import 'package:sportifind/services/search_service.dart';

class AdminHomeScreen extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const AdminHomeScreen());
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  final List<String> _searchFields = ['email', 'role'];
  SearchService srchService = SearchService();

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
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchText = _searchController.text;
      });
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
              final filteredUsers = srchService.searchAndSortDocuments(users, _searchText, _searchFields);

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