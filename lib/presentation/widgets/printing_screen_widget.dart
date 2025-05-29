import 'package:assistify/core/constants/colors.dart';
import 'package:assistify/core/constants/sizes.dart';
import 'package:assistify/presentation/cubit/dashboard/all_bills/all_bills_cubit.dart';
import 'package:assistify/presentation/cubit/dashboard/all_bills/all_bills_state.dart';
import 'package:assistify/presentation/cubit/dashboard/user_profile/user_profile_cubit.dart';
import 'package:assistify/presentation/cubit/dashboard/user_profile/user_profile_state.dart';
import 'package:assistify/presentation/widgets/bluetooth_print_widet.dart';
import 'package:assistify/presentation/widgets/generate_pdf_widget.dart';
import 'package:assistify/presentation/widgets/helper_widgets.dart/button_widget.dart';
import 'package:assistify/presentation/widgets/helper_widgets.dart/printing_screen_helper_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PrintingCard extends StatefulWidget {
  final String? title;
  final dynamic data;
  num? category;
  final String? companyName;
  PrintingCard({super.key, this.title, required this.data, this.category, this.companyName});
  @override
  State<PrintingCard> createState() => _PrintingCardState();
}

class _PrintingCardState extends State<PrintingCard> {
  void initState() {
    super.initState();
    print(widget.category);
    context.read<AllBillsCubit>().spareBills(
      context: context,
      jobId: widget.data.id,
    );
    userBanner();
  }

  String bannerImage = '';
  String logo = '';

  userBanner() async {
    final userProfileCubit = context.read<UserProfileCubit>();
    await userProfileCubit.userProfile(context, widget.data.companyId);
    final profile = userProfileCubit.state;
    if (profile is UserProfileLoaded) {
      bannerImage = profile.userProfileModel.data?.bannerImage ?? '';
      logo = profile.userProfileModel.data?.logo ?? '';
    }
  }

