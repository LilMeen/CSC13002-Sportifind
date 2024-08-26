import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';
import 'package:sportifind/features/team/domain/usecases/create_team.dart';
import 'package:sportifind/features/team/domain/usecases/edit_team.dart';

class TeamBloc {
  Future<void> teamProcessing({
    required String action,
    required Map<String, TextEditingController> controllers,
    required Location? location,
    required String selectedCity,
    required String selectedDistrict,
    required File avatar,
    required List<File> images,
    TeamEntity? teamInformation,
  }) async {
    if (action == 'create') {
      await createTeam(
        teamName: controllers['teamName']!.text,
        location: Location(city: selectedCity, district: selectedDistrict),
        avatar: avatar,
        images: images,
      );
    }
    if (action == 'edit') {
      await editTeam(
        team: teamInformation!,
        teamName: controllers['teamName']!.text,
        location: location!,
        avatar: avatar,
        images: images,
      );
    }
  }

  Future<void> createTeam({
    required String teamName,
    required Location location,
    required File avatar,
    required List<File> images,
  }) async {
    await UseCaseProvider.getUseCase<CreateTeam>().call(
      CreateTeamParams(
        name: teamName,
        district: location.district,
        city: location.city,
        captain: FirebaseAuth.instance.currentUser!.uid,
        avatar: avatar,
      ),
    );
  }

  Future<void> editTeam({
    required TeamEntity team,
    required String teamName,
    required Location location,
    required File avatar,
    required List<File> images,
  }) async {
    await UseCaseProvider.getUseCase<EditTeam>().call(
      EditTeamParams(
        name: teamName,
        location: location,
        avatar: avatar,
        images: images,
        team: team,
      ),
    );
  }

  Future<File> downloadAvatarFile(String teamId) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('teams')
        .child(teamId)
        .child('avatar')
        .child('avatar.jpg');

    try {
      final tempDir = await getTemporaryDirectory();
      final avatar = File('${tempDir.path}/avatar.jpg');

      await ref.writeToFile(avatar);

      return avatar;
    } catch (e) {
      throw Exception('Failed to download avatar file: $e');
    }
  }

  Future<List<File>> downloadImageFiles(String teamId, int imageslength) async {
    List<File> files = [];

    for (int i = 0; i < imageslength; i++) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('teams')
          .child(teamId)
          .child('images')
          .child('image_$i.jpg');

      try {
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/image_$i.jpg');

        await ref.writeToFile(file);

        files.add(file);
      } catch (e) {
        throw Exception('Failed to download image files: $e');
      }
    }
    return files;
  }
}