import 'package:dartz/dartz.dart';
import '/core/platform/network_info.dart';
import '/modules/messages/infra/datasources/message_conversation_local_datasource.dart';
import 'package:meta/meta.dart';
import '/modules/messages/domain/errors/errors.dart';
import '/modules/messages/domain/entities/message_conversation_result.dart';
import '/modules/messages/domain/repositories/message_conversation_repository.dart';
import '/modules/messages/infra/datasources/message_conversation_remote_datasource.dart';
import '/modules/messages/infra/models/message_conversation_model.dart';
import 'package:flutter/cupertino.dart';

class MessageConversationRepositoryImpl
    implements MessageConversationRepository {
  final MessageConversationRemoteDatasource datasourceRemote;
  final MessageConversationLocalDatasource datasourceLocal;
  final NetworkInfo networkInfo;

  MessageConversationRepositoryImpl(
      {required this.datasourceRemote,
      required this.datasourceLocal,
      required this.networkInfo});

  @override
  Future<Either<Failure, List<MessageConversationResult>>> addMessages(
      List<MessageConversationResult> messageConversationResultList) async {
    List<MessageConversationResult> list;
    try {
      list = await datasourceRemote.addMessages(
          messageConversationResultList as List<MessageConversationModel>);
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorSearch());
    }

    return list == null ? left(DatasourceResultNull()) : right(list);
  }

  @override
  Future<Either<Failure, List<MessageConversationResult>>>
      getConversationAllHeaders() async {
    // TODO: implement getById
    List<MessageConversationModel> list;

    try {
      list = await datasourceRemote.getAllHeaders();
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorSearch());
    }

    return list == null ? left(DatasourceResultNull()) : right(list);
  }

  @override
  Future<Either<Failure, List<MessageConversationResult>>> getConversationById(
      int id) async {
    List<MessageConversationResult> list;
    try {
      list = await datasourceRemote.getById(id);
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorSearch());
    }

    return list == null ? left(DatasourceResultNull()) : right(list);
  }

  @override
  Future<Either<Failure, List<MessageConversationResult>>> removeMessageById(
      int id) async {
    // TODO: implement removeMessageById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, int>> getStartConversationWith(int id) async {
    int cidConversation;
    try {
      cidConversation = await datasourceRemote.getStartConversationWith(id);
    } on DatasourceError catch (e) {
      return left(e);
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorSearch());
    }

    return cidConversation <= 0
        ? left(DatasourceResultNull())
        : right(cidConversation);
  }
}
