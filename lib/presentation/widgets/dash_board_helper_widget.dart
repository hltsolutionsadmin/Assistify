import 'package:assistify/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BuildSearchField extends StatelessWidget {
  final BuildContext context;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final Function(String) onChanged;
  final VoidCallback fetchData;
  final Function(PointerDownEvent)? onTapOutside;

  const BuildSearchField({
    super.key,
    required this.context,
    required this.searchController,
    required this.searchFocusNode,
    required this.onChanged,
    required this.fetchData,
    this.onTapOutside,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: searchController,
        focusNode: searchFocusNode,
        onChanged: onChanged,
        onTapOutside:
            onTapOutside ??
            (event) {
              searchFocusNode.unfocus();
            },
        onSubmitted: (value) {
          searchFocusNode.unfocus();
        },
        decoration: InputDecoration(
          hintText: 'Search by jobId / Mobile Number',
          prefixIcon: Icon(Icons.search),
          suffixIcon:
              searchController.text.isNotEmpty
                  ? IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      searchController.clear();
                      searchFocusNode.unfocus();
                      fetchData();
                    },
                  )
                  : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
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
      border: OutlineInputBorder(borderSide: BorderSide(color: AppColor.black)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.blue, width: 2.0),
      ),
    ),
    style: TextStyle(color: AppColor.black),
    dropdownColor: AppColor.white,
    onChanged: onChanged,
    items:
        statusList.map((status) {
          return DropdownMenuItem(
            value: status,
            child: Text(status, style: TextStyle(color: AppColor.black)),
          );
        }).toList(),
  );
}
