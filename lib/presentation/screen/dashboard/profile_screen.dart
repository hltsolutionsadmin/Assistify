import 'dart:convert';
import 'dart:typed_data';

import 'package:assistify/core/constants/colors.dart';
import 'package:assistify/presentation/cubit/dashboard/user_profile/user_profile_cubit.dart';
import 'package:assistify/presentation/cubit/dashboard/user_profile/user_profile_state.dart';
import 'package:assistify/presentation/widgets/date_converter_widget.dart';
import 'package:assistify/presentation/widgets/image_converter.dart';
import 'package:assistify/presentation/widgets/logout_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  String name = "";
  String email = "";
  String companyId = "";

  void _fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email') ?? '';
      final firstName = prefs.getString('firstName') ?? '';
      final lastName = prefs.getString('lastName') ?? '';
      name = '$firstName $lastName';
      companyId = prefs.getString('companyId') ?? '';
    });
    await _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    await context.read<UserProfileCubit>().userProfile(context, companyId);

    final cubit = context.read<UserProfileCubit>();
    final state = cubit.state;

    if (state is UserProfileLoaded) {
      final name = state.userProfileModel.data?.name ?? 'No Name';
      print('Name: $name');
    } else if (state is UserProfileError) {
      print('Error: ${state.message}');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        elevation: 2,
        shadowColor: AppColor.white,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Profile", style: TextStyle(color: Colors.black)),
        
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocBuilder<UserProfileCubit, UserProfileState>(
        builder: (context, state) {
          if (state is UserProfileLoading) {
            return const Center(child: CupertinoActivityIndicator(color: Colors.blue));
          } else if (state is UserProfileLoaded) {
            final userProfile = state.userProfileModel;
            final String base64Image = userProfile.data?.logo ?? '';
            final String base64String = base64Image.split(',').last;
            Uint8List bytes = base64Decode(base64String);
            return Container(
              color: AppColor.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade300,
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: buildProfileImage(bytes),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      userProfile.data?.name ?? 'No Name',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      userProfile.data?.email ?? '',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.phone, size: 20, color: Colors.grey),
                          const SizedBox(width: 15),
                          Text(
                            userProfile.data?.phoneNumber ?? '',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: AppColor.gray, width: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 20,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 15),
                          Text(
                            "Member Since: ${formatDate(userProfile.data?.createdAt ?? '')}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => const LogOutCnfrmBottomSheet(),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.red,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.logout, color: Colors.white),
                        label: const Text(
                          "LOG OUT",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
            // phone = userProfile.data?.phone ?? 'No Number';
            // memberSince = userProfile.data?.createdAt ?? 'No Date';
          } else if (state is UserProfileError) {
            return Center(child: Text(state.message));
          }
          return SizedBox();
        },
      ),
    );
  }
}
