import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

Future<pw.Document> generatePdf(title, data) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,

            children: [
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
                        children: [pw.Text('Date:'), pw.Text('sept-25-2024')],
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

                  pw.Column(
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
              pw.Text(
                'SPARES/ESTIMATIONS',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Column(
                children: [
                  pw.Container(
                    padding: pw.EdgeInsets.all(12),
                    child: pw.Column(
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              '#',
                              style: pw.TextStyle(color: PdfColors.black, fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Text(
                              'DESCRIPTION',
                              style: pw.TextStyle(color: PdfColors.black, fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Text(
                              'PRICE',
                              style: pw.TextStyle(color: PdfColors.black, fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Text(
                              'QUANTITY',
                              style: pw.TextStyle(color: PdfColors.black, fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Text(
                              'TOTAL',
                              style: pw.TextStyle(color: PdfColors.black, fontWeight: pw.FontWeight.bold),
                            ),
                          ],
                        ),
                        pw.Container(
                          height: 1,
                          color: PdfColors.black,
                          margin: pw.EdgeInsets.symmetric(vertical: 8),
                        ),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Text(
                              'SUBTOTAL:',
                              style: pw.TextStyle(color: PdfColors.black, fontWeight: pw.FontWeight.normal),
                            ),
                            pw.SizedBox(width: 8),
                            pw.Text(
                              '2000',
                              style: pw.TextStyle(color: PdfColors.black),
                            ),
                          ],
                        ),
                        pw.Container(
                          height: 1,
                          color: PdfColors.black,
                          margin: pw.EdgeInsets.symmetric(vertical: 8),
                        ),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Text(
                              'PAID AMOUNT:',
                              style: pw.TextStyle(color: PdfColors.black),
                            ),
                            pw.SizedBox(width: 8),
                            pw.Text(
                              '200',
                              style: pw.TextStyle(color: PdfColors.black),
                            ),
                          ],
                        ),
                        pw.Container(
                          height: 1,
                          color: PdfColors.black,
                          margin: pw.EdgeInsets.symmetric(vertical: 8),
                        ),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Text(
                              'BALANCE:',
                              style: pw.TextStyle(color: PdfColors.black),
                            ),
                            pw.SizedBox(width: 8),
                            pw.Text(
                              '1800',
                              style: pw.TextStyle(color: PdfColors.black),
                            ),
                          ],
                        ),
                        pw.Container(
                          height: 1,
                          color: PdfColors.black,
                          margin: pw.EdgeInsets.symmetric(vertical: 8),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.Text('Thank You!'),
              pw.SizedBox(height: 20),
              pw.Text(
                'Terms & Conditions:',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
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
              pw.Text('I Agreed with the Reported problem, Terms & Conditions'),
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