import 'package:flutter/material.dart';
import 'package:money_management/models/breakdowns.dart';
import 'package:money_management/pages/home_page.dart';
import 'package:money_management/theme/theme.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Breakdowns>(create: (_) => Breakdowns())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Money Management',
        theme: appThemeDark,
        home: HomePage(),
      ),
    );
  }
}
