import 'package:assistify/core/constants/colors.dart';
import 'package:assistify/presentation/cubit/add_expences/add_expences_cubit.dart';
import 'package:assistify/presentation/cubit/add_products/add_products_cubit.dart';
import 'package:assistify/presentation/cubit/dashboard/all_bills/all_bills_cubit.dart';
import 'package:assistify/presentation/cubit/dashboard/all_expences/all_expences_cubit.dart';
import 'package:assistify/presentation/cubit/dashboard/inventory_products/inventory_produts_cubit.dart';
import 'package:assistify/presentation/cubit/dashboard/save_bill/save_bill_cubit.dart';
import 'package:assistify/presentation/cubit/dashboard/user_profile/user_profile_cubit.dart';
import 'package:assistify/presentation/cubit/forgot_password/forgot_password_cubit.dart';
import 'package:assistify/presentation/cubit/login/logIn_cubit.dart';
import 'package:assistify/presentation/cubit/search_phone_number/search_phone_number_cubit.dart';
import 'package:assistify/presentation/screen/splash/splash_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  final connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.none) {
    print("No Internet Connection");
  } else {
    print("Connected to the Internet");
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContextcontext) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<LoginCubit>()),
        BlocProvider(create: (_) => di.sl<ForgotPasswordCubit>()),
        BlocProvider(create: (_) => di.sl<AllBillsCubit>()),
        BlocProvider(create: (_) => di.sl<InventoryProdutsCubit>()),
        BlocProvider(create: (_) => di.sl<AllExpencesCubit>()),
        BlocProvider(create: (_) => di.sl<AddProductsCubit>()),
        BlocProvider(create: (_) => di.sl<SaveBillCubit>()),
        BlocProvider(create: (_) => di.sl<AddExpencesCubit>()),
        BlocProvider(create: (_) => di.sl<UserProfileCubit>()),
        BlocProvider(create: (_) => di.sl<SearchPhoneNumberCubit>()),
      ],
      child: MaterialApp(
        title: 'Assitify',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColor.green),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
