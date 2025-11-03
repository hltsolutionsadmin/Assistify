import 'package:assistify/core/constants/imgs_const.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void showContactPopup(BuildContext context, String phoneNumber, dynamic data) {
  void _makePhoneCall(String phoneNumber) async {
    print("Phone Number: $phoneNumber");
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        throw 'Could not launch phone call';
      }
    } catch (e) {
      debugPrint('Error launching phone call: $e');
    }
  }

  Future<void> _launchWhatsApp(String phone) async {
    String sanitizedPhone = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    if (sanitizedPhone.startsWith('+')) {
      sanitizedPhone = sanitizedPhone.substring(1);
    }

    String message = ''' 
    Hello *${data.customerName}*
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

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () async {
                  _makePhoneCall(phoneNumber);
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Icon(Icons.phone, color: Colors.blue),
                    SizedBox(width: 10),
                    Text('Make a call', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  _launchWhatsApp(phoneNumber);
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Image.asset(Whatsapp, width: 24, height: 24),
                    SizedBox(width: 10),
                    Text('Chat on WhatsApp', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
