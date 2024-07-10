import 'package:flutter/material.dart';

class Rating {
  final String name;
  final int value;
  const Rating(this.name, this.value);

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      map['name'] as String,
      map['value'] as int,
    );
  }
}