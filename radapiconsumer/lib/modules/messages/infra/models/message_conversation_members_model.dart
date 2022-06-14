import 'dart:convert';

import '/modules/messages/domain/entities/message_conversation_members_result.dart';

class MessageConversationMembersModel extends MessageConversationMembersResult {
  int? id;
  int? cid;
  int? memberId;
  int? contactId;

  MessageConversationMembersModel({
    this.id,
    this.cid,
    this.memberId,
    this.contactId,
  });

  MessageConversationMembersModel copyWith({
    int? id,
    int? cid,
    int? memberId,
    int? contactId,
  }) {
    return MessageConversationMembersModel(
      id: id ?? this.id,
      cid: cid ?? this.cid,
      memberId: memberId ?? this.memberId,
      contactId: contactId ?? this.contactId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cid': cid,
      'member_id': memberId,
      'contact_id': contactId,
    };
  }

  factory MessageConversationMembersModel.fromMap(Map<String, dynamic> map) {
    return MessageConversationMembersModel(
      id: map['id'],
      cid: map['cid'],
      memberId: map['member_id'],
      contactId: map['contact_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageConversationMembersModel.fromJson(String source) =>
      MessageConversationMembersModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MessageConversationMembersModel(id: $id, cid: $cid, memberId: $memberId, contactId: $contactId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessageConversationMembersModel &&
        other.id == id &&
        other.cid == cid &&
        other.memberId == memberId &&
        other.contactId == contactId;
  }

  @override
  int get hashCode {
    return id.hashCode ^ cid.hashCode ^ memberId.hashCode ^ contactId.hashCode;
  }
}
