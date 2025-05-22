import 'package:assistify/core/constants/colors.dart';
import 'package:assistify/presentation/cubit/dashboard/all_bills/all_bills_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget BuildSearchField({required BuildContext context, required searchController, searchFocusNode, required fetchData, required userId, required companyId}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: TextField(
        controller: searchController,
        focusNode: searchFocusNode,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        autofocus: false,
        style: TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search by jobId',
          prefixIcon: Icon(Icons.search),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    fetchData();
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColor.gray),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColor.gray),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColor.blue, width: 2),
          ),
          filled: true,
          fillColor: AppColor.white,
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          isDense: true,
        ),
        onChanged: (value) {
          if (value.isEmpty) {
            fetchData();
          } else {
            Future.delayed(Duration(milliseconds: 100), () {
              if (value == searchController.text) {
                context.read<AllBillsCubit>().searchBills(
                  context: context,
                  jobId: value,
                  userId: userId,
                  companyId: companyId
                );
              }
            });
          }
        },
      ),
    );
  }

    Widget BuildDrawerItem(
    IconData icon,
    String title,
    VoidCallback onTap, [
    Color? color,
  ]) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColor.blue),
      title: Text(title, style: TextStyle(color: color)),
      onTap: onTap,
    );
  }
  
    Widget BuildDropdown(selectedStatus, List<String> statusList, onChanged) {
    return DropdownButtonFormField<String>(
  focusColor: AppColor.blue,
  value: selectedStatus,
  decoration: InputDecoration(
    labelText: 'Select status',
    labelStyle: TextStyle(color: AppColor.black),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: AppColor.black),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColor.blue, width: 2.0),
    ),
  ),
  style: TextStyle(color: AppColor.black),
  dropdownColor: AppColor.white,
  onChanged: onChanged,
  items: statusList.map((status) {
    return DropdownMenuItem(
      value: status,
      child: Text(status, style: TextStyle(color: AppColor.black)),
    );
  }).toList(),
);

  }
