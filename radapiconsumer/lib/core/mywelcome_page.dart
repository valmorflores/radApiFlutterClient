import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:radapiconsumer/core/myhome_page.dart';
import 'package:radapiconsumer/core/mylogin_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modules/user/presenter/user_login/user_login_page.dart';

class MyWelcomePage extends StatefulWidget {
  const MyWelcomePage({super.key});

  @override
  State<MyWelcomePage> createState() => _MyWelcomePageState();
}

class _MyWelcomePageState extends State<MyWelcomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verificaToken().then((value) => {
          if (value)
            {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyHomePage(title: 'Bem vindo!')))
            }
          else
            {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => UserLoginPage(0)))
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: CircularProgressIndicator(),
    ));
  }

  Future<bool> verificaToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return (sharedPreferences.getString('token') != null);
  }
}
