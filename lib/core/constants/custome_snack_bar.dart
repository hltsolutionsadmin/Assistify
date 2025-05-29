import 'package:assistify/core/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomSnackbars {
  static void showSuccessSnack({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    showSnackBar(
      context: context,
      title: title,
      message: message,
      backgroundColor: AppColor.green,
      textColor: AppColor.white,
    );
  }

  static void showErrorSnack({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    showSnackBar(
      context: context,
      title: title,
      message: message,
      backgroundColor: AppColor.red,
      textColor: AppColor.black,
    );
  }

  static void showInfoSnack({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    showSnackBar(
      context: context,
      title: title,
      message: message,
      backgroundColor: AppColor.white,
      textColor: AppColor.black,
    );
  }

  static void showSnackBar({
    required BuildContext context,
    required String title,
    required String message,
    required Color backgroundColor,
    required Color textColor,
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 60,
        left: 10,
        right: 10,
        child: Material(
          color: Colors.transparent,
          child: FadeTransition(
            opacity: getAnimation(context) ?? const AlwaysStoppedAnimation(1.0),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent:
                    getAnimation(context) ?? const AlwaysStoppedAnimation(1.0),
                curve: Curves.easeOut,
              )),
              child: ShakeTransition(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                  
                    gradient: LinearGradient(
                      colors: [
                        backgroundColor.withOpacity(1),
                        backgroundColor.withOpacity(1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: textColor,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: textColor,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              message,
                              style: TextStyle(color: textColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  static Animation<double>? getAnimation(BuildContext context) {
    final route = ModalRoute.of(context);
    if (route == null || route.animation == null) {
      return null;
    }
    return route.animation;
  }
}

class ShakeTransition extends StatefulWidget {
  final Widget child;

  const ShakeTransition({super.key, required this.child});

  @override
  _ShakeTransitionState createState() => _ShakeTransitionState();
}

class _ShakeTransitionState extends State<ShakeTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    _shakeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.01, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _shakeAnimation,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
