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
  final int maxQuantity;
  final String? prodId;

  const SpareBox({
    super.key,
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
    required this.maxQuantity,
    this.prodId,
  });

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
    _nameController = TextEditingController(
      text: widget.spareBox['name'] ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.spareBox['description'] ?? '',
    );
    _quantityController = TextEditingController(
      text:
          (widget.spareBox['quantity'] == null ||
                  widget.spareBox['quantity'] == 0)
              ? ''
              : widget.spareBox['quantity'].toString(),
    );
    _priceController = TextEditingController(
      text:
          (widget.spareBox['price'] == null || widget.spareBox['price'] == 0.0)
              ? ''
              : widget.spareBox['price'].toString(),
    );
  }

  @override
void didUpdateWidget(covariant SpareBox oldWidget) {
  print(widget.spareBox['name']);
  super.didUpdateWidget(oldWidget);

  _conditionallyUpdateControllerText(
    _nameController,
    widget.spareBox['name'] == 'Others Items' ? '' : widget.spareBox['name']  ?? '',
  );

  _conditionallyUpdateControllerText(
    _descriptionController,
    widget.spareBox['description'] ?? '',
  );

  _conditionallyUpdateControllerText(
    _quantityController,
    (widget.spareBox['quantity'] == null || widget.spareBox['quantity'] == 0)
        ? ''
        : widget.spareBox['quantity'].toString(),
  );

  _conditionallyUpdateControllerText(
    _priceController,
    (widget.spareBox['price'] == null || widget.spareBox['price'] == 0.0)
        ? ''
        : widget.spareBox['price'].toString(),
  );
}


void _conditionallyUpdateControllerText(TextEditingController controller, String newText) {
  if (controller.text != newText) {
    final cursorPosition = controller.selection.baseOffset;
    controller.text = newText;
    if (cursorPosition >= 0 && cursorPosition <= newText.length) {
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: cursorPosition),
      );
    }
  }
}

  InputDecoration _buildInputDecoration(String label) => InputDecoration(
    labelText: label,
    labelStyle: TextStyle(color: AppColor.black, fontSize: 14),
    focusColor: AppColor.blue,
    border: OutlineInputBorder(borderSide: BorderSide(color: AppColor.gray)),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColor.gray),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColor.blue, width: 2),
    ),
  );

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
    final double amount =
        (widget.spareBox['quantity'] ?? 0) * (widget.spareBox['price'] ?? 0.0);
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
                icon: Icon(Icons.cancel, color: AppColor.red),
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
                      decoration: _buildInputDecoration('Name'),
                      onChanged: widget.onNameChanged,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _descriptionController,
                      decoration: _buildInputDecoration('Description'),
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
                  child: TextFormField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      if (widget.selectedProduct == 'Others Items') {
                        widget.onQuantityChanged(value);
                      } else {
                        final parsed = int.tryParse(value) ?? 0;
                        if (parsed <= widget.maxQuantity) {
                          widget.onQuantityChanged(value);
                        } else {
                          _quantityController.text =
                              widget.maxQuantity.toString();
                          _quantityController
                              .selection = TextSelection.fromPosition(
                            TextPosition(
                              offset: _quantityController.text.length,
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Maximum quantity is ${widget.maxQuantity}',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                          widget.onQuantityChanged(
                            widget.maxQuantity.toString(),
                          );
                        }
                      }
                    },
                    decoration: _buildInputDecoration('Quantity'),
                  ),
                ),
                const SizedBox(width: 8),

                Expanded(
                  child: TextField(
                    controller: _priceController,
                    readOnly: widget.selectedProduct != 'Others Items',
                    onChanged: (value) {
                      widget.onPriceChanged(value);
                    },
                    decoration: _buildInputDecoration('Price'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Amount: ₹${amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
