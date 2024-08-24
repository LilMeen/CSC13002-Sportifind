// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium_entity.dart';
import 'package:sportifind/features/stadium/domain/usecases/delete_stadium.dart';
import 'package:sportifind/features/stadium/presentations/screens/stadium_owner/owner_stadium_screen.dart';

class StadiumInfoState {
  final bool isDeleting;
  final String selectedImage;

  StadiumInfoState({
    this.isDeleting = false,
    required this.selectedImage,
  });

  StadiumInfoState copyWith({
    bool? isDeleting,
    String? selectedImage,
  }) {
    return StadiumInfoState(
      isDeleting: isDeleting ?? this.isDeleting,
      selectedImage: selectedImage ?? this.selectedImage,
    );
  }
}

class StadiumInfoBloc {
  final BuildContext context;
  final StadiumEntity stadium;
  
  final _stateController = StreamController<StadiumInfoState>.broadcast();
  late StadiumInfoState _state;

  Stream<StadiumInfoState> get stateStream => _stateController.stream;
  StadiumInfoState get currentState => _state;

  StadiumInfoBloc(this.context, this.stadium) {
    _state = StadiumInfoState(selectedImage: stadium.avatar.path);
    _stateController.add(_state);
  }

  void dispose() {
    _stateController.close();
  }

  void _updateState(StadiumInfoState Function(StadiumInfoState) update) {
    _state = update(_state);
    _stateController.add(_state);
  }

  void onImageTap(String imageUrl) {
    _updateState((state) => state.copyWith(selectedImage: imageUrl));
  }

  String formatPrice(double price) {
    price = price / 1000;
    final priceString = price.toStringAsFixed(0);
    final buffer = StringBuffer();
    for (int i = 0; i < priceString.length; i++) {
      if (i > 0 && (priceString.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(priceString[i]);
    }
    return '${buffer.toString()}k/h';
  }

  Future<void> deleteStadium() async {
    _updateState((state) => state.copyWith(isDeleting: true));
    
    final result = await UseCaseProvider.getUseCase<DeleteStadium>().call(
      DeleteStadiumParams(stadium.id),
    );

    if (result.isSuccess) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const OwnerStadiumScreen(),
        ),
      );
    } else {
      _updateState((state) => state.copyWith(isDeleting: false));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete stadium: ${result.message}"),
        ),
      );
    }
  }
}