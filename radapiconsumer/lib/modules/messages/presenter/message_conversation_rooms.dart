import '/modules/messages/domain/entities/message_room_result.dart';
import '/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/modules/messages/infra/models/message_room_model.dart';
import '/modules/messages/presenter/controllers/message_controller.dart';

import 'models/message_room_list_model.dart';

class MessageConversationRooms extends StatefulWidget {
  MessageConversationRooms({Key? key}) : super(key: key);

  @override
  _MessageConversationRoomsState createState() =>
      _MessageConversationRoomsState();
}

class _MessageConversationRoomsState extends State<MessageConversationRooms> {
  MessageController _messageController = Get.put(MessageController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadRooms();
    _messageController.selectFirstRoom();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        'f8787 - Rooms ${_messageController.roomList.length.toString()}');
    return Container(
      alignment: Alignment.topLeft,
      width: MediaQuery.of(context).size.width / 3,
      child: SingleChildScrollView(
          child: Obx(() => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                      child: Container(
                        width: MediaQuery.of(context).size.width > 1024
                            ? MediaQuery.of(context).size.width / 3
                            : MediaQuery.of(context).size.width,
                        color: Colors.black26,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 14, 8, 14),
                          child: Text('Conversas, pessoas e grupos'),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          debugPrint(
                              'f8488 - Load room list action / count: ${_messageController.count}');
                          _loadRooms();
                        });
                      }),
                  ..._listItems(),
                ],
              ))),
    );
  }

  _loadRooms() async {
    await _messageController.loadRooms();
    debugPrint(
        'f8940 - total of enabled rooms after load: ${_messageController.roomList.length.toString()} ');
  }

  Widget _showRoomItem(MessageRoomListModel item) {
    return Obx(() => Card(
        color: item.cid == _messageController.roomSelectedId.value
            ? Colors.lightBlue
            : null,
        child: ListTile(
          title: Text(item.title),
          subtitle: Text(item.subtitle),
          onTap: () async {
            int _cid = item.cid;
            if (_cid <= 0) {
              int _user = 0;
              _user =
                  (item.user1 == app_user.staffid) ? item.user2 : item.user1;
              _cid =
                  await _messageController.startNewOrGetConversationId(_user);
              debugPrint(
                  'f8940 - Start new room: ${_cid} users: [${app_user.staffid} x $_user]');
            } else {
              debugPrint('f8940 - Selected room: ${item.cid}');
            }
            _messageController.setRoom(MessageRoomModel(
              id: _cid,
              user1: item.user1,
              user2: item.user2,
              membersId: [item.user1, item.user2],
              isContact: false,
              type: item.type,
              title: item.title,
            ));
            _messageController.setRoomTitle(title: '${item.title}');
            _messageController.selectRoom(_cid);
            _messageController.loadConversation(_cid);
            if (MediaQuery.of(context).size.width < 1024) {
              _messageController.pageController.jumpToPage(1);
            }
            //Navigator.of(context).pushNamed(kRouteMessages, arguments: _roomModel);
          },
        )));
  }

  List<Widget> _listItems() {
    debugPrint('f8488 - ${_messageController.roomList.length}');
    List<Widget> _rooms = [];
    _messageController.roomList.forEach((element) {
      _rooms.add(_showRoomItem(element));
    });
    return _rooms;
  }
}
