import 'package:assistify/core/constants/colors.dart';
import 'package:assistify/core/constants/sizes.dart';
import 'package:assistify/presentation/cubit/dashboard/all_bills/all_bills_cubit.dart';
import 'package:assistify/presentation/cubit/dashboard/all_bills/all_bills_state.dart';
import 'package:assistify/presentation/cubit/dashboard/user_profile/user_profile_cubit.dart';
import 'package:assistify/presentation/cubit/dashboard/user_profile/user_profile_state.dart';
import 'package:assistify/presentation/widgets/bluetooth_print_widet.dart';
import 'package:assistify/presentation/widgets/date_converter_widget.dart';
import 'package:assistify/presentation/widgets/generate_pdf_widget.dart';
import 'package:assistify/presentation/widgets/helper_widgets.dart/button_widget.dart';
import 'package:assistify/presentation/widgets/helper_widgets.dart/printing_screen_helper_widget.dart';
import 'package:flutter/cupertino.dart';
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
  final num? category;
  final String? companyName;
  const PrintingCard({
    super.key,
    this.title,
    required this.data,
    this.category,
    this.companyName,
  });

  @override
  State<PrintingCard> createState() => _PrintingCardState();
}

class _PrintingCardState extends State<PrintingCard> {
  late String bannerImage = '';
  late String logo = '';
  List<dynamic> spareBills = [];

  @override
  void initState() {
    super.initState();
    _loadUserBanner();
    context.read<AllBillsCubit>().spareBills(
      context: context,
      jobId: widget.data.id,
    );
  }

  Future<void> _loadUserBanner() async {
    final userProfileCubit = context.read<UserProfileCubit>();
    await userProfileCubit.userProfile(context, widget.data.companyId);
    final profile = userProfileCubit.state;
    if (profile is UserProfileLoaded) {
      setState(() {
        bannerImage = profile.userProfileModel.data?.bannerImage ?? '';
        logo = profile.userProfileModel.data?.logo ?? '';
      });
    }
  }

