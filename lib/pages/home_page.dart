import 'package:flutter/material.dart';
//import 'package:fitnessapp/widgets/app_icon.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text(
//          ' ', //'Home'
//          style: TextStyle(
//            color: Colors.black,
//            fontSize: 18,
//            fontWeight: FontWeight.bold
//          ),
//        ),
//        backgroundColor: Colors.grey[700],
//        centerTitle: true,
//      ),
//    );
//  }
//}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //  appBar: AppBar(
    //    backgroundColor: Colors.grey[700],
    //    centerTitle: true,
    //    leading: IconButton(
    //      icon: const AppIcon(
    //        materialIcon: Icons.menu,
    //        svgPath: 'assets/icons/menu.svg',
    //        useCustom: false, // set to true later to use your custom svg
    //        color: Colors.white,
    //      ),
    //      onPressed: () {
    //        // example: open a drawer or show a message
    //        ScaffoldMessenger.of(context).showSnackBar(
    //          const SnackBar(content: Text("Menu clicked")),
    //        );
    //      },
    //    ),
    //    title: const Text(
    //      'Home',
    //      style: TextStyle(
    //        color: Colors.black,
    //        fontSize: 18,
    //        fontWeight: FontWeight.bold,
    //      ),
    //    ),
    //    actions: [
    //      IconButton(
    //        icon: const AppIcon(
    //          materialIcon: Icons.settings,
    //          svgPath: 'assets/icons/settings.svg',
    //          useCustom: false,
    //          color: Colors.white,
    //        ),
    //        onPressed: () {
    //          // navigate to settings or perform action
    //        },
    //      ),
    //    ],
    //  ),
    body: Center(
      child: Text('Home Page Content'),
    ),
    );
  }
}
