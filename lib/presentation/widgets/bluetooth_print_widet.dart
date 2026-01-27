import 'dart:convert';
import 'package:assistify/core/constants/colors.dart';
import 'package:assistify/core/constants/imgs_const.dart';
import 'package:assistify/presentation/widgets/date_converter_widget.dart';
import 'package:assistify/presentation/widgets/helper_widgets.dart/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class PrintScreen extends StatefulWidget {
  final dynamic data;
  final String? companyName;
  final num? category;
  final List<dynamic>? spares;
  final String? logo;
  final String? companyPhone;

  const PrintScreen({
    super.key,
    this.data,
    this.companyName,
    this.category,
    this.spares,
    this.logo,
    this.companyPhone
  });

  @override
  State<PrintScreen> createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {
  Uint8List? bytes;
  late String productsText;

  final TextStyle boldStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  final TextStyle normalStyle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  Printer? _selectedPrinter;

  @override
  void initState() {
    super.initState();
    print(widget.companyPhone);
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

  Future<Printer?> _selectPrinterDialog() async {
    final printerInstance = FlutterThermalPrinter.instance;
    await printerInstance.getPrinters();

    return showDialog<Printer>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Printer'),
          content: SizedBox(
            width: double.maxFinite,
            child: StreamBuilder<List<Printer>>(
              stream: printerInstance.devicesStream,
              builder: (context, snapshot) {
                final devices = snapshot.data ?? [];
                if (devices.isEmpty) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('No printers found yet.'),
                      SizedBox(height: 12),
                      CircularProgressIndicator(),
                    ],
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: devices.length,
                  itemBuilder: (context, index) {
                    final p = devices[index];
                    return ListTile(
                      title: Text(p.name ?? p.address ?? 'Unknown'),
                      subtitle: Text(
                        '${p.connectionType?.name} ${p.address ?? ''}',
                      ),
                      onTap: () => Navigator.of(context).pop(p),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  String padRight(String text, int width) {
    if (text.length >= width) return text.substring(0, width);
    return text.padRight(width);
  }

  String padLeft(String text, int width) {
    if (text.length >= width) return text.substring(0, width);
    return text.padLeft(width);
  }

  String fixedLabel(String label, int width) {
    if (label.length >= width) return '${label.substring(0, width)}: ';
    return '${label.padRight(width)}: ';
  }

  String fixedLabelValue(
    String label,
    String value,
    int labelWidth,
    int valueWidth,
  ) {
    String paddedLabel =
        label.length > labelWidth
            ? label.substring(0, labelWidth)
            : label.padRight(labelWidth);

    String paddedValue =
        value.length > valueWidth ? value.substring(0, valueWidth) : value;

    return '$paddedLabel: $paddedValue';
  }

  Future<void> _printReceipt() async {
    final printerInstance = FlutterThermalPrinter.instance;

    try {
      Printer? printer = _selectedPrinter;

      if (printer == null) {
        printer = await _selectPrinterDialog();
        if (printer == null) return;
        setState(() => _selectedPrinter = printer);
      }
      final isWidePrinter = printer.name?.contains("80") ?? false;
      final paperSize = isWidePrinter ? PaperSize.mm80 : PaperSize.mm58;
      print(isWidePrinter);

      final int colItem = isWidePrinter ? 30 : 15;
      final int colQty = isWidePrinter ? 8 : 5;
      final int colPrice = isWidePrinter ? 15 : 10;
      final int labelWidth = isWidePrinter ? 12 : 8;

      final connected = await printerInstance.connect(printer);
      if (!connected) {
        debugPrint('Failed to connect to printer.');
        return;
      }

      final data = widget.data;
      final isCategory2 = widget.category == 2;

      if (widget.logo?.isNotEmpty == true) {
        try {
          final base64String =
              widget.logo!.contains(',')
                  ? widget.logo!.split(',').last
                  : widget.logo!;
          final bytes = base64Decode(base64String);

          img.Image? logoImage = img.decodeImage(bytes);
          if (logoImage != null) {
            logoImage = img.copyResize(
              logoImage,
              width: isWidePrinter ? 250 : 180,
            );
            final logoBytes = Uint8List.fromList(img.encodePng(logoImage));

            await printerInstance.printImageBytes(
              printer: printer,
              imageBytes: logoBytes,
              printOnBle: true,
            );
          }
        } catch (e) {
          debugPrint('Error decoding base64 logo: $e');
        }
      }

      String receiptText = '';

      if (widget.companyName != null) {
        receiptText += '${widget.companyName}\n';
        receiptText += '-' * (isWidePrinter ? 40 : 32) + '\n';
      }

      if (isCategory2) {
        receiptText +=
            '${fixedLabelValue('Name', data.customerName ?? '', 7, colItem)}\n';
        receiptText +=
            '${fixedLabelValue('Phone', data.phoneNumber ?? '', 7, colItem)}\n';
        receiptText +=
            '${fixedLabelValue('Address', data.address ?? '', 7, colItem + 10)}\n';
      } else {
        receiptText +=
            '${fixedLabel('Product', labelWidth)}${data.productName ?? ''}\n';
        receiptText +=
            '${fixedLabel('Order/Complaint', labelWidth)}${data.complaint ?? ''}\n';
      }

      receiptText += '-' * (isWidePrinter ? 40 : 32) + '\n';

      if (isCategory2 && widget.spares != null) {
        receiptText +=
            '${padRight('Item', colItem)}${padLeft('Qty', colQty)}${padLeft('Price', colPrice)}\n';
        receiptText += '-' * (isWidePrinter ? 40 : 32) + '\n';
        for (var spare in widget.spares!) {
          receiptText +=
              '${padRight(spare.product ?? '', colItem)}${padLeft('${spare.quantity}', colQty)}${padLeft('${spare.price}', colPrice)}\n';
        }

        receiptText += '-' * (isWidePrinter ? 40 : 32) + '\n';
        receiptText +=
            '${fixedLabel('Total', colItem)}${data.totalAmount ?? ''}\n';
      } else {
        receiptText +=
            '${fixedLabel('JobId', labelWidth)}${data.jobId ?? ''}\n';
        receiptText +=
            '${fixedLabel('Status', labelWidth)}${data.status ?? ''}\n';
        receiptText +=
            '${fixedLabel('Date', labelWidth)}${formatDate(data.createdAt ?? '')}\n';
      }

      receiptText += '\nThanks & Regards\n';
      if (widget.companyName != null) receiptText += '${widget.companyName}\n';
      receiptText += '${widget.companyPhone ?? ''}\n\n';

      final textBytes = utf8.encode(receiptText);
      const mtu = 182;
      for (int i = 0; i < textBytes.length; i += mtu) {
        final end = (i + mtu < textBytes.length) ? i + mtu : textBytes.length;
        final chunk = textBytes.sublist(i, end);
        await printerInstance.printData(printer, Uint8List.fromList(chunk));
      }

      final qrAssetPath = widget.category == 2 ? vegiPaymentQrCode : qrcode;
      final ByteData qrData = await rootBundle.load(qrAssetPath);
      Uint8List qrBytes = qrData.buffer.asUint8List();
      img.Image? qrImage = img.decodeImage(qrBytes);
      if (qrImage != null) {
        qrImage = img.copyResize(
          qrImage,
          width: isWidePrinter ? 200 : 180,
          height: isWidePrinter ? 200 : 180,
        );
        qrBytes = Uint8List.fromList(img.encodePng(qrImage));
      }
      await printerInstance.printImageBytes(
        printer: printer,
        imageBytes: qrBytes,
        printOnBle: true,
      );

      final profile = await CapabilityProfile.load();
      final generator = Generator(paperSize, profile);
      final cutCommand = generator.cut();
      await printerInstance.printData(printer, cutCommand, longData: true);

      await printerInstance.disconnect(printer);
      debugPrint('Printing completed with logo, QR code & auto-cut ✅');
    } catch (e) {
      debugPrint('Error while printing: $e');
    }
  }

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
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
            const Text(
              '-----------------------------------------------------------------------------',
            ),
            const SizedBox(height: 5),
            isCategory2
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow('Name:', data.customerName),
                    const SizedBox(height: 8),
                    _infoRow('Phone Number:', data.phoneNumber),
                    const SizedBox(height: 8),
                    _infoRow('Address:', data.address),
                  ],
                )
                : _buildRow('Product:', data.productName?.toString() ?? ''),
            const SizedBox(height: 10),
            isCategory2
                ? _buildSparesTable()
                : _buildRow(
                  'Order/Complaint:',
                  data.complaint?.toString() ?? '',
                ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment:
                  isCategory2 ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Text(isCategory2 ? 'Total Price:' : 'JobId:', style: boldStyle),
                const SizedBox(width: 4),
                Text(
                  isCategory2
                      ? (data.totalAmount?.toString() ?? '')
                      : (data.jobId?.toString() ?? ''),
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Thanks & Regards:',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            if (widget.companyName != null)
              Text(
                widget.companyName!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            Text(
              widget.companyPhone?.toString() ?? '',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            const Text(
              '---------------------------------------------------------------------------------',
            ),
            const SizedBox(height: 8),
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
            const SizedBox(height: 120),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: buildButton(text: 'Print', handleAction: _printReceipt),
      ),
    );
  }

  Widget _infoRow(String label, String value) => Row(
    children: [
      Text(label, style: boldStyle),
      const SizedBox(width: 6),
      Expanded(child: Text(value ?? '', style: normalStyle)),
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
                  child: Text(
                    spare.product?.toString() ?? '',
                    style: normalStyle,
                  ),
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
}
