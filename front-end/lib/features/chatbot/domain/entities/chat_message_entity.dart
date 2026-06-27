import 'package:equatable/equatable.dart';

class ChatMessageEntity extends Equatable {
  final String text;
  final bool isUser;
  final DateTime time;

  const ChatMessageEntity({
    required this.text,
    required this.isUser,
    required this.time,
  });

  @override
  List<Object?> get props => [text, isUser, time];
}
