import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_message_entity.dart';

abstract class ChatbotState extends Equatable {
  final List<ChatMessageEntity> messages;
  const ChatbotState(this.messages);
  @override
  List<Object?> get props => [messages];
}

class ChatbotIdle extends ChatbotState {
  const ChatbotIdle(super.messages);
}

class ChatbotSending extends ChatbotState {
  const ChatbotSending(super.messages);
}

class ChatbotStreaming extends ChatbotState {
  final String currentResponse;
  const ChatbotStreaming(super.messages, this.currentResponse);
  @override
  List<Object?> get props => [messages, currentResponse];
}

class ChatbotError extends ChatbotState {
  final String error;
  const ChatbotError(super.messages, this.error);
  @override
  List<Object?> get props => [messages, error];
}
