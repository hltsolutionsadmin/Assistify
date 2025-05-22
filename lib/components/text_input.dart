import 'package:assistify/core/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final Widget? prefixIcon;
  final ValueChanged<String>? onChanged;
  final String? label;
  final double fieldHeight;
  final bool isPassword;
  final bool showPasswordToggle;
  final String? hintText;
  final bool showError;

  const CustomTextField({
    super.key,
    required this.controller,
    this.prefixIcon,
    this.onChanged,
    this.label,
    this.fieldHeight = 70,
    this.isPassword = false,
    this.showPasswordToggle = true,
    this.hintText,
    this.showError = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    widget.controller.addListener(() {
      final hasText = widget.controller.text.isNotEmpty;
      if (_hasText != hasText) {
        setState(() => _hasText = hasText);
      }
    });
  }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color, width: 1.4),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    if (widget.showError && !_hasText) {
      borderColor = AppColor.red;
    } else if (_hasText) {
      borderColor = AppColor.blue;
    } else {
      borderColor = AppColor.gray;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              widget.label!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        SizedBox(
          height: widget.fieldHeight,
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.isPassword ? _obscureText : false,
            decoration: InputDecoration(
              isDense: true,
              hintText: widget.hintText,
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.isPassword && widget.showPasswordToggle
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 12,
              ),
              enabledBorder: _buildBorder(borderColor),
              focusedBorder: _buildBorder(AppColor.blue),
              errorBorder: _buildBorder(AppColor.red),
              focusedErrorBorder: _buildBorder(AppColor.red),
            ),
            onChanged: widget.onChanged,
          ),
        ),
        if (widget.showError && !_hasText)
           Padding(
            padding: EdgeInsets.only(top: 4, left: 4),
            child: Text(
              'This field is required',
              style: TextStyle(color: AppColor.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
