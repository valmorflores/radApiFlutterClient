// sample: https://www.youtube.com/watch?v=i7O5T4V59HI

import 'dart:async';
import 'dart:math';

import 'package:dartz/dartz_unsafe.dart';
import '/core/widgets/_widget_staff_avatar.dart';
import '/modules/messages/domain/entities/message_room_result.dart';
import '/modules/messages/infra/models/message_conversation_model.dart';
import '/modules/messages/infra/models/message_room_model.dart';
import '/modules/messages/presenter/controllers/message_controller.dart';
import '/modules/messages/presenter/fake/data_fake.dart';
import '/modules/messages/presenter/message_conversation_rooms.dart';
import '/modules/staff/presenter/controllers/staff_controller.dart';
import '/modules/staff/presenter/staff_profile_editor/staff_profile_editor.dart';
import '/utils/globals.dart';
import '/core/widgets/_widget_page_title.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '_widget_message_in.dart';
import '_widget_message_out.dart';

// This is the type used by the popup menu below.
enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

class MessageConversationHome extends StatefulWidget {
  MessageRoomResult messageRoom;

  MessageConversationHome({
    Key? key,
    required this.messageRoom,
  }) : super(key: key);

  @override
  _MessageConversationHomeState createState() =>
      _MessageConversationHomeState();
}

class _MessageConversationHomeState extends State<MessageConversationHome> {
  MessageController messageController = Get.put(MessageController());
  StaffController _staffController = Get.put(StaffController());

  late Size _size;

  final GlobalKey<AnimatedListState> _key = GlobalKey();
  DataFake? data;
  late List<MessageConversationModel> _items;
  late TextEditingController _text;
  ScrollController _scrollController = ScrollController();

  late WhyFarther _selection;

  late Timer _timer;

  _scrollToBottom() {
    // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
  }

  @override
  void initState() {
    super.initState();
    _text = TextEditingController();
    data = DataFake(conversation: []);
    data!.loadData();
    data!.getData();
    _items = data!.getData();
    // Controller
    messageController.setRoom(widget.messageRoom as MessageRoomModel);
    messageController.setRoomTitle(title: '${widget.messageRoom.title}');
    messageController.loadConversation(1);
    messageController.messageList.forEach((element) {
      debugPrint('f7872 - :: ${(element as MessageConversationModel).message}');
    });
    // --
    //WidgetsBinding.instance!.addPostFrameCallback((_) => _scrollToBottom());

    // Verifica mensagens a cada 5 segundos
    const oneSec = const Duration(seconds: 5);
    _timer = Timer.periodic(oneSec, (Timer t) => _showNewMessages());

    _staffController.loadStaffList();
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  // Analise if pageController in page to exit the module
  // Back in conversation, return to ROOMs list
  // if Desktop, back is to close the module (_result=true)
  Future<bool> _onClosePressed() async {
    bool _result = false;
    if (_size.width > 1024) {
      _result = true;
    } else {
      if (messageController.pageController.page == 0) {
        _result = true;
      } else {
        messageController.pageController.jumpToPage(0);
        _result = false;
      }
    }
    return _result;
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: _onClosePressed,
        child: Scaffold(
          appBar: _buildAppBar(),
          body: (_size.width >= 1024) ? _layoutDesktop() : _layoutMobile(),
        ));
  }

  _layoutDesktop() {
    return Row(
      children: [
        MessageConversationRooms(),
        Flexible(child: _activeRoom()),
      ],
    );
  }

  _activeRoom() {
    return Obx(() => Column(children: [
          WidgetPageTitle(
            title: 'Conversa',
            workspace: app_selected_workspace_name,
            onTap: () {
              messageController
                  .loadConversation(messageController.roomSelectedId.value);
            },
            context: context,
          ),
          Text('0 mensagens não lidas ${messageController.count}'),
          Expanded(flex: 1, child: messageShow()),
          _buildNewMessageBox()
        ]));
  }

  _layoutMobile() {
    return Obx(() => PageView(
          controller: messageController.pageController,
          children: [
            MessageConversationRooms(),
            _activeRoom(),
            // Existe a Terceira janela somente um observavel,
            // pois ADICIONADO PARA GetX responder. Colocar em
            // um modulo e dispositivo para fazer uma chamada
            // por exemplo. ou exibir a camera, vamos ver.
            // Por enquanto está só para resolver o Obx la de cima
            // que neste modo (MOBILE) serve para atender a marcação
            // de uma conversa e atualização da mesma na _activeRoom()
            Text('0 mensagens não lidas ${messageController.count}'),
          ],
        ));
  }

  _layoutMobile2() {
    return PageView(
      children: [
        MessageConversationRooms(),
        Column(
          children: [
            WidgetPageTitle(
              title: 'Conversa',
              workspace: app_selected_workspace_name,
              onTap: () {},
              context: context,
            ),
            Expanded(flex: 1, child: messageShow()),
            _buildNewMessageBox()
          ],
        )
      ],
    );
  }

