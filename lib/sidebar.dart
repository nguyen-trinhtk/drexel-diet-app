import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

import 'userpage.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xffffbf65),
            ),
            child: Text("Menu",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          Builder(
            builder: (context) => GFButton(
              onPressed: () {
                var route = ModalRoute.of(context);
                if (route != null) {
                  var routeName = route.settings.name;
                  if (routeName != "/UserPage") {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        settings: RouteSettings(name: "/UserPage"),
                        builder: (context) => const UserPage( )),
                  );
                  }
                }
              },
              text: "Go to User Page",
              fullWidthButton: true,
            ),
          ),
        ],
      ),
    );
  }
}