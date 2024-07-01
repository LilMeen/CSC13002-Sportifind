import 'package:flutter/material.dart';

class StadiumCard extends StatelessWidget {
  final Map<String, dynamic> stadiumData;
  final double imageRatio;

  const StadiumCard({
    required this.stadiumData,
    this.imageRatio = 1,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const SportifindHomeScreen()),
        // );
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
              aspectRatio: imageRatio,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8.0),
                ),
                child: Image.network(
                  stadiumData['image'] ??
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
                    Flexible(
                      child: Text(
                        stadiumData['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Flexible(
                      child: Text(
                        '${stadiumData['district']}, ${stadiumData['city']}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        stadiumData['address'],
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