  dynamic spare_Bills = [];
  Future<void> _handlePrintAction() async {
    final pdf = await generatePdf(
      widget.title,
      widget.data,
      spare_Bills,
      bannerImage,
      context,
      widget.category,
    );
    final bytes = await pdf.save();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.print),
                title: Text('Print Document'),
                onTap: () async {
                  Navigator.pop(context);
                  await Printing.layoutPdf(
                    onLayout: (PdfPageFormat format) async => bytes,
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.share),
                title: Text('Share PDF'),
                onTap: () async {
                  Navigator.pop(context);
                  final dir = await getTemporaryDirectory();
                  final file = File('${dir.path}/${DateTime.now().toString()}_${widget.title}.pdf');
                  await file.writeAsBytes(bytes);
                  await Share.shareXFiles(
                    [XFile(file.path)],
                    text: 'Share PDF Document',
                    subject: '${widget.title}_${DateTime.now().toString()}' ?? 'Document',
                  );
                },
              ),
              SizedBox(height: 30,)
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        shadowColor: Colors.black,
        backgroundColor: AppColor.white,
        title: Text(widget.title ?? ''),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: AppColor.white,
      body: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.all(16),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: getHeight(context) * 0.01),
              buildButton(
                text: "Share",
                icon: Icons.share,
                handleAction: _handlePrintAction,
              ),
              buildButton(
                text: "Print",
                icon: Icons.print,
                handleAction: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return PrintScreen(data: widget.data, companyName: widget.companyName, category: widget.category, spares : spare_Bills, logo : logo);
                    },
                  );
                },
              ),
              SizedBox(height: getHeight(context) * 0.02),
              Center(
                child: Text(
                  widget.title ?? '',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Customer Details",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColor.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    buildInfoRow(
                      '${widget.title} ID:',
                      '${widget.data.jobId ?? ''}',
                    ),
                    buildInfoRow("Name: ", '${widget.data.customerName ?? ''}'),
                    buildInfoRow("date: ", '${widget.data.createdAt ?? ''}'),
                    buildInfoRow("Address: ", '${widget.data.address ?? ''}'),
                    buildInfoRow("ph No: ", '${widget.data.phoneNumber ?? ''}'),
                    SizedBox(height: getHeight(context) * 0.02),
                   widget.category == 2 ? SizedBox() : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "PRODUCT & COMPLAINT INFO:",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColor.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        buildInfoRow(
                          "Product: ",
                          '${widget.data.productName ?? ''}',
                        ),
                        buildInfoRow(
                          "Model No: ",
                          '${widget.data.modelNumber ?? ''}',
                        ),
                        buildInfoRow(
                          "Serial No: ",
                          '${widget.data.serialNumber ?? ''}',
                        ),
                        buildInfoRow(
                          "Complaint: ",
                          '${widget.data.complaint ?? ''}',
                        ),
                        buildInfoRow(
                          "Accessories: ",
                          '${widget.data.otherAccessories?.isNotEmpty == true ? widget.data.otherAccessories : '--'}',
                        ),
                      ],
                    ),
                    SizedBox(height: getHeight(context) * 0.02),
                    Text(
                    widget.category == 2 ? 'ITEMS' :  'SPARES/ESTIMATIONS',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColor.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      color: AppColor.blue,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '#',
                                    style: TextStyle(
                                      color: AppColor.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'DESCRIPTION',
                                    style: TextStyle(
                                      color: AppColor.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'PRICE',
                                    style: TextStyle(
                                      color: AppColor.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'QUANTITY',
                                    style: TextStyle(
                                      color: AppColor.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'TOTAL',
                                    style: TextStyle(
                                      color: AppColor.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: 1,
                                color: Colors.white.withOpacity(0.5),
                                margin: EdgeInsets.symmetric(vertical: 8),
                              ),
                              BlocBuilder<AllBillsCubit, AllBillsState>(
                                builder: (context, state) {
                                  if (state is SpareBillsLoaded &&
                                      state.billSparesModel.data != null) {
                                    final spareBills =
                                        state.billSparesModel.data;
                                    spare_Bills = state.billSparesModel.data;
                                    return Column(
                                      children: List.generate(
                                        spareBills?.length ?? 0,
                                        (index) => Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '${index + 1}',
                                                  style: TextStyle(
                                                    color: AppColor.white,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                Text(
                                                  spareBills?[index].product ??
                                                      '',
                                                  style: TextStyle(
                                                    color: AppColor.white,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                Text(
                                                  spareBills?[index].price
                                                          .toString() ??
                                                      '',
                                                  style: TextStyle(
                                                    color: AppColor.white,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                Text(
                                                  spareBills?[index].quantity
                                                          .toString() ??
                                                      '',
                                                  style: TextStyle(
                                                    color: AppColor.white,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                Text(
                                                  ((spareBills?[index].price ??
                                                              0) *
                                                          (spareBills?[index]
                                                                  .quantity ??
                                                              0))
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: AppColor.white,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              height: 1,
                                              color: Colors.white.withOpacity(
                                                0.5,
                                              ),
                                              margin: EdgeInsets.symmetric(
                                                vertical: 8,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  return const SizedBox();
                                },
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'PAID AMOUNT:',
                                    style: TextStyle(
                                      color: AppColor.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    widget.data.paidAmount?.toString() ?? '0',
                                    style: TextStyle(
                                      color: AppColor.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: 1,
                                color: Colors.white.withOpacity(0.5),
                                margin: EdgeInsets.symmetric(vertical: 8),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'BALANCE:',
                                    style: TextStyle(
                                      color: AppColor.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    ((widget.data.totalAmount ?? 0) -
                                            (widget.data.paidAmount ?? 0))
                                        .toString(),
                                    style: TextStyle(
                                      color: AppColor.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: 1,
                                color: Colors.white.withOpacity(0.5),
                                margin: EdgeInsets.symmetric(vertical: 8),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'GRAND TOTAL:',
                                    style: TextStyle(
                                      color: AppColor.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    widget.data.totalAmount?.toString() ?? '0',
                                    style: TextStyle(
                                      color: AppColor.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: 1,
                                color: Colors.white.withOpacity(0.5),
                                margin: EdgeInsets.symmetric(vertical: 8),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Text('Thank You!', style: TextStyle(fontSize: 16)),
                    SizedBox(height: getHeight(context) * 0.02),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        children: [
                          buildBulletPoint(
                            'The original of this work order this given to the customer as a receipt for your equipment.',
                          ),
                          SizedBox(height: 8),
                          buildBulletPoint(
                            'The recipt should be produced at the time of collection the equipment. No deleveries can be made if this receipt is lost',
                          ),
                          buildBulletPoint(
                            'Our responsibility is limit to serve of this equipment only. We are not responsible for consequential damages arising from delay in non repairs of the equipment.',
                          ),
                          buildBulletPoint(
                            'Equipment should be collected from with 30 days from the date of information on product of this receipt.',
                          ),
                          buildBulletPoint(
                            'Company assumes no responsibility whatever if this equipment not collected within 30 days from the date of',
                          ),
                          buildBulletPoint('Visakhapatnam Jurisdiction'),
                        ],
                      ),
                    ),
                    SizedBox(height: getHeight(context) * 0.02),
                    Text(
                      'I Agreed with the Reported problem, Terms & Conditions',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 43, 42, 38),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: getHeight(context) * 0.02),
                    Text(
                      'Customer Signature',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 43, 42, 38),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'BILL was created on a computer and is valid without the signature and seal.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 43, 42, 38),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
