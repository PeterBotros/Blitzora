import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/usecases/send_message_usecase.dart';
import 'chatbot_event.dart';
import 'chatbot_state.dart';

class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  final SendMessageUseCase _sendMessageUseCase;

  static final _welcome = ChatMessageEntity(
    text:
        "Hi! I'm Blitz, your pharmacy assistant. How can I help you today? I can find medicines, check pharmacy hours, or answer health questions.",
    isUser: false,
    time: DateTime(2024),
  );

  ChatbotBloc({required SendMessageUseCase sendMessageUseCase})
      : _sendMessageUseCase = sendMessageUseCase,
        super(ChatbotIdle([_welcome])) {
    on<InitChatbotEvent>(_onInit);
    on<SendChatMessageEvent>(_onSend);
  }

  void _onInit(InitChatbotEvent event, Emitter<ChatbotState> emit) {
    final translated = ChatMessageEntity(
      text: event.welcomeMessage,
      isUser: false,
      time: DateTime(2024),
    );
    emit(ChatbotIdle([translated]));
  }

  Future<void> _onSend(
      SendChatMessageEvent event, Emitter<ChatbotState> emit) async {
    final userMsg = ChatMessageEntity(
      text: event.message,
      isUser: true,
      time: DateTime.now(),
    );
    final withUser = [...state.messages, userMsg];
    emit(ChatbotSending(withUser));

    String botResponse = '';
    try {
      await emit.forEach<String>(
        _sendMessageUseCase(event.message),
        onData: (chunk) {
          botResponse += chunk;
          return ChatbotStreaming(withUser, botResponse);
        },
        onError: (e, _) => ChatbotError(withUser, e.toString()),
      );

      // Streaming finished — commit full bot message
      if (state is! ChatbotError) {
        final botMsg = ChatMessageEntity(
          text: botResponse.isNotEmpty ? botResponse : '...',
          isUser: false,
          time: DateTime.now(),
        );
        emit(ChatbotIdle([...withUser, botMsg]));
      }
    } catch (e) {
      emit(ChatbotError(withUser, e.toString()));
    }
  }
}
