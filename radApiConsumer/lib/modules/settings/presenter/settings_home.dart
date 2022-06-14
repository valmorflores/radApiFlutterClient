import '/utils/themes/system_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings_advanced_help_assistent.dart';

class SettingsHome extends StatefulWidget {
  @override
  _SettingsHomeState createState() => _SettingsHomeState();
}

class _SettingsHomeState extends State<SettingsHome> {
  String _theme_mode = '';
  String _theme_color = '';
  bool _isDarkMode = false;

  Future<String> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _theme_mode = prefs.getString('theme')!;
    if (_theme_mode == '2') {
      _isDarkMode = true;
    } else {
      _isDarkMode = false;
    }
    return _theme_mode;
  }

  Future<String> getThemeColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _theme_color = (await prefs.getString('theme_color')!);
    debugPrint('f7458 - getThemeColor = ${_theme_color}');
    return _theme_color;
  }

  @override
  initState() {
    super.initState();
    _loadParams();
  }

  _loadParams() async {
    // defaults
    _theme_mode = (await getTheme());
    _theme_color = (await getThemeColor());
    // First time run, color 1, theme 1
    if (_theme_color == null) {
      _theme_color = '1';
      _setThemeColor(_theme_color);
    }
    if (_theme_mode == null) {
      _theme_mode = '1';
      _setTheme(_theme_mode);
    }
    if (_theme_mode == '2') {
      setState(() {
        _isDarkMode = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Configurações')),
        body: Container(
          color: Theme.of(context).colorScheme.background,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: ListTile(
                title: Row(children: [
                  Text('Aparência'),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 12, 0),
              child: SwitchListTile(
                  title: Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 12, 12, 0),
                      child: Text('Modo escuro')),
                  value: _isDarkMode,
                  onChanged: (bool value) {
                    setState(() {
                      if (value) {
                        _setTheme('2');
                      } else {
                        _setTheme('1');
                      }
                    });
                  }
                  /*onTap: () {
                            
                          },
                        ),
                      ),
                            _setTheme('2'); */
                  ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 12, 0, 0),
              child: ListTile(
                //color: Theme.of(context).colorScheme.background,
                //elevation: 0,
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 0, 12, 0),
                  child: Row(children: [
                    Text('Tema'),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(45)),
                            color: _theme_color == '1'
                                ? Theme.of(context).colorScheme.onPrimary
                                : Colors.transparent,
                          ),
                          width: 32,
                          height: 32,
                          child: Icon(Icons.circle, color: Colors.pink),
                        ),
                        onTap: () {
                          setState(() {
                            _setThemeColor('1');
                          });

                          /*final snackBar =
                              SnackBar(content: Text('Cor 1 selecionada'));
                          Scaffold.of(context).showSnackBar(snackBar);*/
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(45)),
                            color: _theme_color == '2'
                                ? Theme.of(context).colorScheme.onPrimary
                                : Colors.transparent,
                          ),
                          width: 32,
                          height: 32,
                          child: Icon(Icons.circle, color: Colors.blueAccent),
                        ),
                        onTap: () {
                          setState(() {
                            _setThemeColor('2');
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(45)),
                            color: _theme_color == '3'
                                ? Theme.of(context).colorScheme.onPrimary
                                : Colors.transparent,
                          ),
                          width: 32,
                          height: 32,
                          child: Icon(Icons.circle, color: Colors.green),
                        ),
                        onTap: () {
                          _setThemeColor('3');
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(45)),
                            color: _theme_color == '0'
                                ? Theme.of(context).colorScheme.onPrimary
                                : Colors.transparent,
                          ),
                          width: 32,
                          height: 32,
                          child: Icon(Icons.circle, color: Colors.blueGrey),
                        ),
                        onTap: () {
                          setState(() {
                            _setThemeColor('0');
                          });
                        },
                      ),
                    ),
                  ]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: ListTile(
                title: Row(children: [
                  Text('Idioma'),
                  const Spacer(),
                  Text('Português do Brasil')
                ]),
              ),
            ),
          ]),
        ));
  }

  void _setTheme(String _theme_) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_theme_ == '1') {
      await prefs.setString('theme', '1');
      //ThemeMode.light;
      setState(() {
        //Get.changeThemeMode(ThemeMode.light);
      });
    } else if (_theme_ == '2') {
      await prefs.setString('theme', '2');
      //ThemeMode.dark;
      setState(() {
        //Get.changeThemeMode(ThemeMode.dark);
      });
    } else {
      //await prefs.setString('theme', '0');
      setState(() {
        //Get.changeThemeMode(ThemeMode.system);
      });
    }

    _setThemeColor(_theme_color);
    await getTheme();
  }

  void _setThemeColor(String _setThemeColor) async {
    _theme_color = _setThemeColor;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_color', _setThemeColor);
    debugPrint(
        'f7459 - themeColor: ${_setThemeColor} themeMode: ${_theme_mode}');
    if (_setThemeColor == '1') {
      setState(() {
        if (_theme_mode == '1') {
          Get.changeTheme(SystemThemeData.lightThemeData1);
          //Get.changeThemeMode(ThemeMode.light);
        } else {
          Get.changeTheme(SystemThemeData.darkThemeData1);
          //Get.changeThemeMode(ThemeMode.dark);
        }
      });
    } else if (_setThemeColor == '2') {
      setState(() {
        if (_theme_mode == '1') {
          Get.changeTheme(SystemThemeData.lightThemeData2);
          //Get.changeThemeMode(ThemeMode.light);
        } else {
          Get.changeTheme(SystemThemeData.darkThemeData2);
          //Get.changeThemeMode(ThemeMode.dark);
        }
      });
    } else if (_setThemeColor == '3') {
      setState(() {
        if (_theme_mode == '1') {
          Get.changeTheme(SystemThemeData.lightThemeData3);
          //Get.changeThemeMode(ThemeMode.light);
        } else {
          Get.changeTheme(SystemThemeData.darkThemeData3);
          //Get.changeThemeMode(ThemeMode.dark);
        }
      });
    } else {
      setState(() {
        if (_theme_mode == '1') {
          Get.changeTheme(SystemThemeData.lightThemeData0);
          //Get.changeThemeMode(ThemeMode.light);
        } else {
          Get.changeTheme(SystemThemeData.darkThemeData0);
          //Get.changeThemeMode(ThemeMode.dark);
        }
      });
    }
    // getThemeColor();
  }
}
