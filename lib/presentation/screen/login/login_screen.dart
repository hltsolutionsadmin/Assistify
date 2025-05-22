import 'package:assistify/components/custome_text_field.dart';
import 'package:assistify/components/text_input.dart';
import 'package:assistify/core/constants/colors.dart';
import 'package:assistify/core/constants/imgs_const.dart';
import 'package:assistify/core/constants/sizes.dart';
import 'package:assistify/core/injection.dart';
import 'package:assistify/presentation/cubit/forgot_password/forgot_password_cubit.dart';
import 'package:assistify/presentation/cubit/login/logIn_cubit.dart';
import 'package:assistify/presentation/widgets/helper_widgets.dart/button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool errorEmail = false;
  bool errorPassword = false;
  bool forgotPassword = false;
  bool isFormValid = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    emailController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      if (forgotPassword) {
        isFormValid = emailController.text.isNotEmpty;
        errorEmail = emailController.text.isEmpty;
      } else {
        errorEmail = emailController.text.isEmpty;
        errorPassword = passwordController.text.isEmpty;
        isFormValid = !errorEmail && !errorPassword;
      }
    });
  }

  void _handleSubmit() async {
    _validateForm();
    if (!isFormValid) return;
    setState(() {
      isLoading = true;
    });

    try {
      if (forgotPassword) {
        final forgotPasswordCubit = context.read<ForgotPasswordCubit>();
        await forgotPasswordCubit.forgotPassword(
          context,
          emailController.text,
        );
      } else {
        final login = context.read<LoginCubit>();
        await login.logIn(
          context,
          emailController.text,
          passwordController.text,
        );
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    emailController.removeListener(_validateForm);
    passwordController.removeListener(_validateForm);
    emailController.dispose();
    passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginCubit>(),
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: getHeight(context) * 0.02),
              Image.asset(Logo),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    customTextField(
                      emailController,
                      forgotPassword ? 'Forgot Password' : 'Email',
                      errorText: errorEmail ? 'Please enter email' : null,
                      onChanged: (value) {
                        _validateForm();
                      },
                    ),
                    if (!forgotPassword)
                      customTextField(
                        passwordController,
                        'Password',
                        obscureText: true,
                        errorText: errorPassword ? 'Please enter Password' : null,
                        onChanged: (value) {
                          _validateForm();
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              buildButton(
                isLoading: isLoading,
                text: forgotPassword ? 'Submit' : 'Login',
                handleAction: _handleSubmit,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          forgotPassword = !forgotPassword;
                          _validateForm();
                        });
                      },
                      child: Text(
                        forgotPassword ? 'Back to Login' : 'FORGOT PASSWORD?',
                        style: TextStyle(fontSize: 16, color: AppColor.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
