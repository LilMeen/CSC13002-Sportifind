import 'package:flutter/material.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/models/stadium_data.dart';
import 'package:sportifind/screens/player/match/screens/date_select_screen.dart';

class StadiumInfoScreen extends StatefulWidget {
  final StadiumData stadium;
  final String ownerName;
  final bool forMatchCreate;
  final String? selectedTeamId;
  final String? selectedTeamName;
  final String? selectedTeamAvatar;
  final void Function(MatchCard matchcard)? addMatchCard;

  const StadiumInfoScreen({
    super.key,
    required this.stadium,
    required this.ownerName,
    required this.forMatchCreate,
    this.addMatchCard,
    required this.selectedTeamId,
    required this.selectedTeamName,
    required this.selectedTeamAvatar,
  });

  @override
  State<StadiumInfoScreen> createState() => _StadiumInfoScreenState();
}

class _StadiumInfoScreenState extends State<StadiumInfoScreen> {
  late String selectedImage;

  @override
  void initState() {
    super.initState();
    selectedImage = widget.stadium.avatar;
  }

  void _onImageTap(String imageUrl) {
    setState(() {
      selectedImage = imageUrl;
      
    });
  }

  Widget _buildImage(String imageUrl) {
    return GestureDetector(
      onTap: () => _onImageTap(imageUrl),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: 150,
            height: 100,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.broken_image,
                  size: 100, color: Colors.grey);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Baseline(
                baseline: 26,
                baselineType: TextBaseline.alphabetic,
                child: Icon(icon, color: Colors.teal, size: 22),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '$label: ',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: value,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
        ],
      ),
    );
  }

  String formatPrice(double price) {
    final priceString = price.toStringAsFixed(0);
    final buffer = StringBuffer();
    for (int i = 0; i < priceString.length; i++) {
      if (i > 0 && (priceString.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(priceString[i]);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stadium Information'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  selectedImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 250,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image,
                        size: 250, color: Colors.grey);
                  },
                ),
              ),
              const SizedBox(height: 16),
              if (widget.stadium.images.isNotEmpty)
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.stadium.images.length + 1,
                    itemBuilder: (context, index) {
                      String imageUrl = index == 0
                          ? widget.stadium.avatar
                          : widget.stadium.images[index - 1];
                      return _buildImage(imageUrl);
                    },
                  ),
                ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Baseline(
                            baseline: 23.5,
                            baselineType: TextBaseline.alphabetic,
                            child: Icon(Icons.stadium,
                                color: Colors.teal, size: 30),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.stadium.name,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(Icons.person, 'Owner', widget.ownerName),
                      _buildDetailRow(Icons.location_on, 'Address',
                          '${widget.stadium.location.address}, ${widget.stadium.location.district}, ${widget.stadium.location.city}'),
                      _buildDetailRow(Icons.access_time, 'Opening Time',
                          '${widget.stadium.openTime} ~ ${widget.stadium.closeTime}'),
                      _buildDetailRow(
                          Icons.phone, 'Phone', widget.stadium.phone),
                      if (widget.stadium.getNumberOfTypeField('5-Player') > 0)
                        Row(
                          children: [
                            Flexible(
                              child: _buildDetailRow(
                                  Icons.sports_soccer,
                                  '5-Player fields',
                                  widget.stadium
                                      .getNumberOfTypeField('5-Player')
                                      .toString()),
                            ),
                            Flexible(
                              child: _buildDetailRow(
                                  Icons.attach_money,
                                  'Price',
                                  '${formatPrice(widget.stadium.getPriceOfTypeField('5-Player'))}/h'),
                            ),
                          ],
                        ),
                      if (widget.stadium.getNumberOfTypeField('7-Player') > 0)
                        Row(
                          children: [
                            Flexible(
                              child: _buildDetailRow(
                                  Icons.sports_soccer,
                                  '7-Player fields',
                                  widget.stadium
                                      .getNumberOfTypeField('7-Player')
                                      .toString()),
                            ),
                            Flexible(
                              child: _buildDetailRow(
                                  Icons.attach_money,
                                  'Price',
                                  '${formatPrice(widget.stadium.getPriceOfTypeField('7-Player'))}/h'),
                            ),
                          ],
                        ),
                      if (widget.stadium.getNumberOfTypeField('11-Player') > 0)
                        Row(
                          children: [
                            Flexible(
                              child: _buildDetailRow(
                                  Icons.sports_soccer,
                                  '11-Player fields',
                                  widget.stadium
                                      .getNumberOfTypeField('11-Player')
                                      .toString()),
                            ),
                            Flexible(
                              child: _buildDetailRow(
                                  Icons.attach_money,
                                  'Price',
                                  '${formatPrice(widget.stadium.getPriceOfTypeField('11-Player'))}/h'),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              widget.forMatchCreate == true
                  ? Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: SportifindTheme.grey,
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DateSelectScreen(
                                selectedStadiumId: widget.stadium.id,
                                selectedStadiumName: widget.stadium.name,
                                selectedStadiumOwner: widget.stadium.owner,
                                selectedTeamId: widget.selectedTeamId!,
                                selectedTeamName: widget.selectedTeamName!,
                                selectedTeamAvatar: widget.selectedTeamAvatar!,
                                fields: widget.stadium.fields,
                                addMatchCard: widget.addMatchCard,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          "Pick this stadium",
                          style: SportifindTheme.status,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
