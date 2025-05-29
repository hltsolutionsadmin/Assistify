import 'package:assistify/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget BuildSearchField({
  required BuildContext context,
  required TextEditingController searchController,
  required Function(String) onChanged,
  required fetchData,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
    child: Focus(
      autofocus: false,
      child: Builder(
        builder: (innerContext) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: TextField(
              controller: searchController,
              inputFormatters: [
                // FilteringTextInputFormatter.digitsOnly,
              ],
              autofocus: false,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search by jobId / Mobile Number',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
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
                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                isDense: true,
              ),
              onChanged: onChanged,
            ),
          );
        },
      ),
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
