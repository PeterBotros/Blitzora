import 'package:flutter/material.dart';

class ReminderModel {
  final String id;
  final String name;
  final String dosage;
  final String time; // e.g. "08:00 AM"
  final bool isTaken;
  final String iconType; // "pill" | "water" | "healing" | "pharmacy"

  ReminderModel({
    required this.id,
    required this.name,
    required this.dosage,
    required this.time,
    required this.isTaken,
    required this.iconType,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      id: json['id'] as String,
      name: json['name'] as String,
      dosage: json['dosage'] as String,
      time: json['time'] as String,
      isTaken: json['isTaken'] as bool? ?? false,
      iconType: json['iconType'] as String? ?? 'pill',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'time': time,
      'isTaken': isTaken,
      'iconType': iconType,
    };
  }

  IconData getIconData() {
    switch (iconType) {
      case 'water':
        return Icons.water_drop_rounded;
      case 'healing':
        return Icons.healing_rounded;
      case 'pharmacy':
        return Icons.local_pharmacy_rounded;
      case 'pill':
      default:
        return Icons.medication_rounded;
    }
  }

  static String getIconType(IconData icon) {
    if (icon == Icons.water_drop_rounded) return 'water';
    if (icon == Icons.healing_rounded) return 'healing';
    if (icon == Icons.local_pharmacy_rounded) return 'pharmacy';
    return 'pill';
  }
}
