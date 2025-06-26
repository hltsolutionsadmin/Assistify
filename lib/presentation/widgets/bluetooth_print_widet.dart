import 'dart:convert';
import 'dart:typed_data';
import 'package:assistify/core/constants/colors.dart';
import 'package:assistify/core/constants/imgs_const.dart';
import 'package:assistify/presentation/widgets/date_converter_widget.dart';
import 'package:assistify/presentation/widgets/helper_widgets.dart/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer_library.dart';

class PrintScreen extends StatefulWidget {
  final dynamic data;
  final String? companyName;
  final num? category;
  final List<dynamic>? spares;
  final String? logo;

  const PrintScreen({
    Key? key,
    this.data,
    this.companyName,
    this.category,
    this.spares,
    this.logo,
  }) : super(key: key);

  @override
  State<PrintScreen> createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {
  Uint8List? bytes;
  late String productsText;
  ReceiptController? controller;

  final TextStyle boldStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  final TextStyle normalStyle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  @override
  void initState() {
    super.initState();
    // print(widget.category);
    if (widget.logo?.isNotEmpty == true) {
      try {
        final base64String =
            widget.logo!.contains(',')
                ? widget.logo!.split(',').last
                : widget.logo!;
        bytes = base64Decode(base64String);
      } catch (e) {
        debugPrint('Error decoding base64 image: $e');
      }
    }

    productsText = widget.spares?.map((e) => e.product).join(', ') ?? '';
  }

  Widget _infoRow(String label, String value) => Row(
    children: [
      Text(label, style: boldStyle),
      const SizedBox(width: 4),
      Text(value, style: normalStyle),
    ],
  );

  Widget _buildCustomerInfo() => Column(
    children: [
      _infoRow('Name:', widget.data.customerName),
      const SizedBox(height: 10),
      _infoRow('Phone Number:', widget.data.phoneNumber),
      const SizedBox(height: 10),
      _infoRow('Address:', widget.data.address),

      // const SizedBox(height: 10),
      // _infoRow('Date:', formatDate(widget.data.createdAt ?? '')),
      const Text('------------------------'),
    ],
  );

  Widget _buildSparesTable() => Container(
    padding: const EdgeInsets.all(8),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Item', style: boldStyle),
            Text('Quantity', style: boldStyle),
            Text('Price', style: boldStyle),
          ],
        ),
        const SizedBox(height: 8),
        ...?widget.spares?.map(
          (spare) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(spare.product, style: normalStyle),
                ),
                Expanded(
                  child: Text(
                    '${spare.quantity}',
                    textAlign: TextAlign.center,
                    style: normalStyle,
                  ),
                ),
                Expanded(
                  child: Text(
                    '₹${spare.price}',
                    textAlign: TextAlign.right,
                    style: normalStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  Widget _buildRow(String label, String value) => Row(
    children: [
      Text(label, style: boldStyle),
      const SizedBox(width: 4),
      Text(value, style: const TextStyle(fontSize: 20)),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final isCategory2 = widget.category == 2;
    final data = widget.data;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mobile Print"),
        centerTitle: true,
        backgroundColor: AppColor.white,
        shadowColor: AppColor.white,
      ),
      body: Receipt(
        builder:
            (context) => SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      bytes == null
                          ? Image.asset(Logo, width: 100, height: 100)
                          : Image.memory(bytes!, height: 150, width: 100),
                      const SizedBox(width: 8),
                      if (widget.companyName != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.companyName!,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const Text('------------------------'),
                  const SizedBox(height: 10),
                  isCategory2
                      ? _buildCustomerInfo()
                      : _buildRow('Product:', data.productName.toString()),
                  const SizedBox(height: 10),
                  isCategory2
                      ? _buildSparesTable()
                      : _buildRow('Order/Complaint:', data.complaint),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment:
                        isCategory2
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                    children: [
                      Text(
                        isCategory2 ? 'Total Price:' : 'JobId:',
                        style: boldStyle,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isCategory2
                            ? data?.totalAmount.toString() ?? ''
                            : data.jobId.toString(),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (!isCategory2)
                    _buildRow('Status:', data.status.toString()),
                  const SizedBox(height: 10),
                  if (!isCategory2)
                    _buildRow('Date:', formatDate(widget.data.createdAt ?? '')),
                  const SizedBox(height: 20),
                  Text(
                    'Thanks & Regards:',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  if (widget.companyName != null)
                    Text(
                      widget.companyName!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 5),
                  Text(
                    data.phoneNumber.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text('------------------------'),
                  const SizedBox(height: 5),
                  Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 0.5),
                      ),
                      child: Image.asset(
                        widget.category == 2 ? vegiPaymentQrCode : qrcode,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
        onInitialized: (ctrl) => controller = ctrl,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: buildButton(
          text: 'Print',
          handleAction: () async {
            final address = await FlutterBluetoothPrinter.selectDevice(context);
            if (address != null) {
              await controller?.print(
                address: address.address,
                keepConnected: true,
                addFeeds: 4,
              );
            } else {
              debugPrint("failed print");
            }
          },
        ),
      ),
    );
  }
}
