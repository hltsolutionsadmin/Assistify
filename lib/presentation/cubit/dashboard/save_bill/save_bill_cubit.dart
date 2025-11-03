import 'package:assistify/core/constants/custome_snack_bar.dart';
import 'package:assistify/domain/usecase/dashboard/save_bill_usecase.dart';
import 'package:assistify/presentation/cubit/dashboard/save_bill/save_bill_state.dart';
import 'package:assistify/presentation/screen/dashboard/dash_board_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/network/network_service.dart';

class SaveBillCubit extends Cubit<SaveBillState> {
  final SaveBillUsecase useCase;
  final NetworkService networkService;

  SaveBillCubit({required this.useCase, required this.networkService})
    : super(SaveBillInitial());

  Future<void> save_bill(
    BuildContext context,
    dynamic body,
    String companyName,
    String? phoneNumber,
    num? category,
  ) async {
    print(body);
    print(category);
    bool isConnected = await networkService.hasInternetConnection();
    print(isConnected);
    if (!isConnected) {
      print("No Internet Connection");
      CustomSnackbars.showErrorSnack(
        context: context,
        title: 'Alert',
        message: 'Please check Internet Connection',
      );
      return;
    }
    try {
      emit(SaveBillLoading());
      final saveBillEntity = await useCase.call(body);
      print(saveBillEntity);
      if (saveBillEntity.status == 'SUCCESS') {
        final jobId = saveBillEntity.data?.bill![0].jobId;
        _launchWhatsApp(context, body, companyName, category, jobId, phoneNumber);
               Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => DashBoardScreen()),
                        (_) => false,
                      );

        emit(SaveBillLoaded(saveBillEntity));
      } else {
        CustomSnackbars.showErrorSnack(
          context: context,
          title: 'Alert',
          message: 'some thing went wrong',
        );
      }
    } catch (e) {
      CustomSnackbars.showErrorSnack(
        context: context,
        title: 'Alert',
        message: 'some thing went wrong',
      );
      print('error in allbills: $e');
      emit(SaveBillError('Failed to load save bill data: ${e.toString()}'));
    }
  }

  Future<void> _launchWhatsApp(context, body, companyName, category, jobId, phoneNumber) async {
    String phone = body['phoneNumber'] ?? '';
    print('phoneNumber--: $phoneNumber');

    String message1 = ''' 
Hello *${body['customerName']}*
Please find the requested details:
Product: *${body['productName']}(${body['modelNumber']}, ${body['serialNumber']})*
Order/Complaint: *${body['complaint']}*
Job/OrderId: *$jobId*
Status: *${body['status']}*

Thanks & Regards
*$companyName*
*$phoneNumber*
    ''';
    String itemDetails = '';
    if (body['billSpares'] != null) {
      for (var spare in body['billSpares']) {
        itemDetails += '${spare['product']} - ${spare['quantity']}kg\n';
      }
    }

    String message2 = ''' 
Hello *${body['customerName']}*
Please find the requested details:

Item details
*$itemDetails*
TotalAmount: *₹${body['totalAmount']}*

Thanks & Regards
*$companyName*
*$phoneNumber*
    ''';

    final url =
        'https://wa.me/+91$phone?text=${Uri.encodeComponent(category == 2 ? message2 : message1)}';

    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('WhatsApp not available')));
    }
  }
}
