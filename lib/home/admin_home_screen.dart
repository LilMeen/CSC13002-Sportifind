// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/core/util/search_util.dart';
import 'package:sportifind/features/stadium/presentations/widgets/custom_search_bar.dart';
import 'package:sportifind/features/user/domain/entities/user_entity.dart';
import 'package:sportifind/features/user/domain/usecases/delete_user.dart';
import 'package:sportifind/features/user/domain/usecases/get_user.dart';
import 'package:sportifind/features/user/presentation/screens/view_report_list.dart';
import 'dart:async';
import 'package:toggle_switch/toggle_switch.dart';

class AdminHomeScreen extends StatefulWidget {
  static route() {
    return MaterialPageRoute(builder: (context) => const AdminHomeScreen());
  }

  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  final List<String> _searchFields = ['email', 'role'];
  int status = 0; // 0 for Users, 1 for Reports

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
        title: Text('Are you sure?', style: SportifindTheme.normalTextBlack),
        content: Text('Do you want to delete this user?', style: SportifindTheme.normalTextBlack),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              UserEntity userEntity = await UseCaseProvider.getUseCase<GetUser>().call(
                GetUserParams(id: user.id),
              ).then((value) => value.data!);
              await UseCaseProvider.getUseCase<DeleteUser>().call(
                DeleteUserParams(user: userEntity),
              );
              Navigator.of(ctx).pop();
            },
            child: Text('Yes', style: SportifindTheme.normalTextBlack),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Home', style: SportifindTheme.sportifindFeatureAppBarBluePurple),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Column(
            children: [
              ToggleSwitch(
                minWidth: width - 80,
                minHeight: 50.0,
                initialLabelIndex: status,
                cornerRadius: 8.0,
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey.shade300,
                inactiveFgColor: Colors.black,
                totalSwitches: 2,
                radiusStyle: true,
                labels: const ['Users', 'Reports'],
                fontSize: 20.0,
                activeBgColors: const [
                  [Color.fromARGB(255, 76, 59, 207)],
                  [Color.fromARGB(255, 76, 59, 207)],
                ],
                animate: true,
                curve: Curves.fastOutSlowIn,
                onToggle: (index) {
                  setState(() {
                    status = index!;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0), // Add padding to avoid overflow
            child: Column(
              children: [
                if (status == 0) ...[
                  CustomSearchBar(
                    searchController: _searchController,
                    hintText: 'Search by email or role',
                  ),
                  const SizedBox(height: 8.0), // Space between search bar and list
                ],
                Expanded(
                  child: status == 0
                      ? StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('users').snapshots(),
                          builder: (ctx, userSnapshot) {
                            if (userSnapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (userSnapshot.hasError) {
                              return AlertDialog(
                                title: Text('Error', style: SportifindTheme.normalTextBlack),
                                content: Text('An error occurred while fetching data.', style: SportifindTheme.normalTextBlack),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('OK', style: SportifindTheme.normalTextBlack),
                                  ),
                                ],
                              );
                            }

                            final users = userSnapshot.data!.docs;
                            final filteredUsers = searchAndSortDocuments(
                              users,
                              _searchText,
                              _searchFields,
                            );

                            if (filteredUsers.isEmpty) {
                              return Center(child: Text('No users found.', style: SportifindTheme.normalTextBlack));
                            }

                            return ListView.builder(
                              itemCount: filteredUsers.length,
                              itemBuilder: (ctx, index) => Card(
                                elevation: 4,
                                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: Icon(Icons.person),
                                  ),
                                  title: Text(filteredUsers[index]['email'], style: SportifindTheme.normalTextBlack),
                                  subtitle: Text(filteredUsers[index]['role'], style: SportifindTheme.normalTextBlack),
                                  onTap: () => _showDeleteDialog(ctx, filteredUsers[index]),
                                ),
                              ),
                            );
                          },
                        )
                      : const ViewReportList(), // Show ViewReportsList when Reports is selected
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
