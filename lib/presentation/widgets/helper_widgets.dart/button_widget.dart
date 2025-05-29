import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildButton({
  required String text,
  IconData? icon,
  void Function()? handleAction,
  bool? isLoading,
  bool? color,
  bool? error, // New optional parameter
}) {
  print(isLoading);
  bool isError = error == true;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isError ? null : handleAction, // Disable if error is true
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
              colors: isError || color == true
                  ? [Colors.grey, Colors.grey]
                  : [Colors.blue, Colors.lightBlueAccent],
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
                if (icon != null) Icon(icon, color: Colors.white),
                if (icon != null && isLoading != true) SizedBox(width: 8),
                isLoading == true
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CupertinoActivityIndicator(color: Colors.white),
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
