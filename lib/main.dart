import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/controllers/controller.dart';
import 'package:responsive_admin_dashboard/screens/dash_board_screen.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => Controller(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Tiago Iphones',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: DashBoardScreen());
  }
}
