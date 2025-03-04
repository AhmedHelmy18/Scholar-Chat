import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scolar_chat/constants.dart';
import 'package:scolar_chat/models/message.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  CollectionReference messages = FirebaseFirestore.instance.collection(
    kMessagesCollections,
  );

  void sendMessage({required String message, required String email}) {
    try {
      messages.add({
        kMessage: message,
        kCreatedAt: DateTime.now(),
        'id': email,
      });
    } on Exception catch (e) {
      print("Error sending message: $e");
    }
  }

  void getMessages() {
    messages.orderBy(kCreatedAt, descending: true).snapshots().listen((event) {
      List<Message> newMessages = [];

      for (var doc in event.docs) {
        newMessages.add(Message.fromJson(doc));
      }

      emit(ChatSuccess(messages: newMessages)); // Emit new list
    });
  }
}
