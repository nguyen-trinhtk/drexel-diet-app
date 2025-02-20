import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class MenuPage extends StatelessWidget {
  const MenuPage ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffffbf65),
          title: const Text('Test Menu Page'),
          actions: [
            IconButton(
              icon: const Icon (Icons.close),
              onPressed: () {
              Navigator.pop(context);
})],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns in a row
              crossAxisSpacing: 10, // Space between columns
              mainAxisSpacing: 10, // Space between rows
              childAspectRatio: 1.5, // Adjust width/height ratio
            ),
          itemCount: 5, // Added item count
          itemBuilder: (BuildContext context, int index) {
            return GFCard(
                boxFit: BoxFit.cover,
                title: GFListTile(
                  title: Text('Food Name $index'),
                ),
                content: Text("Food Description"),
                buttonBar: GFButtonBar(
                  children: [
                    GFButton(
                      onPressed: () {},
                      text: 'See more',
                    ),
                  ],
                ),
              );
            },
            )
        ),
      ),
    );
  }
}
