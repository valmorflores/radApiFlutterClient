import 'package:dartz/dartz.dart';
import 'package:dartz/dartz_unsafe.dart';
import '/core/controllers/application/application_controller.dart';
import '/core/platform/network_info.dart';
import '/modules/contacts/domain/entities/contact_result.dart';
import '/modules/contacts/infra/models/contact_model.dart';
import '/modules/messages/domain/entities/message_conversation_result.dart';
import '/modules/messages/domain/entities/message_room_result.dart';
import '/modules/messages/domain/repositories/message_conversation_repository.dart';
import '/modules/messages/domain/repositories/message_room_repository.dart';
import '/modules/messages/domain/usecases/add_message_into_room.dart';
import '/modules/messages/domain/usecases/get_message_conversation_by_id.dart';
import '/modules/messages/domain/usecases/get_message_conversation_with_staff_id.dart';
import '/modules/messages/domain/usecases/get_message_rooms.dart';
import '/modules/messages/external/api/eiapi_message_rooms_datasource.dart';
import '/modules/messages/external/api/eiapi_message_conversation_datasource.dart';
import '/modules/messages/external/db/eidb_message_converstion_datasource.dart';
import '/modules/messages/infra/datasources/message_conversation_local_datasource.dart';
import '/modules/messages/infra/datasources/message_conversation_remote_datasource.dart';
import '/modules/messages/infra/datasources/message_room_datasource.dart';
import '/modules/messages/infra/models/message_conversation_model.dart';
import '/modules/messages/infra/models/message_room_model.dart';
import '/modules/messages/infra/repositories/message_conversation_repository_impl.dart';
import '/modules/messages/infra/repositories/message_room_repository_impl.dart';
import '/modules/messages/presenter/models/message_people_list_model.dart';
import '/modules/messages/presenter/models/message_room_list_model.dart';
import '/modules/staff/domain/entities/staff_result.dart';
import '/modules/staff/infra/models/staff_model.dart';
import '/utils/globals.dart';
import '/utils/wks_custom_dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import '/modules/messages/infra/repositories/message_room_repository_impl.dart';

class MessageController extends GetxController {
  ApplicationController applicationController =
      Get.put(ApplicationController());
  RxString roomTitle = ''.obs;
  RxList roomList = <MessageRoomListModel>[].obs;
  RxList messageList = <MessageConversationModel>[].obs;
  RxList peopleList = <MessagePeopleListModel>[].obs;
  RxInt count = 0.obs;
  RxInt roomSelectedId = 0.obs;
  RxInt selectedUser = 0.obs;
  late MessageRoomResult messageRoom;

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  /* Custom dio default */
  late WksCustomDio dio;
  late NetworkInfo networkInfo;

  late MessageConversationRemoteDatasource datasourceRemote;
  late MessageConversationLocalDatasource datasourceLocal;

  late MessageConversationRepositoryImpl conversationRemoteRepository;
  late MessageConversationRemoteDatasource conversationRemoteDatasource;

  late GetMessageConversationByIdImpl getMessageConversationByIdImpl;
  late GetMessageConversationWithStaffIdImpl
      getMessageConversationWithStaffIdImpl;

  late MessageRoomRepository messageRoomRemoteRepository;
  late GetMessageRoomsImpl getMessageRoomsImpl;
  late MessageRoomDatasource datasourceRoomRemote;

  late AddMessageIntoRoom addMessageIntoRoomImpl;

  Future<void> loadConversation(int id) async {
    debugPrint(
        'f7872 - clear getMessageConversation and reload URLs list from UrlController');
    messageList.clear();
    var result = await getMessageConversationByIdImpl.call(id);
    debugPrint('f7872 - After call?');
    if (result.isRight()) {
      var info = (result as Right).value;
      final List<MessageConversationModel> _myUrlModel = info;
      debugPrint('f7872 - After conversion');
      debugPrint(
          'f7872 - ${_myUrlModel.length.toString()} - ${_myUrlModel.last.message}');
      messageList.addAll(_myUrlModel);
    }
    debugPrint('f7872 - done');
    updateCount();
  }

  removeZeradas() {
    messageList.removeWhere((element) => element.id == 0);
    update();
  }

  setUser(int userId) {
    selectedUser.value = userId;
    update();
  }

  getUser() {
    return selectedUser.value;
  }

  // Compare and extract only new messages
  Future<List<MessageConversationModel>> getMessageNews() async {
    List<MessageConversationModel> _messageNewsList = [];
    _messageNewsList.clear();
    var result =
        await getMessageConversationByIdImpl.call(roomSelectedId.value);
    if (result.isRight()) {
      var info = (result as Right).value;
      final List<MessageConversationModel> _myResultModel = info;
      bool lExists = false;
      _myResultModel.forEach((e) {
        lExists = false;
        messageList.forEach((element) {
          if (element.id == e.id) {
            lExists = true;
          }
        });
        if (!lExists) {
          _messageNewsList.add(e);
        }
      });
    }
    updateCount();
    return _messageNewsList;
  }

