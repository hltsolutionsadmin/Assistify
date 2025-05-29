import 'dart:convert';
import 'dart:typed_data';

import 'package:assistify/core/constants/colors.dart';
import 'package:assistify/core/constants/imgs_const.dart';
import 'package:assistify/data/model/dash_board/bill_spares_model.dart';
import 'package:assistify/presentation/widgets/helper_widgets.dart/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer_library.dart';

class PrintScreen extends StatefulWidget {
  dynamic data;
  String? companyName;
  num? category;
  List<dynamic>? spares;
  String? logo;

  PrintScreen({
    Key? key,
    this.data,
    this.companyName,
    this.category,
    this.spares,
    this.logo,
  }) : super(key: key);
  @override
  _PrintScreenState createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {
  Uint8List? bytes;
  image() {
    if (widget.logo != null && widget.logo!.isNotEmpty) {
      final base64String = widget.logo?.split(',').last;
      bytes = base64Decode(base64String.toString());
    }
  }

  ReceiptController? controller;
  @override
  String productsText = '';

  void initState() {
    super.initState();
    if (widget.spares != null) {
      productsText = widget.spares!.map((e) => e.product).join(', ');
      print(productsText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mobile Print"),
        centerTitle: true,
        backgroundColor: AppColor.white,
        shadowColor: AppColor.white,
      ),
      body: Receipt(
        builder:
            (context) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    bytes == null
                        ? Image.asset(Logo, width: 100, height: 100)
                        : SizedBox(),
                    if (bytes != null)
                      Image.memory(bytes!, height: 150, width: 500),
                    Column(
                      children: [
                        Text(
                          widget.companyName ?? '',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text('------------------------'),
                SizedBox(height: 10),
                widget.category == 2
                    ? Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Name:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.data.customerName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Phone Number:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.data.phoneNumber,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Address:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.data.address,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Text('------------------------'),
                      ],
                    )
                    : Row(
                      children: [
                        Text(
                          'Product:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.data.productName.toString(),
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                SizedBox(height: 10),
                widget.category == 2
                    ? Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Item',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Quantity',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Price',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              ...widget.spares!
                                  .map(
                                    (spare) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4.0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              spare.product,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              spare.quantity.toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '₹${spare.price}',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ],
                          ),
                        ),
                      ],
                    )
                    : Row(
                      children: [
                        Text(
                          'Order/Complaint:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.data.complaint,
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                SizedBox(height: 10),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,

                      children: [
                        Text(
                          widget.category == 2 ? 'Total Price:' : 'JobId:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.category == 2
                              ? widget.data?.totalAmount.toString() ?? ''
                              : widget.data.jobId.toString(),
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                widget.category == 2
                    ? SizedBox()
                    : Row(
                      children: [
                        Text(
                          'Status:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.data.status.toString(),
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                SizedBox(height: 10),
                Text(
                  'Thanks & Regards:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 5),
                Text(
                  widget.companyName ?? '',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  widget.data.phoneNumber.toString(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 5),
                Text('------------------------'),
                SizedBox(height: 5),
                Center(child: Image.asset(qrcode, width: 150, height: 150)),
                SizedBox(height: 80),
              ],
            ),
        onInitialized: (controller) {
          this.controller = controller;
        },
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
              print("failed print");
            }
          },
        ),
      ),
    );
  }
}
