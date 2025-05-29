import 'package:assistify/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SpareItemsBox extends StatefulWidget {
  final int index;
  final Map<String, dynamic> spareBox;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onDescriptionChanged;
  final ValueChanged<String> onQuantityChanged;
  final ValueChanged<String> onPriceChanged;
  final VoidCallback onDelete;
  final String? selectedProduct;
  final bool showOtherItemsFields;

  const SpareItemsBox({
    Key? key,
    required this.index,
    required this.spareBox,
    required this.onNameChanged,
    required this.onDescriptionChanged,
    required this.onQuantityChanged,
    required this.onPriceChanged,
    required this.onDelete,
    this.selectedProduct,
    required this.showOtherItemsFields,
  }) : super(key: key);

  @override
  _SpareBoxState createState() => _SpareBoxState();
}

class _SpareBoxState extends State<SpareItemsBox> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.spareBox['name'] ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.spareBox['description'] ?? '',
    );
    _quantityController = TextEditingController(
      text:
          widget.spareBox['quantity'] == 0
              ? ''
              : widget.spareBox['quantity'].toString(),
    );
    _priceController = TextEditingController(
      text:
          widget.spareBox['price'] == 0.0
              ? ''
              : widget.spareBox['price'].toString(),
    );
  }

  @override
  void didUpdateWidget(covariant SpareItemsBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.spareBox['name'] != oldWidget.spareBox['name']) {
      _nameController.text = widget.spareBox['name'] ?? '';
    }
    if (widget.spareBox['description'] != oldWidget.spareBox['description']) {
      _descriptionController.text = widget.spareBox['description'] ?? '';
    }
    if (widget.spareBox['quantity'] != oldWidget.spareBox['quantity']) {
      final newQuantity =
          widget.spareBox['quantity'] == 0
              ? ''
              : widget.spareBox['quantity'].toString();
      if (_quantityController.text != newQuantity) {
        _quantityController.text = newQuantity;
      }
    }
    if (widget.spareBox['price'] != oldWidget.spareBox['price']) {
      final newPrice =
          widget.spareBox['price'] == 0.0
              ? ''
              : widget.spareBox['price'].toString();
      if (_priceController.text != newPrice) {
        _priceController.text = newPrice;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      child: Container(
        color: AppColor.white,
        child: Padding(
          padding: EdgeInsets.all(4),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.cancel, color: AppColor.red),
                    onPressed: widget.onDelete,
                  ),
                ],
              ),
              
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: widget.onNameChanged,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: widget.onDescriptionChanged,
                      ),
                    ),
                  ],
                ),
              
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _quantityController,
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        labelStyle: TextStyle(
                          color: AppColor.black,
                          fontSize: 14,
                        ),
                        focusColor: AppColor.blue,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColor.gray),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColor.gray),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColor.blue,
                            width: 2,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: widget.onQuantityChanged,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _priceController,
                      decoration: InputDecoration(
                        labelText: 'Price',
                        labelStyle: TextStyle(
                          color: AppColor.black,
                          fontSize: 14,
                        ),
                        focusColor: AppColor.blue,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColor.gray),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColor.gray),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColor.blue,
                            width: 2,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'),
                        ),
                      ],
                      onChanged: widget.onPriceChanged,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Amount: ₹${((widget.spareBox['quantity'] ?? 0) * (widget.spareBox['price'] ?? 0.0)).toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ]
          ),
        ),
      ),
    );
  }
}
