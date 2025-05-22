import 'package:assistify/core/constants/colors.dart';
import 'package:assistify/core/constants/sizes.dart';
import 'package:assistify/data/model/dash_board/all_expences_model.dart';
import 'package:assistify/presentation/cubit/add_expences/add_expences_cubit.dart';
import 'package:assistify/presentation/cubit/dashboard/all_expences/all_expences_cubit.dart';
import 'package:assistify/presentation/cubit/dashboard/all_expences/all_expences_state.dart';
import 'package:assistify/presentation/screen/add_expences/add_expences_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpencesScreen extends StatefulWidget {
  @override
  State<ExpencesScreen> createState() => _ExpencesScreenState();
}

class _ExpencesScreenState extends State<ExpencesScreen> {
  late AllExpencesCubit _expensesCubit;
  late AddExpencesCubit _addExpensesCubit;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _expensesCubit = context.read<AllExpencesCubit>();
    _addExpensesCubit = context.read<AddExpencesCubit>();
  }

  void _fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    final companyId = prefs.getString('companyId') ?? '';
    _expensesCubit.all_expences(context, companyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddExpenseScreen()),
            );
        })],
      ),
      backgroundColor: AppColor.white,
      body: Stack(
        children: [
          BlocBuilder<AllExpencesCubit, AllExpencesState>(
            builder: (context, state) {
              if (state is AllExpencesLoading && !_isDeleting) {
                return const Center(
                  child: CupertinoActivityIndicator(color: Colors.blue),
                );
              } else if (state is AllExpencesLoaded) {
                final products = state.allExpencesModel.data;
                return Column(
                  children: [
                    SizedBox(height: getHeight(context) * 0.02),
                    Expanded(
                      child: ListView.builder(
                        itemCount: products?.length ?? 0,
                        itemBuilder: (_, i) {
                          final product = products?[i];
                          if (product == null) {
                            return const SizedBox();
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ExpenseCard(
                              expense: product,
                              onDelete: (id, companyId) async {
                                setState(() => _isDeleting = true);
                                await _addExpensesCubit.delete_Expence(
                                  context,
                                  id,
                                  companyId,
                                );
                                setState(() => _isDeleting = false);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
              return Center(
                child: Text(
                  state is AllExpencesError
                      ? "No data available"
                      : "",
                ),
              );
            },
          ),
          if (_isDeleting)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CupertinoActivityIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}

class ExpenseCard extends StatelessWidget {
  final Data expense;
  final Function(String, String) onDelete;

  const ExpenseCard({
    super.key,
    required this.expense,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        color: AppColor.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF01579B),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          expense.category ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          expense.description ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddExpenseScreen(
                           title: 'Edit Expense',
                           data: expense,
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.white),
                    onPressed: () {
                      _showDeleteDialog(context);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black87, fontSize: 14),
                      children: [
                        const TextSpan(
                          text: 'Price: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: '\₹ ${expense.amount}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black87, fontSize: 14),
                      children: [
                        const TextSpan(
                          text: 'Created Date: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: expense.expenseDate ?? ''),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 10,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.redAccent,
                    size: 30,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Delete Expence',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Are you sure you want to delete this expence ?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      if (expense.id != null && expense.companyId != null) {
                        onDelete(expense.id!, expense.companyId!);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Delete',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
