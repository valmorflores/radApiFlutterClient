import '/modules/user/presenter/controllers/user_controller.dart';
import '/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserLoginPage extends StatelessWidget {
  final UserController _userController = Get.put(UserController());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final int staffid;
  UserLoginPage(this.staffid, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _emailController.text = 'valmorflores@gmail.com';
    _passwordController.text = '';

    return Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height * 0.60,
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.background),
            child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Container(
                              height: 200,
                              child: ListView(
                                children: [
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  ListTile(
                                    title: Text(
                                      'Dados pessoais em ${app_selected_workspace_name}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: const Text(
                                      'As informações a seguir aparecerão específicamente neste ambiente. Para cada workspace você pode se identificar como preferir.',
                                      style: TextStyle(fontSize: 11),
                                    ),
                                  ),
                                  ListTile(
                                    title: const Text(
                                      'Usuário/Login',
                                      style: TextStyle(fontSize: 11),
                                    ),
                                    subtitle: TextField(
                                      controller: _emailController,
                                      decoration: InputDecoration(
                                        suffixIcon: Icon(
                                          Icons.search,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                          size: 20.0,
                                        ),
                                        border: InputBorder.none,
                                        hintText: 'Filtro',
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    title: const Text(
                                      'Senha',
                                      style: TextStyle(fontSize: 11),
                                    ),
                                    subtitle: TextField(
                                      controller: _passwordController,
                                      obscureText: true,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      
                                    ),
                                  ),
                                ],
                              ))),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(children: [
                          const Spacer(),
                          FloatingActionButton(
                            onPressed: () async {
                              await _userController.userPostLogin(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.check),
                          )
                        ]),
                      )
                    ]))));
  }
}
