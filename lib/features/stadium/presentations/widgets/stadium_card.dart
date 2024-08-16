import 'package:flutter/material.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium_entity.dart';
import 'package:sportifind/features/stadium/presentations/screens/stadium_info_screen.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';

class StadiumCard extends StatefulWidget {
  final StadiumEntity stadium;
  final String ownerName;
  final double imageRatio;
  final bool isStadiumOwnerUser;
  final bool forMatchCreate;
  final TeamEntity? selectedTeam;

  const StadiumCard({
    required this.stadium,
    required this.ownerName,
    required this.isStadiumOwnerUser,
    required this.forMatchCreate,
    required this.imageRatio,
    this.selectedTeam,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _StadiumCardState();
}

class _StadiumCardState extends State<StadiumCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StadiumInfoScreen(
              stadium: widget.stadium,
              ownerName: widget.ownerName,
              isStadiumOwnerUser: widget.isStadiumOwnerUser,
              forMatchCreate: widget.forMatchCreate,
              selectedTeam: widget.selectedTeam,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: widget.imageRatio,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8.0),
                ),
                child: Image.network(
                  widget.stadium.avatar.path,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        widget.stadium.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Expanded(
                      child: Text(
                        '${widget.stadium.location.district}, ${widget.stadium.location.city}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.stadium.location.address,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