  Widget messageShow() {
    //debugPrint(
    //    'f7941 - Message and items ${messageController.messageList.length.toString()}');
    List<MessageConversationModel> listItem = [];
    messageController.messageList.forEach((element) {
      element.index = 0;
      listItem.add(element);
    });

    List<Widget> _lista = [];
    int index = 0;

    int i = 0;

    listItem.forEach((element) {
      if (element.message != null) {
        if (element.memberId == app_user.staffid) {
          _lista.add(MessageOut(
            item: element,
            index: i,
          ));
        } else {
          _lista.add(MessageIn(
            item: element,
            index: i,
          ));
        }
      }
      ++i;
    });
    return ListView(key: _key, controller: _scrollController, children: _lista);
  }

  Widget _buildNewMessageBox() {
    return Container(
        margin: EdgeInsets.all(8),
        height: 100,
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: TextField(
                  //autofocus: true,
                  maxLines: 99,
                  controller: _text,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Digite uma mensagem aqui'),
                )),
            Column(
              children: [
                GestureDetector(
                  child: Icon(Icons.arrow_downward),
                  onTap: () {
                    _goDown();
                  },
                ),
                const Spacer(),
                Row(
                  children: [
                    GestureDetector(
                        child: Transform.rotate(
                            angle: -pi / 4, child: Icon(Icons.attach_file)),
                        onTap: () {
                          debugPrint('f7870 - action: Attachment into message');
                          // todo:
                        }),
                    GestureDetector(
                        child: CircleAvatar(
                          child: Icon(Icons.send, size: 32),
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onSecondary,
                        ),
                        onTap: () {
                          setState(() {
                            debugPrint('f7872 - Send message - ${_text.text}');
                            sendMessage(message: _text.text);
                            _text.text = '';
                          });
                        }),
                  ],
                )
              ],
            )
          ],
        ));
  }

  sendMessage({required String message}) {
    _addItem(message: message);
  }

  _addItem({required String message}) {
    int i = messageController.messageList.isNotEmpty
        ? messageController.messageList.length
        : 0;
    MessageConversationModel _message = MessageConversationModel(
        cid: messageController.messageRoom.id ??
            messageController.roomSelectedId.value,
        message: message,
        memberId: app_user.staffid);
    messageController.addMessage(_message);

    //_key.currentState?.insertItem(i);
    _goDown();
  }

  _goDown() {
    Timer(
      const Duration(milliseconds: 400),
      () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 50),
          curve: Curves.ease,
        );
      },
    );
  }

  _showNewMessages() async {
    bool lChanged = false;
    debugPrint('f7740 - getting new messages, if exists');
    List<MessageConversationModel> _messageNewsList =
        await messageController.getMessageNews();
    _messageNewsList.forEach((e) {
      if (e.message == messageController.messageList.last.message) {
      } else {
        MessageConversationModel _message = MessageConversationModel(
            cid: messageController.messageRoom.id ??
                messageController.roomSelectedId.value,
            id: e.id,
            message: e.message,
            memberId: e.memberId /*app_user.staffid*/);
        messageController.messageList.add(_message);
        lChanged = true;
      }
    });
    if (lChanged) {
      _goDown();
      messageController.removeZeradas();
    }
  }

  _buildAppBar() {
    Widget _widget = Obx(
      () => Stack(children: [
        Visibility(
          child: Text(
            '${messageController.roomTitle.value}',
          ),
          visible: false,
        ),
        Container(
            width: 48,
            height: 48,
            child: WidgetStaffAvatar(
                shape: BoxShape.circle,
                width: 32,
                height: 32,
                urlImage: _staffController.getImageUrlByStaffId(((app_user
                            .staffid ==
                        (messageController.messageRoom as MessageRoomModel)
                            .user1)
                    ? (messageController.messageRoom as MessageRoomModel).user2
                    : (messageController.messageRoom as MessageRoomModel)
                        .user1))))
      ]),
    );
    return AppBar(
        title: Row(
          children: [
            // Avatar
            Container(width: 48, height: 48, child: _widget),
            SizedBox(
              width: 20,
            ),
            Obx(() =>
                Flexible(child: Text('${messageController.roomTitle.value}')))
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.phone)),
          IconButton(
            onPressed: () {
// This menu button widget updates a _selection field (of type WhyFarther,
// not shown here).
            },
            icon: const Icon(Icons.menu),
          ),
          _menuPopUp(),
        ]);
  }

  _menuPopUp() {
    return PopupMenuButton<WhyFarther>(
      onSelected: (WhyFarther result) {
        setState(() async {
          _selection = result;
          if (_selection == WhyFarther.harder) {
            await showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                context: context,
                builder: (BuildContext context) {
                  return StaffProfileEditor(((app_user.staffid ==
                          (messageController.messageRoom as MessageRoomModel)
                              .user1)
                      ? (messageController.messageRoom as MessageRoomModel)
                          .user2
                      : (messageController.messageRoom as MessageRoomModel)
                          .user1));
                });
          }
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<WhyFarther>>[
        const PopupMenuItem<WhyFarther>(
          value: WhyFarther.harder,
          child: Text('Editar este perfil'),
        ),
      ],
    );
  }

  Widget _buildItem(
      MessageConversationModel item, Animation<double> animation, int index) {
    if (item.memberId! > 0) {
      return MessageIn(item: item, index: index);
    } else {
      return MessageOut(item: item, index: index);
    }
  }
}
