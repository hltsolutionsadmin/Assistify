import 'package:assistify/core/constants/colors.dart';
import 'package:assistify/core/constants/sizes.dart';
import 'package:assistify/presentation/cubit/dashboard/all_bills/all_bills_cubit.dart';
import 'package:assistify/presentation/cubit/dashboard/all_bills/all_bills_state.dart';
import 'package:assistify/presentation/cubit/dashboard/user_profile/user_profile_cubit.dart';
import 'package:assistify/presentation/cubit/dashboard/user_profile/user_profile_state.dart';
import 'package:assistify/presentation/screen/addjob/add_form.dart';
import 'package:assistify/presentation/screen/addjob/add_job_form_screen.dart';
import 'package:assistify/presentation/screen/dashboard/expences_screen.dart';
import 'package:assistify/presentation/screen/dashboard/inventory_screen.dart';
import 'package:assistify/presentation/screen/dashboard/profile_screen.dart';
import 'package:assistify/presentation/screen/dashboard/reports_screen.dart';
import 'package:assistify/presentation/screen/dashboard/settings_screen.dart';
import 'package:assistify/presentation/widgets/dash_board_helper_widget.dart';
import 'package:assistify/presentation/widgets/filter_option_view_widget.dart';
import 'package:assistify/presentation/widgets/job_card_widget.dart';
import 'package:assistify/presentation/widgets/logout_widget.dart';
import 'package:assistify/presentation/widgets/vegi_customer_details_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  String userId = '';
  String companyId = '';
  String companyName = '';

  Map<String, dynamic>? filterData;
  num categoryId = 0;
  String? selectedStatus;
  final List<String> statusList = [
    'Received',
    'Assigned',
    'In Progress',
    'Estimated',
    'Pending',
    'Delivered',
    'Completed',
    'Paid',
    "Return",
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    // _searchController.dispose();
    // _searchFocusNode.dispose();
    super.dispose();
  }
  // final ScrollController _scrollController = ScrollController();

  Future<void> _initializeData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
    companyId = prefs.getString('companyId') ?? '';
    await _fetchUserProfile();
    _fetchAllBills();
    if (mounted) {
      _searchController.clear();
    }

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _searchFocusNode.requestFocus();
    // });
  }

  Future<void> _fetchUserProfile() async {
    await context.read<UserProfileCubit>().userProfile(context, companyId);
    final cubit = context.read<UserProfileCubit>();
    final state = cubit.state;

    if (state is UserProfileLoaded) {
      companyName = state.userProfileModel.data?.name ?? 'No Name';
      categoryId = state.userProfileModel.data?.categoryId ?? 0;
      print(
        'companyId: $companyId , categoryId: $categoryId, companyName: $companyName',
      );
    } else if (state is UserProfileError) {
      print('Error: ${state.message}');
    }
  }

  void _fetchAllBills() {
    context.read<AllBillsCubit>().all_bills(context, {
      "userId": userId,
      "companyId": companyId,
      "pageNumber": "1",
      "pageSize": "40",
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        backgroundColor: AppColor.white,
        child: Column(
          children: [
            Container(
              height: getHeight(context) * 0.12,
              padding: const EdgeInsets.only(left: 16, bottom: 10),
              color: AppColor.blue,
              alignment: Alignment.bottomLeft,
              child: BlocBuilder<UserProfileCubit, UserProfileState>(
                builder: (context, state) {
                  if (state is UserProfileLoaded) {
                    // final name = state.userProfileModel.data?.name;
                    return Text(
                      companyName ?? '',
                      style: TextStyle(
                        color: AppColor.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                  return const CupertinoActivityIndicator(color: Colors.white);
                },
              ),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: FutureBuilder(
                future: Future.delayed(const Duration(seconds: 2)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CupertinoActivityIndicator(color: AppColor.blue),
                    );
                  }
                  return ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      BuildDrawerItem(Icons.home, 'Home', () {
                        Navigator.pop(context);
                        _fetchAllBills();
                      }),
                      categoryId == 2
                          ? SizedBox()
                          : BuildDrawerItem(Icons.inventory, 'Inventory', () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => InventoryScreen(),
                              ),
                            );
                          }),
                      categoryId == 2
                          ? SizedBox()
                          : BuildDrawerItem(Icons.wallet, 'Expenses', () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ExpencesScreen(),
                              ),
                            );
                          }),
                      BuildDrawerItem(Icons.settings, 'Settings', () {
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
                                    termsAndConditions:
                                        data?.termsAndConditions,
                                    companyId: data?.id,
                                  ),
                            ),
                          ).then((result) {
                            if (result == true) {
                              _fetchUserProfile();
                            }
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('User profile not loaded yet'),
                            ),
                          );
                        }
                      }),
                      BuildDrawerItem(Icons.person, 'Profile', () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ProfileScreen()),
                        );
                      }),
                      categoryId == 2
                          ? SizedBox()
                          : BuildDrawerItem(Icons.report, 'Reports', () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ReportsScreen(),
                              ),
                            );
                          }),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: BuildDrawerItem(Icons.logout, 'Logout', () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) => const LogOutCnfrmBottomSheet(),
                );
              }, AppColor.red),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      appBar: AppBar(
        shadowColor: AppColor.white,
        elevation: 2,
        backgroundColor: AppColor.white,
        title: BlocBuilder<UserProfileCubit, UserProfileState>(
          builder: (context, state) {
            if (state is UserProfileLoaded) {
              return Center(
                child: Text(
                  companyName ?? 'No Name',
                  style: TextStyle(color: AppColor.blue),
                ),
              );
            }
            return Text('', style: TextStyle(color: AppColor.blue));
          },
        ),
        leading: IconButton(
          icon: Icon(Icons.menu, size: 30, color: AppColor.blue),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () async {
                final result = await showModalBottomSheet<Map<String, dynamic>>(
                  context: context,
                  isScrollControlled: true,
                  builder:
                      (context) => Container(
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: FilterOptionsView(
                          companyId: companyId,
                          userId: userId,
                          initialName: filterData?['name'],
                          initialPhone: filterData?['phone'],
                          initialStatus: filterData?['status'],
                          initialFromDate: filterData?['fromDate'],
                          initialToDate: filterData?['toDate'],
                        ),
                      ),
                );

                if (result != null) {
                  setState(() {
                    filterData = result;
                  });
                }
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
      ),
      backgroundColor: AppColor.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) =>
                      categoryId == 2
                          ? AddFormScreen(
                            companyName: companyName,
                            category: categoryId,
                          )
                          : AddJobFormScreen(companyName: companyName),
            ),
          ).then((_) {
            _fetchAllBills();
          });
          ;
        },
        backgroundColor: AppColor.blue,
        child: Icon(Icons.add, color: AppColor.white),
      ),
      body: RefreshIndicator(
        color: AppColor.blue,
        key: _refreshKey,
        onRefresh: () async {
          _fetchAllBills();
          // _fetchUserProfile();
        },
        child: BlocBuilder<AllBillsCubit, AllBillsState>(
          builder: (context, state) {
            return Column(
              children: [
                BuildSearchField(
                  context: context,
                  searchController: _searchController,
                  fetchData: _fetchAllBills,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      _fetchAllBills();
                    } else {
                      Future.delayed(const Duration(milliseconds: 100), () {
                        if (value == _searchController.text) {
                          context.read<AllBillsCubit>().searchBills(
                            context: context,
                            jobId: value,
                            userId: userId,
                            companyId: companyId,
                          );
                        }
                      });
                    }
                  },
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (state is AllBillsLoading) {
                        return const Center(
                          child: CupertinoActivityIndicator(color: Colors.blue),
                        );
                      } else if (state is SearchBillsLoaded) {
                        final bills = state.searchBillModel.data?.bills;
                        if (bills == null || bills.isEmpty) {
                          return Center(
                            child: Text(
                              "No bills found with JobID: ${_searchController.text}",
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColor.black,
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: bills.length,
                          itemBuilder:
                              (_, i) =>
                                  categoryId == 2
                                      ? VegiCustomerDetailsCard(
                                        custData: bills[i],
                                        category: categoryId,
                                        fetchData: _fetchAllBills,
                                      )
                                      : JobCard(
                                        jobData: bills[i],
                                        companyName: companyName,
                                        category: categoryId,
                                        fetchData: _fetchAllBills,
                                      ),
                        );
                      } else if (state is AllBillsLoaded) {
                        final bills = state.allBillsModel.data?.bills;
                        if (bills == null || bills.isEmpty) {
                          return Center(
                            child: Text(
                              "No bills available",
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColor.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: bills.length,
                          itemBuilder:
                              (_, i) =>
                                  categoryId == 2
                                      ? VegiCustomerDetailsCard(
                                        custData: bills[i],
                                        fetchData: _fetchAllBills,
                                        companyName: companyName,
                                        category: categoryId,
                                      )
                                      : JobCard(
                                        jobData: bills[i],
                                        companyName: companyName,
                                        fetchData: _fetchAllBills,
                                      ),
                        );
                      }
                      return const Center(
                        child: CupertinoActivityIndicator(color: Colors.blue),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
