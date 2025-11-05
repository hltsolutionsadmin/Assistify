import 'dart:convert';
import 'dart:typed_data';
import 'package:assistify/core/constants/colors.dart';
import 'package:assistify/presentation/cubit/dashboard/user_profile/user_profile_cubit.dart';
import 'package:assistify/presentation/cubit/dashboard/user_profile/user_profile_state.dart';
import 'package:assistify/presentation/screen/dashboard/dash_board_screen.dart';
import 'package:assistify/presentation/screen/dashboard/employee_list_screen.dart';
import 'package:assistify/presentation/screen/dashboard/expences_screen.dart';
import 'package:assistify/presentation/screen/dashboard/inventory_screen.dart';
import 'package:assistify/presentation/screen/dashboard/profile_screen.dart';
import 'package:assistify/presentation/screen/dashboard/reports_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String companyId = '';

  @override
  void initState() {
    super.initState();
    _initProfile();
  }

  Future<void> _initProfile() async {
    final prefs = await SharedPreferences.getInstance();
    companyId = prefs.getString('companyId') ?? '';
    if (companyId.isNotEmpty && mounted) {
      await context.read<UserProfileCubit>().userProfile(context, companyId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: BlocBuilder<UserProfileCubit, UserProfileState>(
        builder: (context, state) {
          if (state is UserProfileLoading) {
            return const Center(
              child: CupertinoActivityIndicator(color: Colors.blue),
            );
          } else if (state is UserProfileLoaded) {
            final userProfile = state.userProfileModel.data;
            Uint8List? bytes;

            if (userProfile?.logo != null && userProfile!.logo!.isNotEmpty) {
              try {
                final base64String =
                    userProfile.logo!.contains(',')
                        ? userProfile.logo!.split(',').last
                        : userProfile.logo!;
                bytes = base64Decode(base64String);
              } catch (e) {
                print('Error decoding image: $e');
              }
            }

            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE3F2FD), Color(0xFFFFFFFF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Company Header Card ---
                      Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage:
                                  bytes != null ? MemoryImage(bytes) : null,
                              child:
                                  bytes == null
                                      ? const Icon(
                                        Icons.business,
                                        size: 35,
                                        color: Colors.grey,
                                      )
                                      : null,
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userProfile?.name ?? "No Name",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    userProfile?.email ?? "",
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // --- Dashboard Header ---
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Text(
                          "Quick Access",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      // --- Dashboard Tiles ---
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 18,
                          crossAxisSpacing: 18,
                          children: [
                            _buildDashboardTile(
                              icon: Icons.home_outlined,
                              label: "Bills",
                              color: const Color(0xFF4C93AF),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const DashBoardScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildDashboardTile(
                              icon: Icons.inventory_2_outlined,
                              label: "Inventory",
                              color: Colors.blueAccent,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const InventoryScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildDashboardTile(
                              icon: Icons.account_balance_wallet_outlined,
                              label: "Expenses",
                              color: Colors.deepPurple,
                              onTap: () {
                               Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const ExpencesScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildDashboardTile(
                              icon: Icons.group_outlined,
                              label: "Employees",
                              color: Colors.teal,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const EmployeeListScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildDashboardTile(
                              icon: Icons.report_outlined,
                              label: "Reports",
                              color: Colors.orange,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const ReportsScreen(),
                                  ),
                                );
                              },
                            ),
                            
                            _buildDashboardTile(
                              icon: Icons.person_outline,
                              label: "Profile",
                              color: Colors.redAccent,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const ProfileScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is UserProfileError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildDashboardTile({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.9), color.withOpacity(0.6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 38),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
