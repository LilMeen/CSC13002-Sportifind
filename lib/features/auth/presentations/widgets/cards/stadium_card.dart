import 'package:flutter/material.dart';
import 'package:sportifind/features/auth/presentations/widgets/cards/match_card.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium.dart';

class StadiumCard extends StatefulWidget {
  final Stadium stadium;
  final String ownerName;
  final double imageRatio;
  final bool isStadiumOwnerUser;
  final bool forMatchCreate;
  final String? selectedTeamId;
  final String? selectedTeamName;
  final String? selectedTeamAvatar;
  final void Function(MatchCard matchcard)? addMatchCard;

  const StadiumCard({
    required this.stadium,
    required this.ownerName,
    required this.isStadiumOwnerUser,
    required this.forMatchCreate,
    required this.imageRatio,
    this.addMatchCard,
    this.selectedTeamId,
    this.selectedTeamName,
    this.selectedTeamAvatar,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _StadiumCardState();
}

class _StadiumCardState extends State<StadiumCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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
