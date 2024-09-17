import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium_entity.dart';
import 'dart:async';


class StadiumSlidingPhotos extends StatefulWidget {
  final StadiumEntity stadium;

  const StadiumSlidingPhotos({
    super.key,
    required this.stadium,
  });

  @override
  State<StadiumSlidingPhotos> createState() => _StadiumSlidingPhotosState();
}

class _StadiumSlidingPhotosState extends State<StadiumSlidingPhotos> {
  int currentIndex = 0;
  List<String> photoUrls = [];
  late PageController _pageController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    photoUrls.add(widget.stadium.avatar.path);
    for (var image in widget.stadium.images) {
      photoUrls.add(image.path);
    }

    _pageController = PageController(initialPage: 0);

    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (currentIndex < photoUrls.length - 1) {
        currentIndex++;
      } else {
        currentIndex = 0;
      }

      _pageController.animateToPage(
        currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20), // Rounded corners
          child: SizedBox(
            height: 0.8 * MediaQuery.of(context).size.width,
            child: PageView.builder(
              controller: _pageController,
              itemCount: photoUrls.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: photoUrls[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                );
              },
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.stadium.name,
                style: SportifindTheme.stadiumNameStadiumInfo,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    color: Colors.white,
                    size: 22,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.stadium.openTime} - ${widget.stadium.closeTime}',
                    style: SportifindTheme.stadiumTimeStadiumInfo,
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 15,
          right: 10,
          child: Row(
            children: List.generate(
              photoUrls.length,
              (index) => buildDot(index, context),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDot(int index, BuildContext context) {
    return Container(
      height: 8,
      width: 8,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: currentIndex == index ? Colors.yellow : Colors.white,
      ),
    );
  }
}
