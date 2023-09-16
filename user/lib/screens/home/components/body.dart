import 'package:flutter/material.dart';
import 'package:user/constants/size_config.dart';
import 'package:user/screens/home/components/home.screen.header.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(20)), // Adjust as needed
            HomeHeader(), // Replace with your Home Header widget

          ],
        ),
      ),
    );
  }
}