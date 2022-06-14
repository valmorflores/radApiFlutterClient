import 'dart:convert';

import '/modules/messages/domain/entities/message_conversation_result.dart';

class MessageConversationModel extends MessageConversationResult {
  int? index;
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

  MessageConversationModel({
    this.index,
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

  MessageConversationResult copyWith({
    int? index,
    int? id,
    int? cid,
    int? memberId,
    int? contactId,
    String? message,
    String? filePath,
    String? imagePath,
    String? stickerPath,
    int? sendLike,
    int? timeCreated,
    String? gifPath,
  }) {
    return MessageConversationModel(
      index: index ?? this.index,
      id: id ?? this.id,
      cid: cid ?? this.cid,
      memberId: memberId ?? this.memberId,
      contactId: contactId ?? this.contactId,
      message: message ?? this.message,
      filePath: filePath ?? this.filePath,
      imagePath: imagePath ?? this.imagePath,
      stickerPath: stickerPath ?? this.stickerPath,
      sendLike: sendLike ?? this.sendLike,
      timeCreated: timeCreated ?? this.timeCreated,
      gifPath: gifPath ?? this.gifPath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'index': index,
      'id': id,
      'cid': cid,
      'member_id': memberId,
      'contact_id': contactId,
      'message': message,
      'file_path': filePath,
      'image_path': imagePath,
      'sticker_path': stickerPath,
      'send_like': sendLike,
      'time_created': timeCreated,
      'gif_path': gifPath,
    };
  }

  factory MessageConversationModel.fromMap(Map<String, dynamic> map) {
    return MessageConversationModel(
      index: map['index'],
      id: map['id'],
      cid: map['cid'],
      memberId: map['member_id'],
      contactId: map['contact_id'],
      message: map['message'],
      filePath: map['file_path'],
      imagePath: map['image_path'],
      stickerPath: map['sticker_path'],
      sendLike: map['send_like'],
      timeCreated: map['time_created'],
      gifPath: map['gif_path'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageConversationModel.fromJson(String source) =>
      MessageConversationModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MessageConversationResult(id: $id, cid: $cid, memberId: $memberId, contactId: $contactId, message: $message, filePath: $filePath, imagePath: $imagePath, stickerPath: $stickerPath, sendLike: $sendLike, timeCreated: $timeCreated, gifPath: $gifPath)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessageConversationModel &&
        other.id == id &&
        other.cid == cid &&
        other.memberId == memberId &&
        other.contactId == contactId &&
        other.message == message &&
        other.filePath == filePath &&
        other.imagePath == imagePath &&
        other.stickerPath == stickerPath &&
        other.sendLike == sendLike &&
        other.timeCreated == timeCreated &&
        other.gifPath == gifPath;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        cid.hashCode ^
        memberId.hashCode ^
        contactId.hashCode ^
        message.hashCode ^
        filePath.hashCode ^
        imagePath.hashCode ^
        stickerPath.hashCode ^
        sendLike.hashCode ^
        timeCreated.hashCode ^
        gifPath.hashCode;
  }
}
