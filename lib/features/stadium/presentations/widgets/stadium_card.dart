import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
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
          side: BorderSide(
            color: SportifindTheme.bluePurple,
            width: 2.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: widget.imageRatio,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: widget.stadium.avatar.path,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(height: 6.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(Icons.stadium, widget.stadium.name),
                    _buildDetailRow(Icons.place_outlined,
                        '${widget.stadium.location.address}, ${widget.stadium.location.district}, ${widget.stadium.location.city}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Icon(icon, color: SportifindTheme.bluePurple, size: 25),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: SportifindTheme.stadiumCard,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
