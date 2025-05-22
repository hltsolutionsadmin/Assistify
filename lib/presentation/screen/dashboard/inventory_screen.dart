import 'package:assistify/core/constants/colors.dart';
import 'package:assistify/core/constants/sizes.dart';
import 'package:assistify/data/model/dash_board/inventory_products_model.dart';
import 'package:assistify/presentation/cubit/dashboard/inventory_products/inventory_products_state.dart';
import 'package:assistify/presentation/cubit/dashboard/inventory_products/inventory_produts_cubit.dart';
import 'package:assistify/presentation/screen/add_product/add_product_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InventoryScreen extends StatefulWidget {
  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  bool _isDeleting = false;
  List<Data>? _cachedProducts;

  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    final companyId = prefs.getString('companyId') ?? '';
    context.read<InventoryProdutsCubit>().inventory_products(
      context,
      companyId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        centerTitle: true,
        elevation: 2,
        backgroundColor: AppColor.white,
        shadowColor: AppColor.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [IconButton(icon: Icon(Icons.add), onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProductScreen(),
            ),
          );
        })],
      ),
      backgroundColor: AppColor.white,
      body: Stack(
        children: [
          BlocBuilder<InventoryProdutsCubit, InventoryProductsState>(
            builder: (context, state) {
              if (state is InventoryProductsLoading && !_isDeleting) {
                return Center(
                  child: const CupertinoActivityIndicator(color: Colors.blue),
                );
              } else if (state is InventoryProductsLoaded) {
                _cachedProducts = List.from(state.invenoryModel.data ?? []);
                return _buildProductList(_cachedProducts);
              } else if (_isDeleting && _cachedProducts != null) {
                return _buildProductList(_cachedProducts);
              }
              return Center(
                child: Text(
                  state is InventoryProductsError
                      ? "Error loading products"
                      : "No products available",
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              );
            },
          ),
          if (_isDeleting)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: CupertinoActivityIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductList(List<Data>? products) {
    return Column(
      children: [
        SizedBox(height: getHeight( context) * 0.02,),
        Expanded(
          child: ListView.builder(
            itemCount: products?.length ?? 0,
            itemBuilder: (_, i) {
              final product = products?[i];
              if (product == null) {
                return SizedBox();
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ProductCard(
                  product: product,
                  onDeleteStart: () {
                    setState(() {
                      _isDeleting = true;
                      _cachedProducts?.removeWhere((p) => p.id == product.id);
                    });
                  },
                  onDeleteComplete: () => setState(() => _isDeleting = false),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ProductCard extends StatelessWidget {
  final Data product;
  final VoidCallback onDeleteStart;
  final VoidCallback onDeleteComplete;

  const ProductCard({
    required this.product,
    required this.onDeleteStart,
    required this.onDeleteComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColor.white,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColor.blue,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.productName ?? '',
                        style: TextStyle(
                          color: AppColor.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (product.description != null)
                        Text(
                          product.description!,
                          style: TextStyle(color: AppColor.white, fontSize: 14),
                        ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: AppColor.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddProductScreen(
                              title: 'edit Product',
                              data: product,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: AppColor.white),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
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
                                    children: [
                                      Icon(
                                        Icons.warning_amber_rounded,
                                        color: Colors.redAccent,
                                        size: 30,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Delete Product',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'Are you sure you want to delete this product?',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.grey[700],
                                        ),
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      ElevatedButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          onDeleteStart();
                                          await context
                                              .read<InventoryProdutsCubit>()
                                              .delete_product(
                                                context,
                                                product.id!,
                                                product.companyId!,
                                              );
                                          onDeleteComplete();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.redAccent,
                                          foregroundColor: Colors.white,
                                          elevation: 2,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Text(
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
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    text: 'Price: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: '\₹ ${product.price}',
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                Text.rich(
                  TextSpan(
                    text: 'Quantity: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: '${product.quantity}',
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
