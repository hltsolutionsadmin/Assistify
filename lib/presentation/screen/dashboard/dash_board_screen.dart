import 'package:assistify/core/constants/colors.dart';
import 'package:assistify/presentation/cubit/dashboard/all_bills/all_bills_cubit.dart';
import 'package:assistify/presentation/cubit/dashboard/all_bills/all_bills_state.dart';
import 'package:assistify/presentation/cubit/dashboard/user_profile/user_profile_cubit.dart';
import 'package:assistify/presentation/cubit/dashboard/user_profile/user_profile_state.dart';
import 'package:assistify/presentation/screen/addjob/add_form.dart';
import 'package:assistify/presentation/screen/addjob/add_job_form_screen.dart';
import 'package:assistify/presentation/screen/dashboard/dashboard_functions_widget.dart';
import 'package:assistify/presentation/screen/login/login_screen.dart';
import 'package:assistify/presentation/widgets/dash_board_helper_widget.dart';
import 'package:assistify/presentation/widgets/filter_option_view_widget.dart';
import 'package:assistify/presentation/widgets/job_card_widget.dart';
import 'package:assistify/presentation/widgets/vegi_customer_details_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  late FocusNode searchFocusNode;
  bool _isFilterApplied = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  final _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String userId = '';
  String companyId = '';
  String companyName = '';
  String banner = '';
  String logo = '';
  String companyPhone = '';
  Map<String, dynamic>? filterData;
  num categoryId = 0;
  int _pageNumber = 1;
  final int _pageSize = 10;
  bool _isFetchingMore = false;
  final bool _hasMore = true;
  bool isRefresh = false;
  bool _isDrawerDataLoaded = false;

  @override
  void initState() {
    super.initState();
    searchFocusNode = FocusNode();
    _initializeData();
    _checkForUpdate();
  }

