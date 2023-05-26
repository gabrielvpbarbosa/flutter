import 'package:flutter/material.dart';
import 'package:ola_mundo/app_controller.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int counter = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
          child: Switch(
              value: AppController.instance.isDartTheme,
              onChanged: (value) {
                AppController.instance.changeTheme();
              })),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          setState(() {
            counter++;
          });
        },
      ),
    );
  }
}
// Center(
//           child: GestureDetector(
//         child: Text(
//           'Contador: $counter',
//           style: TextStyle(fontSize: 20),
//         ),
//         onTap: () {
//           setState(() {
//             counter++;
//           });
//         },
//       )),