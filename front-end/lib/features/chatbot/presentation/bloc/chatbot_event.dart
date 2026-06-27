import 'package:equatable/equatable.dart';

abstract class ChatbotEvent extends Equatable {
  const ChatbotEvent();
  @override
  List<Object?> get props => [];
}

class SendChatMessageEvent extends ChatbotEvent {
  final String message;
  const SendChatMessageEvent(this.message);
  @override
  List<Object?> get props => [message];
}
