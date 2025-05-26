import 'dart:convert';
import 'dart:typed_data';

import 'package:assistify/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class SettingsScreen extends StatefulWidget {
  final String? address;
  final String? logo;
  final String? phoneNumber;
  final String? jobIdFormat;
  final String? termsAndConditions;

  const SettingsScreen({
    Key? key,
    this.address,
    this.logo,
    this.phoneNumber,
    this.jobIdFormat,
    this.termsAndConditions,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsScreen> {
  String? selectedFileName;
  late TextEditingController addressController;
  late TextEditingController phoneController;
  late TextEditingController jobIdController;
  late TextEditingController termsController;
  Uint8List bytes = Uint8List(0);
  Uint8List? imageBytes;
  @override
  void initState() {
    super.initState();
    addressController = TextEditingController(text: widget.address ?? 'AKP');
    phoneController = TextEditingController(
      text: widget.phoneNumber ?? '9966393868',
    );
    jobIdController = TextEditingController(text: widget.jobIdFormat ?? '');
    termsController = TextEditingController(
      text: widget.termsAndConditions ?? '',
    );
    selectedFileName = 'No file chosen';
    _loadImageFromBase64();
  }

  void _loadImageFromBase64() {
    if (widget.logo != null && widget.logo!.isNotEmpty) {
      try {
        final base64String = widget.logo!.split(',').last;
        final decodedBytes = base64Decode(base64String);
        setState(() {
          bytes = decodedBytes;
        });
      } catch (e) {
        print('Error decoding base64 image: $e');
      }
    }
  }

 Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        selectedFileName = image.name;
        imageBytes = bytes;
      });
    }
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColor.gray.withOpacity(0.2),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 1,
        backgroundColor: AppColor.white,
        shadowColor: Colors.grey.withOpacity(0.2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Logo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade300,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: imageBytes != null 
                      ? Image.memory(imageBytes!, fit: BoxFit.cover)
                      : bytes.isNotEmpty
                          ? Image.memory(bytes, fit: BoxFit.cover)
                          : const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.white70,
                            ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.withOpacity(0.3),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Choose Image",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    selectedFileName ?? "No file chosen",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            _buildInputField('Address', addressController),
            _buildInputField(
              'Phone Number',
              phoneController,
              keyboardType: TextInputType.phone,
            ),
            _buildInputField('Job ID Format', jobIdController),
            _buildInputField('Terms and Conditions', termsController),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // You can access the updated values here:
                  // addressController.text, phoneController.text, etc.
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColor.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "UPDATE",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