Future<void> _checkForUpdate() async {
    print('checking for update');
    await InAppUpdate.checkForUpdate().then((info) {
setState(() {
  if(info.updateAvailability == UpdateAvailability.updateAvailable){
    print('update available');
    update();
  }
});
    }).catchError((e) {
      print('error in update');
      print(e.toString());
    });
      
    
  }

  void update() async {
    print('Updating');
    await InAppUpdate.startFlexibleUpdate();
    InAppUpdate.completeFlexibleUpdate().then((_) {}).catchError((error) {
      print(error.toString());
    });
  }

  Future<void> _initializeData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
    companyId = prefs.getString('companyId') ?? '';
    await _fetchUserProfile();
    _fetchAllBills();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !_isFetchingMore &&
        !_isFilterApplied &&
        _hasMore) {
      _pageNumber++;
      _fetchAllBills();
    }
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    _scrollController.dispose();
    _scrollController.removeListener(_scrollListener);
    _searchController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (searchFocusNode.hasFocus) {
      searchFocusNode.unfocus();
      return false;
    }
    return true;
  }

  Future<void> _fetchUserProfile() async {
    await context.read<UserProfileCubit>().userProfile(context, companyId);
    final state = context.read<UserProfileCubit>().state;
    if (state is UserProfileLoaded) {
      print(
        'state.userProfileModel.data--${state.userProfileModel.data?.phoneNumber}',
      );
      setState(() {
        companyName = state.userProfileModel.data?.name ?? 'No Name';
        categoryId = state.userProfileModel.data?.categoryId ?? 0;
        banner = state.userProfileModel.data?.bannerImage ?? '';
        logo = state.userProfileModel.data?.logo ?? '';
        companyPhone = state.userProfileModel.data?.phoneNumber ?? '';
        _isDrawerDataLoaded = true;
      });
    } else if (state is UserProfileError) {
      SharedPreferences prefs;
      prefs = await SharedPreferences.getInstance();
      prefs.setString('TOKEN', '');
      prefs.setString("email", '');
      prefs.setString("userId", '');
      prefs.setString("companyId", '');
      prefs.setString("firstName", '');
      prefs.setString("lastName", '');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (_) => false,
      );
    }
  }

  Future<void> _fetchAllBills() async {
    _isFetchingMore = true;
    print('_isFilterApplied$_isFilterApplied');
    if (_isFilterApplied == true) {
      await context.read<AllBillsCubit>().all_bills(context, {
        "userId": userId,
        "companyId": companyId,
        "pageNumber": _pageNumber.toString(),
        "pageSize": _pageSize.toString(),
      });
    } else {
      if (isRefresh) {
        _pageNumber = 1;
      }
      await context.read<AllBillsCubit>().all_bills(context, {
        "userId": userId,
        "companyId": companyId,
        "pageNumber": _pageNumber.toString(),
        "pageSize": _pageSize.toString(),
      });
      _isFetchingMore = false;
      isRefresh = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        drawer:
            _isDrawerDataLoaded
                ? Drawer(
                  backgroundColor: AppColor.white,
                  child: Drawer_tab(
                    context: context,
                    categoryId: categoryId,
                    companyName: companyName,
                    fetchAllBills: _fetchAllBills,
                    fetchUserProfile: _fetchUserProfile,
                  ),
                )
                : null,
        appBar: AppBar(
          shadowColor: AppColor.white,
          elevation: 2,
          backgroundColor: AppColor.white,
          title: BlocBuilder<UserProfileCubit, UserProfileState>(
            builder: (context, state) {
              if (state is UserProfileLoaded) {
                return Center(
                  child: Text(
                    companyName,
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
                  final result =
                      await showModalBottomSheet<Map<String, dynamic>>(
                        context: context,
                        isScrollControlled: true,
                        builder:
                            (context) => SizedBox(
                              height: MediaQuery.of(context).size.height * 0.9,
                              child: FilterOptionsView(
                                companyId: companyId,
                                userId: userId,
                                initialName: filterData?['name'],
                                initialPhone: filterData?['phone'],
                                initialStatus: filterData?['status'],
                                initialFromDate: filterData?['fromDate'],
                                initialToDate: filterData?['toDate'],
                                fetchData: _fetchAllBills,
                                onFilter: (val) {
                                  _isFilterApplied = val;
                                },
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
                              companyPhone: companyPhone,
                            )
                            : AddJobFormScreen(
                              companyName: companyName,
                              companyPhone: companyPhone,
                            ),
              ),
            );
          },
          backgroundColor: AppColor.blue,
          child: Icon(Icons.add, color: AppColor.white),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: RefreshIndicator(
            color: AppColor.blue,
            key: _refreshKey,
            onRefresh: () async {
              setState(() {
                isRefresh = true;
                _pageNumber = 1;
                _fetchAllBills();
              });
            },
            child: BlocBuilder<AllBillsCubit, AllBillsState>(
              builder: (context, state) {
                return Column(
                  children: [
                    BuildSearchField(
                      context: context,
                      searchController: _searchController,
                      searchFocusNode: searchFocusNode,
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
                      onTapOutside: (event) {
                        searchFocusNode.unfocus();
                      },
                    ),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          if (state is AllBillsLoading) {
                            return const Center(
                              child: CupertinoActivityIndicator(
                                color: Colors.blue,
                              ),
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
                              itemBuilder: (_, i) {
                                return categoryId == 2
                                    ? VegiCustomerDetailsCard(
                                      custData: bills[i],
                                      category: categoryId,
                                      fetchData: _fetchAllBills,
                                      companyPhone: companyPhone,
                                    )
                                    : JobCard(
                                      jobData: bills[i],
                                      companyName: companyName,
                                      category: categoryId,
                                      logo: logo,
                                      banner: banner,
                                      companyPhone: companyPhone,
                                    );
                              },
                            );
                          } else if (state is AllBillsLoaded) {
                            final bills = state.allBillsModel.data?.bills ?? [];
                            if (bills.isEmpty) {
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
                              controller:
                                  !_isFilterApplied ? _scrollController : null,
                              itemCount:
                                  _isFilterApplied
                                      ? bills.length
                                      : bills.length + 1,
                              itemBuilder: (_, i) {
                                if (i < bills.length) {
                                  return categoryId == 2
                                      ? InkWell(
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                        },
                                        child: VegiCustomerDetailsCard(
                                          custData: bills[i],
                                          fetchData: _fetchAllBills,
                                          companyName: companyName,
                                          category: categoryId,
                                          companyPhone: companyPhone,
                                        ),
                                      )
                                      : InkWell(
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                        },
                                        child: JobCard(
                                          jobData: bills[i],
                                          companyName: companyName,
                                          fetchData: _fetchAllBills,
                                        ),
                                      );
                                } else {
                                  return _hasMore
                                      ? const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        child: Center(
                                          child: CupertinoActivityIndicator(
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                      : const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "No more bills to fetch",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      );
                                }
                              },
                            );
                          }
                          return const Center(
                            child: CupertinoActivityIndicator(
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
        ),
      ),
    );
  }
}
