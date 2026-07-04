import 'package:flutter/material.dart';

class ReminderModel {
  final String id;
  final String userId;
  final String name;
  final String dosage;
  final String time; // e.g. "08:00 AM"
  final bool isTaken;
  final String iconType; // "pill" | "water" | "healing" | "pharmacy"
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ReminderModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.dosage,
    required this.time,
    required this.isTaken,
    required this.iconType,
    this.createdAt,
    this.updatedAt,
  });

  /// Constructs from the backend API JSON (snake_case keys)
  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      id: json['id'] as String,
      userId: json['user_id'] as String? ?? '',
      name: json['name'] as String,
      dosage: json['dosage'] as String,
      time: json['time'] as String,
      isTaken: json['is_taken'] as bool? ?? false,
      iconType: json['icon_type'] as String? ?? 'pill',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
    );
  }

  /// Serializes for API POST/PUT requests
  Map<String, dynamic> toCreateJson() {
    return {
      'name': name,
      'dosage': dosage,
      'time': time,
      'icon_type': iconType,
      'is_taken': isTaken,
    };
  }

  ReminderModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? dosage,
    String? time,
    bool? isTaken,
    String? iconType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      time: time ?? this.time,
      isTaken: isTaken ?? this.isTaken,
      iconType: iconType ?? this.iconType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
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