  Future<void> _handlePrintAction() async {
    final pdf = await generatePdf(
      widget.title,
      widget.data,
      spareBills,
      bannerImage,
      context,
      widget.category,
      widget.companyName
    );
    final bytes = await pdf.save();

    showModalBottomSheet(
      context: context,
      builder:
          (context) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.print),
                  title: const Text('Print Document'),
                  onTap: () async {
                    Navigator.pop(context);
                    await Printing.layoutPdf(
                      onLayout: (PdfPageFormat format) async => bytes,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Share PDF'),
                  onTap: () async {
                    Navigator.pop(context);
                    final dir = await getTemporaryDirectory();
                    final file = File(
                      '${dir.path}/${DateTime.now()}_${widget.title}.pdf',
                    );
                    await file.writeAsBytes(bytes);
                    await Share.shareXFiles(
                      [XFile(file.path)],
                      text: 'Share PDF Document',
                      subject: '${widget.title}_${DateTime.now()}',
                    );
                  },
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
    final sectionTitleStyle = TextStyle(
      fontSize: 16,
      color: AppColor.black,
      fontWeight: FontWeight.bold,
    );

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
      body: MultiBlocListener(
        listeners: [
          BlocListener<AllBillsCubit, AllBillsState>(
            listener: (context, state) {
            },
          ),
          BlocListener<UserProfileCubit, UserProfileState>(
            listener: (context, state) {
            },
          ),
        ],
        child: BlocBuilder<AllBillsCubit, AllBillsState>(
          builder: (context, billsState) {
            return BlocBuilder<UserProfileCubit, UserProfileState>(
              builder: (context, profileState) {
                if (billsState is SpareBillsLoading ||
                    profileState is UserProfileLoading) {
                  return const Center(
                    child: CupertinoActivityIndicator(color: Colors.blue),
                  );
                }

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
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
                                  builder:
                                      (context) => PrintScreen(
                                        data: widget.data,
                                        companyName: widget.companyName,
                                        category: widget.category,
                                        spares: spareBills,
                                        logo: logo,
                                      ),
                                );
                              },
                            ),
                            SizedBox(height: getHeight(context) * 0.02),
                            Center(
                              child: Text(
                                widget.title ?? '',
                                style: titleStyle,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Customer Details",
                                  style: sectionTitleStyle,
                                ),
                                buildInfoRow(
                                  '${widget.title} ID:',
                                  '${widget.data.jobId ?? ''}',
                                ),
                                buildInfoRow(
                                  "Name: ",
                                  '${widget.data.customerName ?? ''}',
                                ),
                                buildInfoRow(
                                  "date: ",
                                  formatDate(widget.data.createdAt ?? ''),
                                ),
                                buildInfoRow(
                                  "Address: ",
                                  '${widget.data.address ?? ''}',
                                ),
                                buildInfoRow(
                                  "ph No: ",
                                  '${widget.data.phoneNumber ?? ''}',
                                ),
                                SizedBox(height: getHeight(context) * 0.02),
                                if (widget.category != 2)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "PRODUCT & COMPLAINT INFO:",
                                        style: sectionTitleStyle,
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
                                        widget
                                                    .data
                                                    .otherAccessories
                                                    ?.isNotEmpty ==
                                                true
                                            ? widget.data.otherAccessories
                                            : '--',
                                      ),
                                    ],
                                  ),
                                SizedBox(height: getHeight(context) * 0.02),
                                Text(
                                  widget.category == 2
                                      ? 'ITEMS'
                                      : 'SPARES/ESTIMATIONS',
                                  style: sectionTitleStyle,
                                ),
                                Container(
                                  color: AppColor.blue,
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildTableHeader(),
                                      BlocBuilder<AllBillsCubit, AllBillsState>(
                                        builder: (context, state) {
                                          if (state is SpareBillsLoaded &&
                                              state.billSparesModel.data !=
                                                  null) {
                                            spareBills =
                                                state.billSparesModel.data!;
                                            return Column(
                                              children: List.generate(
                                                spareBills.length,
                                                (index) => _buildTableRow(
                                                  spareBills[index],
                                                  index,
                                                ),
                                              ),
                                            );
                                          }
                                          return const SizedBox();
                                        },
                                      ),
                                      _buildAmountRow(
                                        'PAID AMOUNT:',
                                        widget.data.paidAmount?.toString() ??
                                            '0',
                                      ),
                                      _buildAmountRow(
                                        'BALANCE:',
                                        ((widget.data.totalAmount ?? 0) -
                                                (widget.data.paidAmount ?? 0))
                                            .toString(),
                                      ),
                                      _buildAmountRow(
                                        'GRAND TOTAL:',
                                        widget.data.totalAmount?.toString() ??
                                            '0',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Thank You!',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: getHeight(context) * 0.02),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                  ),
                                  child: Column(
                                    children: [
                                      buildBulletPoint(
                                        'The original of this work order this given to the customer as a receipt for your equipment.',
                                      ),
                                      const SizedBox(height: 8),
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
                                      buildBulletPoint(
                                        'Visakhapatnam Jurisdiction',
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: getHeight(context) * 0.02),
                                const Text(
                                  'I Agreed with the Reported problem, Terms & Conditions',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 43, 42, 38),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: getHeight(context) * 0.02),
                                const Text(
                                  'Customer Signature',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 43, 42, 38),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Text(
                                  'BILL was created on a computer and is valid without the signature and seal.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 43, 42, 38),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    final headerStyle = TextStyle(
      color: AppColor.white,
      fontWeight: FontWeight.bold,
    );
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('#', style: headerStyle),
            Text('DESCRIPTION', style: headerStyle),
            Text('PRICE', style: headerStyle),
            Text('QUANTITY', style: headerStyle),
            Text('TOTAL', style: headerStyle),
          ],
        ),
        Divider(color: Colors.white54, thickness: 1),
      ],
    );
  }

  Widget _buildTableRow(dynamic item, int index) {
    final rowStyle = TextStyle(
      color: AppColor.white,
      fontWeight: FontWeight.w400,
    );
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${index + 1}', style: rowStyle),
            Text(item.product ?? '', style: rowStyle),
            Text(item.price?.toString() ?? '', style: rowStyle),
            Text(item.quantity?.toString() ?? '', style: rowStyle),
            Text(
              ((item.price ?? 0) * (item.quantity ?? 0)).toString(),
              style: rowStyle,
            ),
          ],
        ),
        Divider(color: Colors.white54, thickness: 1),
      ],
    );
  }

  Widget _buildAmountRow(String label, String value) {
    final labelStyle = TextStyle(
      color: AppColor.white,
      fontWeight: FontWeight.w600,
    );
    final valueStyle = TextStyle(
      color: AppColor.white,
      fontWeight: FontWeight.w400,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(label, style: labelStyle),
          const SizedBox(width: 8),
          Text(value, style: valueStyle),
        ],
      ),
    );
  }
}
