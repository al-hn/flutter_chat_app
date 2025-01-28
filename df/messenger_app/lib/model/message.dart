import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;

  final String recieverId;
  final String message;
  final Timestamp timestamp;

  Message(
      {required this.senderId,
      required this.senderEmail,
      required this.recieverId,
      required this.timestamp,
      required this.message});

  //conv message to map
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'recieverId': recieverId,
      'timestamp': timestamp,
      'message': message
    };
  }
}
