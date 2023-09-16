import 'package:flutter/material.dart';
import 'package:user/constants/app.routes.dart';
import 'package:user/constants/constant.dart';
import 'package:user/constants/enums.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key? key,
    required this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color(0xFF070000);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.home,
                color: MenuState.home == selectedMenu
                    ? kPrimaryColor
                    : inActiveIconColor,
              ),
              onPressed: () =>
                  Navigator.pushNamed(context, homeRoute),
            ),
            IconButton(
              icon: Icon(
                Icons.medical_services, // You can replace this with an appropriate icon
                color: MenuState.remedy == selectedMenu
                    ? kPrimaryColor
                    : inActiveIconColor,
              ),
              onPressed: () =>
                  Navigator.pushNamed(context, remedyRoute),
            ),
            IconButton(
              icon: Icon(
                Icons.search,
                color: MenuState.search == selectedMenu
                    ? kPrimaryColor
                    : inActiveIconColor,
              ),
              onPressed: () =>
                  Navigator.pushNamed(context, searchRoute),
            ),
            IconButton(
              icon: Icon(
                Icons.star, // You can replace this with an appropriate icon
                color: MenuState.reviews == selectedMenu
                    ? kPrimaryColor
                    : inActiveIconColor,
              ),
              onPressed: () =>
                  Navigator.pushNamed(context, reviewsRoute),
            ),
            IconButton(
              icon: Icon(
                Icons.library_books, // You can replace this with an appropriate icon
                color: MenuState.library == selectedMenu
                    ? kPrimaryColor
                    : inActiveIconColor,
              ),
              onPressed: () =>
                  Navigator.pushNamed(context, libraryRoute),
            ),
          ],
        ),
      ),
    );
  }
}
