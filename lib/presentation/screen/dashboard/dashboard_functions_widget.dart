import 'package:assistify/core/constants/colors.dart';
import 'package:assistify/core/constants/sizes.dart';
import 'package:assistify/presentation/cubit/dashboard/user_profile/user_profile_cubit.dart';
import 'package:assistify/presentation/cubit/dashboard/user_profile/user_profile_state.dart';
import 'package:assistify/presentation/screen/dashboard/expences_screen.dart';
import 'package:assistify/presentation/screen/dashboard/inventory_screen.dart';
import 'package:assistify/presentation/screen/dashboard/profile_screen.dart';
import 'package:assistify/presentation/screen/dashboard/reports_screen.dart';
import 'package:assistify/presentation/screen/dashboard/settings_screen.dart';
import 'package:assistify/presentation/widgets/filter_option_view_widget.dart';
import 'package:assistify/presentation/widgets/logout_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget _buildDrawerItem(
  IconData icon,
  String title,
  VoidCallback onTap, [
  Color? iconColor,
]) {
  return ListTile(
    leading: Icon(icon, color: iconColor ?? AppColor.blue),
    title: Text(title, style: TextStyle(color: AppColor.black)),
    onTap: onTap,
  );
}

Widget Drawer_tab({
  context,
  companyName,
  categoryId,
  fetchAllBills,
  fetchUserProfile,
}) {
  print(companyName);
  return Column(
    children: [
      Container(
        height: getHeight(context) * 0.12,
        padding: const EdgeInsets.only(left: 16, bottom: 10),
        color: AppColor.blue,
        alignment: Alignment.bottomLeft,
        child: BlocBuilder<UserProfileCubit, UserProfileState>(
          builder: (context, state) {
            if (state is UserProfileLoaded) {
              return Text(
                state.userProfileModel.data?.name ?? '',
                style: TextStyle(
                  color: AppColor.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              );
            }
            return CupertinoActivityIndicator(color: AppColor.white);
          },
        ),
      ),
      const SizedBox(height: 10),
      Expanded(
        child: FutureBuilder(
          future: Future.delayed(const Duration(seconds: 0)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CupertinoActivityIndicator(color: AppColor.blue),
              );
            }
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(Icons.home, 'Home', () {
                  Navigator.pop(context);
                  fetchAllBills();
                }),
                if (categoryId != 2)
                  _buildDrawerItem(Icons.inventory, 'Inventory', () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => InventoryScreen()),
                    );
                  }),
                if (categoryId != 2)
                  _buildDrawerItem(Icons.wallet, 'Expenses', () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ExpencesScreen()),
                    );
                  }),
                _buildDrawerItem(Icons.settings, 'Settings', () {
                  Navigator.pop(context);
                  final state = context.read<UserProfileCubit>().state;
                  if (state is UserProfileLoaded) {
                    final data = state.userProfileModel.data;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => SettingsScreen(
                              address: data?.address,
                              logo: data?.logo,
                              phoneNumber: data?.phoneNumber,
                              jobIdFormat: data?.jobIdFormat,
                              termsAndConditions: data?.termsAndConditions,
                              companyId: data?.id,
                            ),
                      ),
                    ).then((result) {
                      if (result == true) fetchUserProfile();
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('User profile not loaded yet'),
                      ),
                    );
                  }
                }),
                _buildDrawerItem(Icons.person, 'Profile', () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  );
                }),
                if (categoryId != 2)
                  _buildDrawerItem(Icons.report, 'Reports', () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ReportsScreen()),
                    );
                  }),
              ],
            );
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: _buildDrawerItem(Icons.logout, 'Logout', () {
          showModalBottomSheet(
            context: context,
            builder: (_) => const LogOutCnfrmBottomSheet(),
          );
        }, AppColor.red),
      ),
      const SizedBox(height: 20),
    ],
  );
}

Widget App_Bar({
  context,
  scaffoldKey,
  filterData,
  companyId,
  userId,
  fetchAllBills,
  isRefresh,
  isFilterApplied,
  setState,
}) {
  return AppBar(
    shadowColor: AppColor.white,
    elevation: 2,
    backgroundColor: AppColor.white,
    title: BlocBuilder<UserProfileCubit, UserProfileState>(
      builder: (context, state) {
        if (state is UserProfileLoaded) {
          return Center(
            child: Text(
              state.userProfileModel.data?.name ?? '',
              style: TextStyle(color: AppColor.blue),
            ),
          );
        }
        return Text('', style: TextStyle(color: AppColor.blue));
      },
    ),
    leading: IconButton(
      icon: Icon(Icons.menu, size: 30, color: AppColor.blue),
      onPressed: () => {scaffoldKey.currentState?.openDrawer()},
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 10),
        child: GestureDetector(
          onTap: () async {
            FocusScope.of(context).unfocus();
            final result = await showModalBottomSheet<Map<String, dynamic>>(
              context: context,
              backgroundColor: Colors.white,
              isScrollControlled: true,
              builder:
                  (context) => SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: FilterOptionsView(
                      companyId: companyId,
                      userId: userId,
                      initialName: filterData?['name'],
                      initialPhone: filterData?['phone'],
                      initialStatus: filterData?['status'],
                      initialFromDate: filterData?['fromDate'],
                      initialToDate: filterData?['toDate'],
                      fetchData: fetchAllBills,
                      onRefresh: (val) {
                        isRefresh = val;
                      },
                      onFilter: (val) {
                        print(val);
                        isFilterApplied = val;
                        fetchAllBills();
                      },
                    ),
                  ),
            );
            if (result == null) {
              setState(() => filterData = null);
            } else {
              setState(() => filterData = result);
            }
            if (result != null) setState(() => filterData = result);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColor.blue,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Icon(
              Icons.filter_alt_outlined,
              size: 30,
              color: AppColor.white,
            ),
          ),
        ),
      ),
    ],
  );
}
