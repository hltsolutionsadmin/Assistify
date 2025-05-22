import 'package:assistify/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';


class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsScreen> {
  String? selectedFileName;
  final TextEditingController addressController = TextEditingController(text: 'AKP');
  final TextEditingController phoneController = TextEditingController(text: '9966393868');
  final TextEditingController jobIdController = TextEditingController();
  final TextEditingController termsController = TextEditingController();

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        selectedFileName = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Settings'),
        centerTitle: true,
        elevation: 2,
        backgroundColor: AppColor.white,  
        shadowColor: AppColor.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
          Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: AppColor.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Logo', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _pickFile,
                  child:  Text("Choose File", style: TextStyle(color: AppColor.blue),),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    selectedFileName ?? "No file chosen",
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Address'),
            TextField(controller: addressController),
            const SizedBox(height: 20),
            const Text('Phone Number'),
            TextField(controller: phoneController, keyboardType: TextInputType.phone),
            const SizedBox(height: 20),
            const Text('Job ID Format'),
            TextField(controller: jobIdController),
            const SizedBox(height: 20),
            const Text('Terms and Conditions'),
            TextField(controller: termsController),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.blue,
                ),
                child: const Text("UPDATE", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
