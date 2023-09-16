import 'package:flutter/widgets.dart';
import 'package:user/screens/home/home.page.dart';
import 'package:user/screens/library/library.screen.dart';
import 'package:user/screens/plan/plan.welcome.screen.dart';
import 'package:user/screens/review/reviews.screen.dart';
import 'package:user/screens/search/search.screen.dart';
import 'package:user/screens/settings/settings.screen.dart';

// Define your route names as constants
const String homeRoute = '/home';
const String remedyRoute = '/remedy';
const String searchRoute = '/search';
const String reviewsRoute = '/reviews';
const String libraryRoute = '/library';
const String settingsRoute = '/settings';

// Create a Map of routes
final Map<String, WidgetBuilder> userAppRoutes = {
  homeRoute: (context) => HomeScreen(),
  remedyRoute: (context) => RemedyScreen(),
  searchRoute: (context) => SearchScreen(),
  reviewsRoute: (context) => ReviewsScreen(),
  libraryRoute: (context) => LibraryPage(),
  settingsRoute: (context) => SettingsScreen(),
};
