import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/features/auth/presentations/bloc/auth_bloc.dart';

class RoleScreen extends StatefulWidget {
  static route () =>
    MaterialPageRoute(builder: (context) => const RoleScreen());
  const RoleScreen ({super.key});

  @override 
  State<RoleScreen> createState(){
    return _RoleScreenState();
  }
}

class _RoleScreenState extends State<RoleScreen> {
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Text(
                "What's your role?",
                style:
                    SportifindTheme.normalTextBlackW700.copyWith(fontSize: 32),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                "Please select your role to continue",
                style: SportifindTheme.normalTextBlack,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildRoleCard(
                    title: "Stadium owner",
                    icon: Icons.stadium,
                    isSelected: selectedRole == "stadium_owner",
                    onTap: () => _toggleRole("stadium_owner"),
                  ),
                  const SizedBox(height: 20),
                  _buildRoleCard(
                    title: "Player",
                    icon: Icons.sports_soccer,
                    isSelected: selectedRole == "player",
                    onTap: () => _toggleRole("player"),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  await AuthBloc(context).setRole(selectedRole!);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: SportifindTheme.bluePurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                child: Text(
                  "Continue",
                  style: SportifindTheme.normalTextWhite.copyWith(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 240, 
        height: 165,
        child: Card(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color:
                  isSelected ? SportifindTheme.bluePurple : Colors.grey,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.rowdies(
                    fontSize: 24,
                    color:
                        isSelected ? SportifindTheme.bluePurple : Colors.grey,
                  ),
                ),
                const SizedBox(height: 5),
                Divider(color: isSelected ? SportifindTheme.bluePurple : Colors.grey),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: title == 'Stadium owner'
                    ? Icon(
                        icon,
                        size: 50,
                        color: isSelected ? SportifindTheme.bluePurple : Colors.grey,
                      )
                    : Image.asset(
                        isSelected ? 'lib/assets/player_picked.png' : 'lib/assets/player_unpicked.png',
                        width: 70,
                        height: 55,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toggleRole(String role) {
    setState(() {
      if (selectedRole == role) {
        selectedRole = null;
      } else {
        selectedRole = role;
      }
    });
  }
}