  setRoomTitle({String title = ''}) {
    roomTitle.value = title;
    update();
  }

  selectRoom(int id) {
    roomSelectedId.value = id;
    update();
  }

  selectFirstRoom() {
    int _sel = roomSelectedId.value;
    roomList.forEach((element) {
      if (roomSelectedId.value == 0) {
        debugPrint('f7807 - Selected ${element.cid}');
        roomSelectedId.value = element.cid;
      }
    });
    if (_sel != roomSelectedId.value) {
      debugPrint('f7807 - Try select first room (it`s changed)');
      if (roomSelectedId.value > 0) {
        messageList.clear();
        loadConversation(roomSelectedId.value);
        count++;
      }
      update();
    }
  }

  loadRooms() async {
    roomList.clear();
    debugPrint('f7872 - load rooms');
    var result = await getMessageRoomsImpl.call();
    await loadStaffs();
    await loadFirstRoom(result);
    await loadPossibleRoom(result);
    await loadClosedRoom();
    await selectFirstRoom();
    updateCount();
  }

  String _getTitle(MessageRoomModel messageRoomModel) {
    String _title = '';
    int _userId = 0;
    debugPrint(
        'f7872 - ${messageRoomModel.isContact} / ${messageRoomModel.user1} / ${messageRoomModel.user2}');
    if (messageRoomModel.user1 == app_user.staffid) {
      _userId = messageRoomModel.user2;
    } else if (messageRoomModel.user2 == app_user.staffid) {
      _userId = messageRoomModel.user1;
    }
    if (_userId == 0) {
      _title = 'GRUPO';
      return _title;
    }
    if (messageRoomModel.isContact) {
      _title = 'CONTATO';
    } else {
      _title = 'DESCONHECIDO / INATIVO';
    }
    peopleList.forEach((element) {
      if (element.id == _userId) {
        _title = element.title;
      }
    });
    return _title;
  }

  saveRoomToList(MessageRoomModel messageRoomModel) {
    late MessageRoomListModel _item;
    late String _title = _getTitle(messageRoomModel);
    _item = MessageRoomListModel(
        title: _title,
        subtitle:
            '${messageRoomModel.id} ${messageRoomModel.user1} ${messageRoomModel.user2} - ${messageRoomModel.title}',
        time: '00:00h',
        lastPartial: '',
        user1: messageRoomModel.user1,
        user2: messageRoomModel.user2,
        type: messageRoomModel.type ?? '',
        isContact: messageRoomModel.isContact,
        cid: messageRoomModel.id ?? 0); //r.c
    debugPrint(
        'f7872 - room title: ${messageRoomModel.id} - ${messageRoomModel.title} ');
    roomList.add(_item);
  }

  // Sala ativa (possivel conversa selecionada)
  loadFirstRoom(result) {
    debugPrint('f7872 - After call?');
    final List<MessageRoomModel> _myUrlModel = [];
    if (result.isRight()) {
      var info = (result as Right).value;
      _myUrlModel.addAll(info);
      debugPrint('f7872 - After conversion');
    }
    debugPrint('f7872 - done');
    _myUrlModel.forEach((r) {
      int _user1 = (messageRoom as MessageRoomModel).user1;
      int _user2 = (messageRoom as MessageRoomModel).user2;
      if ([r.user1, r.user2].contains(_user1) &&
          [r.user1, r.user2].contains(_user2)) {
        if (!existRoom(r.id ?? 0)) {
          saveRoomToList(r);
        }
      }
    });
    debugPrint(
        'f7872 - Size of MessageRoomListModel : ${roomList.length.toString()}');
  }

  // Conversas passadas
  loadPossibleRoom(result) {
    final List<MessageRoomModel> _myUrlModel = [];
    if (result.isRight()) {
      var info = (result as Right).value;
      _myUrlModel.addAll(info);
    }
    _myUrlModel.forEach((r) {
      int _user1 = (messageRoom as MessageRoomModel).user1;
      int _user2 = (messageRoom as MessageRoomModel).user2;
      if ([r.user1, r.user2].contains(app_user.staffid)) {
        if ([r.user1, r.user2].contains(_user2)) {
          // Nothing, ja foi feito
        } else {
          if (!existRoom(r.id ?? 0)) {
            saveRoomToList(r);
          }
        }
      }
    });
    debugPrint(
        'f7872 - Size of MessageRoomListModel : ${roomList.length.toString()}');
  }

