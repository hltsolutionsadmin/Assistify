import 'package:assistify/core/constants/colors.dart';
import 'package:assistify/presentation/widgets/add-job_form_screen_widgets.dart/custom_drop_down_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SpareBox extends StatefulWidget {
  final int index;
  final Map<String, dynamic> spareBox;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onDescriptionChanged;
  final ValueChanged<String> onQuantityChanged;
  final ValueChanged<String> onPriceChanged;
  final VoidCallback onDelete;
  final VoidCallback onSelectProductTap;
  final String? selectedProduct;
  final bool showOtherItemsFields;

  const SpareBox({
    Key? key,
    required this.index,
    required this.spareBox,
    required this.onNameChanged,
    required this.onDescriptionChanged,
    required this.onQuantityChanged,
    required this.onPriceChanged,
    required this.onDelete,
    required this.onSelectProductTap,
    this.selectedProduct,
    required this.showOtherItemsFields,
  }) : super(key: key);

  @override
  State<SpareBox> createState() => _SpareBoxState();
}

class _SpareBoxState extends State<SpareBox> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _quantityController;
  late final TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.spareBox['name'] ?? '');
    _descriptionController = TextEditingController(text: widget.spareBox['description'] ?? '');
    _quantityController = TextEditingController(
      text: widget.spareBox['quantity'] == 0 ? '' : widget.spareBox['quantity'].toString(),
    );
    _priceController = TextEditingController(
      text: widget.spareBox['price'] == 0.0 ? '' : widget.spareBox['price'].toString(),
    );
  }

  void _updateControllers(SpareBox oldWidget) {
    if (widget.spareBox['name'] != oldWidget.spareBox['name']) {
      _nameController.text = widget.spareBox['name'] ?? '';
    }
    if (widget.spareBox['description'] != oldWidget.spareBox['description']) {
      _descriptionController.text = widget.spareBox['description'] ?? '';
    }
    _updateNumericController(
      oldValue: oldWidget.spareBox['quantity'],
      newValue: widget.spareBox['quantity'],
      controller: _quantityController,
      isPrice: false,
    );
    _updateNumericController(
      oldValue: oldWidget.spareBox['price'],
      newValue: widget.spareBox['price'],
      controller: _priceController,
      isPrice: true,
    );
  }

  void _updateNumericController({
    required dynamic oldValue,
    required dynamic newValue,
    required TextEditingController controller,
    required bool isPrice,
  }) {
    if (oldValue != newValue) {
      final compareValue = isPrice ? 0.0 : 0;
      final newText = newValue == compareValue ? '' : newValue.toString();
      if (controller.text != newText) {
        controller.text = newText;
      }
    }
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle:  TextStyle(
        color: AppColor.black,
        fontSize: 14,
      ),
      focusColor: AppColor.blue,
      border:  OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.gray),
      ),
      enabledBorder:  OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.gray),
      ),
      focusedBorder:  OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColor.blue,
          width: 2,
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(SpareBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateControllers(oldWidget);
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
    final double amount = (widget.spareBox['quantity'] ?? 0) * (widget.spareBox['price'] ?? 0.0);
    
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Container(
        color: AppColor.white,
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon:  Icon(Icons.cancel, color: AppColor.red),
                onPressed: widget.onDelete,
              ),
            ),
            CustomDropdownField(
              hintText: 'Select Product',
              selectedValue: widget.selectedProduct,
              onTap: widget.onSelectProductTap,
            ),
            if (widget.showOtherItemsFields) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: widget.onNameChanged,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: widget.onDescriptionChanged,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _quantityController,
                    decoration: _buildInputDecoration('Quantity'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: widget.onQuantityChanged,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _priceController,
                    decoration: _buildInputDecoration('Price'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    onChanged: widget.onPriceChanged,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Amount: ₹${amount.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
