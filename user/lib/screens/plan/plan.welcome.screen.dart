import 'package:flutter/material.dart';
import 'package:user/components/bottom.nav.bar.dart';
import 'package:user/components/home.screen.header.dart';
import 'package:user/constants/enums.dart';
import 'package:user/constants/size_config.dart';
import 'package:user/screens/plan/components/setup.dart';

class RemedyScreen extends StatefulWidget {
  @override
  _RemedyScreenState createState() => _RemedyScreenState();
}

class _RemedyScreenState extends State<RemedyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: getProportionateScreenHeight(20)),
              HomeHeader(), // Add the HomeHeader here
              RemedySetup(), // Add the RemedySetup as the body
              // Other content of your Remedy screen
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.remedy),
    );
  }
}
