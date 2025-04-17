import 'package:fitnessapp/models/profile.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  //const ProfilePage({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Profile demoProfile = Profile(
      name: "Diana", 
      age: 30, 
      email: "dmal@gmail.com",
    );   

    return Scaffold(
  //    appBar: AppBar(
  //      title: Text(
  //        'Profile',
  //        style: TextStyle(
  //          color: Colors.black,
  //          fontSize: 18,
  //          fontWeight: FontWeight.bold
  //        ),
  //      ),
  //      backgroundColor: Colors.grey[700],
  //      centerTitle: true,
  //      leading: Container(
  //        margin: EdgeInsets.all(10),
  //        alignment: Alignment.center,
  //        decoration: BoxDecoration(
  //          color: Colors.grey[700],
  //          borderRadius: BorderRadius.circular(10)
  //        ),
  //        child: SvgPicture.asset('assets/icons/arrow_back.svg',
  //        height: 20,
  //        width: 20,
  //        ),
  //      ),
  //    )
  body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${demoProfile.name}'),
            Text('Age: ${demoProfile.age}'),
            Text('Email: ${demoProfile.email}'),
          ],
        ),
      ),
    );
  }
}
