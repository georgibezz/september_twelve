import 'package:flutter/material.dart';
import 'package:user/components/bottom.nav.bar.dart';
import 'package:user/constants/enums.dart';
import 'package:user/screens/home/components/body.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}