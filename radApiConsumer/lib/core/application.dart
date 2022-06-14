import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/core/helpers/route_generator.dart';
import '/routes.dart';
import '../utils/themes/system_theme_data.dart';
import 'myhome_page.dart';
import 'mywelcome_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      routes: Routes.routes,
      title: 'RadApi Client',
      debugShowCheckedModeBanner: false,
      theme: SystemThemeData.lightThemeData1,
      //darkTheme: SystemThemeData.darkThemeData1,
      themeMode: ThemeMode.system,
      onGenerateRoute: RouteGenerator.generateRoute,
      home: const DefaultTabController(length: 4, child: MyWelcomePage()),
    );
  }
}
