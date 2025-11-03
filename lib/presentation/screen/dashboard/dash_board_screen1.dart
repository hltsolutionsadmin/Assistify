import 'package:assistify/core/constants/colors.dart';
import 'package:flutter/material.dart';

class DashBoardScreen1 extends StatefulWidget {
  const DashBoardScreen1({super.key});

  @override
  State<DashBoardScreen1> createState() => _DashBoardScreen1State();
}

class _DashBoardScreen1State extends State<DashBoardScreen1> {


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome !!'),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
      
      ),
      backgroundColor: AppColor.white,
      body: Stack(
        children: [
         
          
        ],
      ),
    );
  }
}
