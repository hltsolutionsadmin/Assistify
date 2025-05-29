import 'package:assistify/components/custome_text_field.dart';
import 'package:assistify/core/constants/colors.dart';
import 'package:assistify/presentation/cubit/add_products/add_products_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProductScreen extends StatefulWidget {
  final String? title;
  final dynamic data;
  const AddProductScreen({super.key, this.title, this.data});
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productQuantityController = TextEditingController();
  final TextEditingController _productDescriptionController = TextEditingController();
  
  bool errorName = false;
  bool errorPrice = false;
  bool errorQuantity = false;
  bool errorDescription = false;
  String userId = '';
  String companyId = '';
  bool isLoading = false;
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    isEditMode = widget.title == 'edit Product';
    fetchData();
  }

  void fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
    companyId = prefs.getString('companyId') ?? '';
    
    if (isEditMode && widget.data != null) {
      _productNameController.text = widget.data.productName ?? '';
      _productPriceController.text = widget.data.price?.toString() ?? '';
      _productQuantityController.text = widget.data.quantity?.toString() ?? '';
      _productDescriptionController.text = widget.data.description ?? '';
    }
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _productPriceController.dispose();
    _productQuantityController.dispose();
    _productDescriptionController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    setState(() {
      isLoading = true;
      errorName = _productNameController.text.isEmpty;
      errorPrice = _productPriceController.text.isEmpty;
      errorQuantity = _productQuantityController.text.isEmpty;
    });

    if (errorName || errorPrice || errorQuantity) {
      setState(() => isLoading = false);
      return;
    }

    final productData = {
      "productName": _productNameController.text,
      "price": _productPriceController.text,
      "quantity": _productQuantityController.text,
      "description": _productDescriptionController.text,
      "userId": userId,
      "companyId": companyId,
    };

    final editProductData = {
      "productName": _productNameController.text,
      "price": _productPriceController.text,
      "quantity": _productQuantityController.text,
      "description": _productDescriptionController.text,
      "userId": userId,
      "companyId": companyId,
      "id":widget.data?.id,
    };

    if (isEditMode) {
      productData["productId"] = widget.data.id;
      context.read<AddProductsCubit>().edit_product(context, editProductData, companyId);
    } else {
      context.read<AddProductsCubit>().add_products(context, productData, companyId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Product' : 'Add Product'),
        elevation: 2,
        centerTitle: true,
        backgroundColor: AppColor.white,
        shadowColor: AppColor.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              customTextField(
                _productNameController,
                'Product Name',
                errorText: errorName ? 'Please enter a product name' : null,
                onChanged: (value) => setState(() => errorName = value.isEmpty),
              ),
              customTextField(
                _productPriceController,
                'Product Price',
                errorText: errorPrice ? 'Please enter a product price' : null,
                onChanged: (value) => setState(() => errorPrice = value.isEmpty),
              ),
              customTextField(
                _productQuantityController,
                'Quantity',
                errorText: errorQuantity ? 'Please enter a quantity' : null,
                onChanged: (value) => setState(() => errorQuantity = value.isEmpty),
              ),
              customTextField(
                _productDescriptionController,
                'Description',
                // errorText: errorDescription ? 'Please enter a description' : null,
                onChanged: (value) => setState(() => errorDescription = value.isEmpty),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: isLoading 
                    ? const CupertinoActivityIndicator(color: Colors.white)
                    : Text(
                        isEditMode ? 'Update Product' : 'Add Product',
                        style: TextStyle(
                          color: AppColor.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}