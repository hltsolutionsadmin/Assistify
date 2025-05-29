import 'package:assistify/core/constants/colors.dart';
import 'package:assistify/presentation/screen/addjob/add_items_screen.dart';
import 'package:assistify/presentation/screen/addjob/add_job_form_screen.dart';
import 'package:flutter/material.dart';

class AddFormScreen extends StatefulWidget {
  num? category;
final dynamic jobData;
  String? companyName;
  AddFormScreen({Key? key, this.companyName, this.category, this.jobData})
    : super(key: key);
  @override
  _AddFormScreenState createState() => _AddFormScreenState();
}


class _AddFormScreenState extends State<AddFormScreen> {
//   @override
// void initState() {
//   super.initState();
//   print(widget.category);
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: widget.category == 2 ? AddItemsScreen(companyName:widget.companyName, category: widget.category,) : AddJobFormScreen(
        // companyName: widget.companyName,
        //  jobData: widget.jobData,
      ),
    );
  }
}
