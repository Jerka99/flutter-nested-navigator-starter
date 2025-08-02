import 'package:flutter/material.dart';

import '../async_redux/connectors/details_page_connector.dart';
import '../async_redux/connectors/login_page_connector.dart';
import '../async_redux/connectors/profile_connector.dart';
import '../pages/first_page.dart';
import 'app_routes_config.dart';

final List<RouteConfig> securedRoutes = [
  RouteConfig(
    path: "home",
    child: FirstPage(),
    icon: Icons.home,
    children: [
      RouteConfig(
        path: 'details',
        child: DetailsPageConnector(),
        children: [
          RouteConfig(path: 'about', child: ProfileWidgetConnector()),
        ],
      ),
    ],
  ),
  RouteConfig(
    path: "nothing",
    child: ProfileWidgetConnector(),
    icon: Icons.person,
    children: [RouteConfig(path: 'details', child: DetailsPageConnector())],
  ),
];
final List<RouteConfig> unsecuredRoutes = [
  RouteConfig(
    path: "/",
    child: LoginPageConnector(),
    children: [
      RouteConfig(
        path: "profile",
        child: ProfileWidgetConnector(),
        icon: Icons.person,
        children: [
          RouteConfig(
            path: 'details',
            child: DetailsPageConnector(),
            children: [
              RouteConfig(
                path: ':id',
                child: Scaffold(body: Container(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
    ],
  ),
];
