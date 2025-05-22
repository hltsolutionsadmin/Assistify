import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildButton({
  required String text,
  IconData? icon,
  handleAction,
  bool? isLoading,
  Color? color,
}) {
  print(isLoading);
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: handleAction,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          elevation: 4,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.blue.withOpacity(0.5),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent],
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Container(
            alignment: Alignment.center,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white),
                isLoading == true
                    ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CupertinoActivityIndicator(color: Colors.white)
                    )
                    : Text(
                      text,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
