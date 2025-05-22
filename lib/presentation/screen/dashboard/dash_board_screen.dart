import 'package:assistify/core/constants/colors.dart';
import 'package:assistify/core/constants/sizes.dart';
import 'package:assistify/presentation/cubit/dashboard/all_bills/all_bills_cubit.dart';
import 'package:assistify/presentation/cubit/dashboard/all_bills/all_bills_state.dart';
import 'package:assistify/presentation/screen/addjob/add_job_form_screen.dart';
import 'package:assistify/presentation/screen/dashboard/expences_screen.dart';
import 'package:assistify/presentation/screen/dashboard/inventory_screen.dart';
import 'package:assistify/presentation/screen/dashboard/profile_screen.dart';
import 'package:assistify/presentation/screen/dashboard/reports_screen.dart';
import 'package:assistify/presentation/screen/dashboard/settings_screen.dart';
import 'package:assistify/presentation/widgets/filter_option_view_widget.dart';
import 'package:assistify/presentation/widgets/job_card_widget.dart';
import 'package:assistify/presentation/widgets/logout_widget.dart';
import 'package:assistify/presentation/widgets/dash_board_helper_widget.dart';
import 'package:flutter/material.dart';
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
  String userId = '';
  String companyId = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
    companyId = prefs.getString('companyId') ?? '';
    if (mounted) {
      setState(() {
        _searchController.clear();
      });
    }

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
              padding: EdgeInsets.only(left: 16, bottom: 10),
              color: AppColor.blue,
              alignment: Alignment.bottomLeft,
              child: Text(
                'JRServices',
                style: TextStyle(
                  color: AppColor.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  BuildDrawerItem(Icons.home, 'Home', () {
                    Navigator.pop(context);
                    _fetchData();
                  }),
                  BuildDrawerItem(Icons.inventory, 'Inventory', () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => InventoryScreen()),
                    );
                  }),
                  BuildDrawerItem(Icons.wallet, 'Expences', () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ExpencesScreen()),
                    );
                  }),
                  BuildDrawerItem(Icons.settings, 'Settings', () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SettingsScreen()),
                    );
                  }),
                  BuildDrawerItem(Icons.person, 'Profile', () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ProfileScreen()),
                    );
                  }),
                  BuildDrawerItem(Icons.report, 'Reports', () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ReportsScreen()),
                    );
                  }),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: BuildDrawerItem(Icons.logout, 'Logout', () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) => const LogOutCnfrmBottomSheet(),
                );
              }, AppColor.red),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        shadowColor: AppColor.white,
        elevation: 2,
        backgroundColor: AppColor.white,
        title: Text('JRServices', style: TextStyle(color: AppColor.blue)),
        leading: IconButton(
          icon: Icon(Icons.menu, size: 30, color: AppColor.blue),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder:
                      (context) => Container(
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: FilterOptionsView(),
                      ),
                );
              },
              child: Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(6),
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
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddJobFormScreen()),
            ),
        backgroundColor: AppColor.blue,
        child: Icon(Icons.add, color: AppColor.white),
      ),
      body: RefreshIndicator(
        color: AppColor.blue,
        key: _refreshKey,
        onRefresh: _fetchData,
        child: BlocBuilder<AllBillsCubit, AllBillsState>(
          builder: (context, state) {
            return Column(
              children: [
                BuildSearchField(
                  context: context,
                  searchController: _searchController,
                  searchFocusNode: _searchFocusNode,
                  fetchData: _fetchData,
                  userId: userId,
                  companyId: companyId,
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (state is AllBillsLoading) {
                        return Center(
                          child: const CupertinoActivityIndicator(
                            color: Colors.blue,
                          ),
                        );
                      } else if (state is SearchBillsLoaded) {
                        final searchBillsList = state.searchBillModel.data;
                        return searchBillsList?.bills?.isEmpty ?? true
                            ? Center(
                              child: Text(
                                "No bills found with JobID: ${_searchController.text}",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColor.black,
                                ),
                              ),
                            )
                            : ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: searchBillsList?.bills?.length ?? 0,
                              itemBuilder:
                                  (_, i) => JobCard(
                                    jobData: searchBillsList!.bills![i],
                                  ),
                            );
                      } else if (state is AllBillsLoaded) {
                        final allBillsList = state.allBillsModel.data;
                        return allBillsList?.bills?.isEmpty ?? true
                            ? Center(
                              child: Text(
                                "No bills available",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColor.gray,
                                ),
                              ),
                            )
                            : ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: allBillsList?.bills?.length ?? 0,
                              itemBuilder:
                                  (_, i) => JobCard(
                                    jobData: allBillsList!.bills![i],
                                    fetchData: _fetchData,
                                  ),
                            );
                      }
                      return Center(
                        child: const CupertinoActivityIndicator(
                          color: Colors.blue,
                        ),
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
