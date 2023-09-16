import 'package:flutter/material.dart';
import 'package:user/constants/size_config.dart';
import 'package:user/components/home.screen.header.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialize SizeConfig
    SizeConfig().init(context);

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            HomeHeader(),
            // Add other widgets/components specific to your home screen here
          ],
        ),
      ),
    );
  }
}
