import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String content;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.isRead,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId, title, content, isRead, createdAt];
}
