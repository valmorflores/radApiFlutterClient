import '../../core/application.dart';
import '../../modules/messages/domain/entities/message_room_result.dart';
import '../../modules/messages/presenter/message_conversation_home.dart';
import '../../modules/setup/presenter/setup_const.dart';
import '../../modules/setup/presenter/setup_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../constants/kroutes.dart';
import '../myhome_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    // Special routes (with more complex parameters)
    List<String> pathComponents = settings.name!.split('/');
    if (pathComponents.contains(kRouteInvite)) {
      // Desmembrar os argumentos com base no path enviado

      debugPrint('f1725 - route: /invite');
      String setupInviteKey = '';
      var arguments = pathComponents;
      debugPrint('f1725 - ' + arguments.toString());
      if (arguments[2] == 'key') {
        setupInviteKey = arguments[3];
      }
      return MaterialPageRoute(
          builder: (context) => SetupMain(
                start: STEP_YOU_ARE_INVITED,
                params: setupInviteKey,
              ));
    }

    // Convencional routes
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => const MyHomePage(
                  title: '',
                ));
      case kRouteMessages:
        if (args is MessageRoomResult) {
          return MaterialPageRoute(
              builder: (_) => MessageConversationHome(
                    messageRoom: args,
                  ));
        }
        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Erro'),
        ),
        body: const Center(child: Text('Erro ao acessar rota')),
      );
    });
  }
}