  // Conversas não iniciadas
  loadClosedRoom() {
    bool lExistRoom = false;
    peopleList.forEach((ePeople) {
      lExistRoom = false;
      roomList.forEach((eRoom) {
        if (([
              (eRoom as MessageRoomListModel).user1,
              (eRoom as MessageRoomListModel).user2
            ].contains(app_user.staffid)) &&
            ([
              (eRoom as MessageRoomListModel).user1,
              (eRoom as MessageRoomListModel).user2
            ].contains(ePeople.id))) {
          lExistRoom = true;
        }
      });
      if (!lExistRoom) {
        MessageRoomModel messageRoomModel = MessageRoomModel(
          isContact: false,
          type: 'single',
          user1: app_user.staffid ?? 0,
          user2: ePeople.id,
          contactsId: [],
          membersId: [],
          title: ePeople.title,
          id: ePeople.id * (-1),
        );
        saveRoomToList(messageRoomModel);
      }
    });
  }

  bool existRoom(int id) {
    bool _exist = false;
    if (roomList.length > 0) {
      roomList.forEach((element) {
        if (element.cid == id) {
          _exist = true;
        }
      });
    }
    return _exist;
  }

  updateCount() {
    ++count;
    update();
  }

  addMessage(MessageConversationModel _message) async {
    int _id = (await doSendMessageToRemote([_message]));
    _message.id = _id;
    messageList.add(_message);
  }

  startNewOrGetConversationId(int user) async {
    var result = await getMessageConversationWithStaffIdImpl.call(user);
    if (result.isRight()) {
      final int _resultado = (result as Right).value;
      debugPrint('f7872 - get result $_resultado');
      return _resultado;
    }
    return 0;
  }

  Future<int> doSendMessageToRemote(
      List<MessageConversationModel> _messages) async {
    debugPrint(
        'f7872 - Message to ${(_messages[0] as MessageConversationModel).memberId.toString()}');
    var result = await addMessageIntoRoomImpl.call(_messages);
    if (result.isRight()) {
      var info = (result as Right).value;
      final List<MessageConversationModel> _myMessageConversationModelList =
          info;
      debugPrint('f7872 - After get conversion list');
      debugPrint(
          'f7872 - ${_myMessageConversationModelList.length.toString()} - ${_myMessageConversationModelList.last.message} - ${_myMessageConversationModelList.last.id}');
      return _myMessageConversationModelList.last.id ?? 0;
    }
    return 0;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    final dio = WksCustomDio.withAuthentication().instance;
    datasourceRemote = EIAPIMessageConversationDatasource(dio);
    datasourceLocal = EIDBMessageConversationDatasource();
    conversationRemoteRepository = MessageConversationRepositoryImpl(
        datasourceRemote: datasourceRemote,
        datasourceLocal: datasourceLocal,
        networkInfo: NetworkInfo(isConnected: true, isLocalFirst: true));
    getMessageConversationByIdImpl =
        GetMessageConversationByIdImpl(conversationRemoteRepository);

    // API / Message rooms datasource
    datasourceRoomRemote = EIAPIMessageRoomsDatasource(dio);
    messageRoomRemoteRepository = MessageRoomRepositoryImpl(
        datasourceRemote: datasourceRoomRemote,
        networkInfo: NetworkInfo(isConnected: true, isLocalFirst: true));
    getMessageRoomsImpl = GetMessageRoomsImpl(messageRoomRemoteRepository);

    // Comunication to add Messages into room
    addMessageIntoRoomImpl =
        AddMessageIntoRoomImpl(conversationRemoteRepository);

    // Get or start new room
    getMessageConversationWithStaffIdImpl =
        GetMessageConversationWithStaffIdImpl(conversationRemoteRepository);

    loadStaffs();

    // Get and load necessary Contacts
  }

  // Get and load all Staffs
  loadStaffs() {
    peopleList.clear();
    if (peopleList.length <= 0) {
      if (applicationController.app_staffModelList.length > 0) {
        applicationController.app_staffModelList.forEach((element) {
          //  addPeopleStaff(element);
        });
      }
    }
  }

  setRoom(MessageRoomModel _messageRoom) {
    messageRoom = (_messageRoom as MessageRoomModel);
  }

  clearPeople() {
    peopleList.clear();
  }

  addPeopleStaff(StaffResult staffModel) {
    StaffModel _staffModel = (staffModel as StaffModel);
    MessagePeopleListModel _people = MessagePeopleListModel(
        id: _staffModel.staffid ?? 0,
        title: _staffModel.firstname ?? '',
        subtitle: _staffModel.lastname ?? '',
        lastActivity: _staffModel.lastActiveTime.toString(),
        name: _staffModel.firstname ?? '',
        isContact: false);
    peopleList.add(_people);
  }

  addPeopleContact(ContactResult contactModel) {
    ContactModel _contactModel = (contactModel as ContactModel);
    MessagePeopleListModel _people = MessagePeopleListModel(
        id: _contactModel.id ?? 0,
        title: _contactModel.firstname ?? '',
        subtitle: _contactModel.lastname ?? '',
        lastActivity: _contactModel.lastActiveTime.toString(),
        name: _contactModel.firstname ?? '',
        isContact: true);
    peopleList.add(_people);
  }
}
