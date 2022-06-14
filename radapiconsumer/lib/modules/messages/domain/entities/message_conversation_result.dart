import 'dart:convert';

class MessageConversationResult {
  int? id;
  int? cid;
  int? memberId;
  int? contactId;
  String? message;
  String? filePath;
  String? imagePath;
  String? stickerPath;
  int? sendLike;
  int? timeCreated;
  String? gifPath;

  MessageConversationResult({
    this.id,
    this.cid,
    this.memberId,
    this.contactId,
    this.message,
    this.filePath,
    this.imagePath,
    this.stickerPath,
    this.sendLike,
    this.timeCreated,
    this.gifPath,
  });
}
