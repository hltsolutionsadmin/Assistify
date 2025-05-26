import 'package:assistify/core/constants/custome_snack_bar.dart';
import 'package:assistify/domain/usecase/dashboard/save_bill_usecase.dart';
import 'package:assistify/presentation/cubit/dashboard/save_bill/save_bill_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/network/network_service.dart';

class SaveBillCubit extends Cubit<SaveBillState> {
  final SaveBillUsecase useCase;
  final NetworkService networkService;

  SaveBillCubit({required this.useCase, required this.networkService})
    : super(SaveBillInitial());

  Future<void> save_bill(BuildContext context, dynamic body, String companyName) async {
    print(body);
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
        Navigator.pop(context);
        _launchWhatsApp(context, body, companyName);
        emit(SaveBillLoaded(saveBillEntity));
      } else {
        CustomSnackbars.showErrorSnack(
          context: context,
          title: 'Alert',
          message: 'some thing went wrong',
        );
      }
    } catch (e) {
      print('error in allbills: $e');
      emit(SaveBillError('Failed to load save bill data: ${e.toString()}'));
    }
  }

  Future<void> _launchWhatsApp(context, body, companyName) async {
    String phone = body['phoneNumber'] ?? '';
    String sanitizedPhone = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    if (sanitizedPhone.startsWith('+')) {
      sanitizedPhone = sanitizedPhone.substring(1);
    }

    String message = ''' 
Hello *${body['customerName']}*
Please find the requested details:
Product: *${body['productName']}*(${body['modelNumber']}, ${body['serialNumber']})
Order/Complaint: *${'complaint'}*
Job/OrderId: *${'jobId'}*
Status: *${body['status']}*

Thanks & Regards
*${companyName}*
*$phone*
    ''';

    final url =
        'https://wa.me/$sanitizedPhone?text=${Uri.encodeComponent(message)}';

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
