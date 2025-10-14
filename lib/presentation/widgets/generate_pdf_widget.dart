import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:assistify/presentation/widgets/date_converter_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

Future<pw.Document> generatePdf(
  String? title,
  dynamic data,
  List<dynamic>? spares,
  String? bannerImage,
  dynamic context,
  num? category,
  String? companyName,
) async {
  final pdf = pw.Document();
  Uint8List? bytes;

  if (bannerImage != null && bannerImage.isNotEmpty) {
    try {
      if (bannerImage.startsWith("http")) {
        final response = await http.get(Uri.parse(bannerImage));
        if (response.statusCode == 200) {
          bytes = response.bodyBytes;
        }
      } else {
        // case: base64
        final String base64String = bannerImage.split(',').last;
        bytes = base64Decode(base64String);
      }
    } catch (e) {
      debugPrint("Error loading banner image: $e");
    }
  }

  int totalItems = spares?.length ?? 0;
  double grandTotal = 0;
  spares?.forEach((spare) {
    grandTotal += (spare.price ?? 0) * (spare.quantity ?? 0);
  });

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            if (bytes != null)
              pw.Image(
                pw.MemoryImage(bytes),
                height: 150,
                width: 500,
              )
            else
              pw.Center(
                child: pw.Text(
                  companyName ?? '',
                  style: pw.TextStyle(fontSize: 32, color: PdfColors.black),
                ),
              ),
            pw.SizedBox(height: 20),
            pw.Center(
              child: pw.Text(
                title ?? '',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Customer Details',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Bill Id:'),
                        pw.Text('${data.jobId ?? ''}'),
                      ],
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Name:'),
                        pw.Text('${data.customerName ?? ''}'),
                      ],
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Date:'),
                        pw.Text(formatDate(data?.createdAt ?? '')),
                      ],
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Address:'),
                        pw.Text('${data.address ?? ''}'),
                      ],
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Ph No:'),
                        pw.Text('${data.phoneNumber ?? ''}'),
                      ],
                    ),
                  ],
                ),
                category == 2
                    ? pw.SizedBox()
                    : pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'PRODUCT & COMPLAINT INFO',
                            style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text('Product:'),
                              pw.Text('${data.productName ?? ''}'),
                            ],
                          ),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text('Model No:'),
                              pw.Text('${data.modelNumber ?? ''}'),
                            ],
                          ),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text('Serial No:'),
                              pw.Text('${data.serialNumber ?? ''}'),
                            ],
                          ),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text('Complaint:'),
                              pw.Text('${data.complaint ?? ''}'),
                            ],
                          ),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text('Accessories:'),
                              pw.Text(
                                '${data.otherAccessories?.isNotEmpty == true ? data.otherAccessories : '--'}',
                              ),
                            ],
                          ),
                        ],
                      ),
              ],
            ),
            pw.SizedBox(height: 10),
            category == 2
                ? pw.Text(
                    'ITEMS',
                    style: pw.TextStyle(
                        fontSize: 16, fontWeight: pw.FontWeight.bold),
                  )
                : pw.Text(
                    'SPARES/ESTIMATIONS',
                    style: pw.TextStyle(
                        fontSize: 16, fontWeight: pw.FontWeight.bold),
                  ),
            pw.Container(
              padding: pw.EdgeInsets.all(12),
              child: pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: pw.FlexColumnWidth(0.5),
                  1: pw.FlexColumnWidth(3),
                  2: pw.FlexColumnWidth(1.5),
                  3: pw.FlexColumnWidth(1.5),
                  4: pw.FlexColumnWidth(1.5),
                },
                children: [
                  // Header row
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text('#',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text('DESCRIPTION',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text('PRICE',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text('QUANTITY',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text('TOTAL',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  // Data rows
                  ...List.generate(
                    spares?.length ?? 0,
                    (index) => pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Text('${index + 1}'),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Text(spares?[index].product ?? ''),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Text(spares?[index].price.toString() ?? ''),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Text(spares?[index].quantity.toString() ?? ''),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Text(
                            ((spares?[index].price ?? 0) *
                                    (spares?[index].quantity ?? 0))
                                .toString(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Total row
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text(''),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text('Total Items: $totalItems',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text(''),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text('Grand Total:',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text('$grandTotal',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            pw.Container(
              alignment: pw.Alignment.centerRight,
              padding: pw.EdgeInsets.all(12),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.Text('PAID AMOUNT:',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(width: 20),
                      pw.Text(data.paidAmount?.toString() ?? '0'),
                    ],
                  ),
                  pw.SizedBox(height: 5),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.Text('BALANCE:',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(width: 20),
                      pw.Text(data.totalAmount?.toString() ?? '0'),
                    ],
                  ),
                ],
              ),
            ),
            pw.Text('Thank You!'),
            pw.SizedBox(height: 20),
            pw.Text(
              'Terms & Conditions:',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
            pw.Bullet(
              text:
                  'The original of this work order this given to the customer as a receipt for your equipment.',
            ),
            pw.Bullet(
              text:
                  'The recipt should be produced at the time of collection the equipment. No deleveries can be made if this receipt is lost',
            ),
            pw.Bullet(
              text:
                  'Our responsibility is limit to serve of this equipment only. We are not responsible for consequential damages arising from delay in non repairs of the equipment.',
            ),
            pw.Bullet(
              text:
                  'Equipment should be collected from with 30 days from the date of information on product of this receipt.',
            ),
            pw.Bullet(
              text:
                  'Company assumes no responsibility whatever if this equipment not collected within 30 days from the date of',
            ),
            pw.Bullet(text: 'Visakhapatnam Jurisdiction'),
            pw.SizedBox(height: 20),
            pw.Text(
                'I Agreed with the Reported problem, Terms & Conditions'),
            pw.SizedBox(height: 20),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Customer Signature'),
                pw.Text('Authorized Signature'),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              'BILL was created on a computer and is valid without the signature and seal.',
              style: pw.TextStyle(fontSize: 10, color: PdfColors.grey),
            ),
          ],
        );
      },
    ),
  );

  return pdf;
}
