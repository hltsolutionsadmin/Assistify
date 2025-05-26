  import 'dart:typed_data';

import 'package:flutter/material.dart';

Widget buildProfileImage(Uint8List? bytes) {
    if (bytes != null && bytes.isNotEmpty) {
      return Image.memory(bytes, width: 100, height: 100, fit: BoxFit.cover);
    } else {
      return const CircleAvatar(
        radius: 50,
        backgroundColor: Colors.blue,
        child: Icon(Icons.person, color: Colors.white, size: 50),
      );
    }
  }