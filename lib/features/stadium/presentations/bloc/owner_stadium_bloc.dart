import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/features/profile/domain/entities/stadium_owner.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/features/profile/domain/usecases/get_stadium_owner.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium.dart';
import 'package:sportifind/features/stadium/domain/usecases/get_stadiums_by_owner.dart';

class OwnerStadiumState {
  final bool isLoading;
  final String errorMessage;
  final List<Stadium> stadiums;
  final StadiumOwner? user;

  OwnerStadiumState({
    this.isLoading = true,
    this.errorMessage = '',
    this.stadiums = const [],
    this.user,
  });

  OwnerStadiumState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Stadium>? stadiums,
    StadiumOwner? user,
  }) {
    return OwnerStadiumState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      stadiums: stadiums ?? this.stadiums,
      user: user ?? this.user,
    );
  }
}




class OwnerStadiumBloc {
  final BuildContext context;
  final _stateController = StreamController<OwnerStadiumState>.broadcast();
  late OwnerStadiumState _state;

  Stream<OwnerStadiumState> get stateStream => _stateController.stream;
  OwnerStadiumState get currentState => _state;

  OwnerStadiumBloc(this.context) : _state = OwnerStadiumState() {
    _stateController.add(_state);
    fetchData();
  }

  void dispose() {
    _stateController.close();
  }

  void _updateState(OwnerStadiumState Function(OwnerStadiumState) update) {
    _state = update(_state);
    _stateController.add(_state);
  }

  Future<void> fetchData() async {
    _updateState((state) => state.copyWith(isLoading: true, errorMessage: ''));

    try {
      final userData = await UseCaseProvider.getUseCase<GetStadiumOwner>().call(
        GetStadiumOwnerParams(id: FirebaseAuth.instance.currentUser!.uid),
      ).then((value) => value.data!);
      
      final stadiumsData = await UseCaseProvider.getUseCase<GetStadiumsByOwner>().call(
        GetStadiumsByOwnerParams(ownerId: userData.id),
      ).then((value) => value.data!);

      _updateState((state) => state.copyWith(
        isLoading: false,
        stadiums: stadiumsData,
        user: userData,
      ));
    } catch (error) {
      _updateState((state) => state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load data: $error',
      ));
    }
  }

  Future<void> refreshStadiums() async {
    await fetchData();
  }
}
