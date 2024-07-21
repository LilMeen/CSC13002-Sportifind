import 'package:flutter/material.dart';
import 'package:sportifind/models/stadium_data.dart';
import 'package:sportifind/screens/player/stadium/stadium_info_screen.dart';

class StadiumCard extends StatefulWidget {
  final StadiumData stadium;
  final String ownerName;
  final double imageRatio;
  final bool forMatchCreate;

  const StadiumCard({
    required this.stadium,
    required this.ownerName,
    required this.forMatchCreate,
    required this.imageRatio,
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
                    forMatchCreate: widget.forMatchCreate,
                  )),
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
                  'https://bizweb.dktcdn.net/100/017/070/files/kich-thuoc-san-bong-da-1-jpeg.jpg?v=1671246300021',
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
