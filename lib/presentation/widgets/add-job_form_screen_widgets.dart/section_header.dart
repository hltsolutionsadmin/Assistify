import 'package:assistify/presentation/widgets/add_job_helper_widgets/header_widget.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const SectionHeader(this.icon, this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return sectionHeader(icon, title);
  }
}
