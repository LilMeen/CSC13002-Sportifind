// import 'package:flutter/material.dart';
// import 'package:sportifind/models/match_card.dart';
// import 'package:sportifind/models/sportifind_theme.dart';
// import 'package:sportifind/screens/player/match/screens/date_select_screen.dart';
// import 'package:sportifind/screens/player/match/screens/match_main_screen.dart';
// import 'package:sportifind/screens/player/match/util/pop_result.dart';
// import 'package:sportifind/screens/player/match/widgets/common_button.dart';
// import 'package:sportifind/screens/player/stadium/player_stadium_screen.dart';
// import 'package:sportifind/util/match_service.dart';

// class SelectStadiumScreen extends StatefulWidget {
//   const SelectStadiumScreen({
//     super.key,
//     required this.addMatchCard,
//   });

//   final void Function(MatchCard matchcard) addMatchCard;

//   @override
//   State<StatefulWidget> createState() => _SelectStadiumScreenState();
// }

// class _SelectStadiumScreenState extends State<SelectStadiumScreen> {
//   String? _selectedTeam;
//   String? _selectedStadiumName;
//   String? _selectedStadiumId;
//   int? _numberOfField;

//   Widget stadiumPicker(String title, String hintText, double height) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: SportifindTheme.display2,
//         ),
//         const SizedBox(
//           height: 20,
//         ),
//         Container(
//           padding: const EdgeInsets.only(left: 10.0),
//           height: height,
//           width: double.infinity,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(5),
//             color: SportifindTheme.nearlyGreen,
//           ),
//           child: TextButton(
//             onPressed: () async {
//               final result = await Navigator.push<PopWithResults>(
//                 context,
//                 MaterialPageRoute(
//                   settings: const RouteSettings(name: "Select_stadium"),
//                   builder: (context) => const PlayerStadiumScreen(
//                     forMatchCreate: true,
//                   ),
//                 ),
//               );

//               if (result != null) {
//                 setState(() {
//                   _selectedStadiumId = result.results![0];
//                   _selectedStadiumName = result.results![1];
//                   _numberOfField = int.parse(result.results![2]);
//                 });
//               }
//             },
//             child: _selectedStadiumName == null
//                 ? Text(
//                     hintText,
//                     style: SportifindTheme.title,
//                   )
//                 : Text(
//                     _selectedStadiumName!,
//                     style: SportifindTheme.title,
//                   ),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: SafeArea(
//         child: Scaffold(
//           appBar: AppBar(
//             backgroundColor: SportifindTheme.background,
//             leading: BackButton(
//               color: SportifindTheme.nearlyGreen,
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const MatchMainScreen()),
//                 );
//               },
//             ),
//             centerTitle: true,
//             title: const Text(
//               "Create match",
//               style: SportifindTheme.display1,
//             ),
//           ),
//           backgroundColor: SportifindTheme.background,
//           body: Padding(
//             padding: const EdgeInsets.only(
//                 left: 50.0, right: 50.0, bottom: 130, top: 50),
//             child: FutureBuilder<List<String>>(
//               future: _teamFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return const Center(child: Text('Error loading teams'));
//                 } else {
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       dropDownBox("Team", "Choose your team", 40,
//                           snapshot.data!, _selectedTeam, avatar[0]),
//                       const SizedBox(height: 40),
//                       stadiumPicker("Stadium", "Choose your stadium", 40),
//                       const SizedBox(
//                         height: 40,
//                       ),
//                       Expanded(
//                         child: Align(
//                           alignment: Alignment.bottomRight,
//                           child: CommonButton(
//                             text: 'Next',
//                             width: 100,
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => DateSelectScreen(
//                                     selectedTeam: _selectedTeam!,
//                                     selectedStadiumId: _selectedStadiumId!,
//                                     selectedStadiumName: _selectedStadiumName!,
//                                     numberOfField: _numberOfField!,
//                                     addMatchCard: widget.addMatchCard,
//                                   ),
//                                 ),
//                               );
//                             },
//                             isDisabled: (_selectedTeam == null),
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 }
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
