import 'package:flutter/material.dart';

void main() {

  runApp( MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffffbf65),
          title: const Text('Test Menu Page'),
        ),
        body: ListView.builder(
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            return ListTile (
              leading: const Icon(Icons.food_bank),
              title: Text('List item $index'),
              trailing: const Text('See more')
            );
          },
        ),
      ), 
    );
      


  }
}