import 'package:assistify/components/custome_text_field.dart';
import 'package:assistify/core/constants/colors.dart';
import 'package:assistify/core/constants/custome_snack_bar.dart';
import 'package:assistify/core/constants/sizes.dart';
import 'package:assistify/data/model/add_product/get_products_list_model.dart';
import 'package:assistify/presentation/cubit/add_products/add_products_cubit.dart';
import 'package:assistify/presentation/cubit/add_products/add_products_state.dart';
import 'package:assistify/presentation/cubit/dashboard/all_bills/all_bills_cubit.dart';
import 'package:assistify/presentation/cubit/dashboard/all_bills/all_bills_state.dart';
import 'package:assistify/presentation/cubit/dashboard/save_bill/save_bill_cubit.dart';
import 'package:assistify/presentation/widgets/add-job_form_screen_widgets.dart/section_header.dart';
import 'package:assistify/presentation/widgets/add-job_form_screen_widgets.dart/custom_drop_down_field.dart';
import 'package:assistify/presentation/widgets/add-job_form_screen_widgets.dart/spare_box.dart';
import 'package:assistify/presentation/widgets/helper_widgets.dart/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddJobFormScreen extends StatefulWidget {
  final dynamic jobData;
  final String? title;
  final String? companyName;
  const AddJobFormScreen({Key? key, this.jobData, this.title, this.companyName}) : super(key: key);

  @override
  State<AddJobFormScreen> createState() => _AddJobFormScreenState();
}

class _AddJobFormScreenState extends State<AddJobFormScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _userId, _companyId, _statusSelected, _paymentMode = '';
  bool isLoading = false, buttonError = true;

  final _customerNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _alternatePhoneNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _statusDescriptionController = TextEditingController();
  final _productOrderNameController = TextEditingController();
  final _modelNumberController = TextEditingController();
  final _serialNumberController = TextEditingController();
  final _orderComplaintController = TextEditingController();
  final _otherAccessoriesController = TextEditingController();
  final _paidAmountController = TextEditingController();
  final _balanceAmountController = TextEditingController();

  bool _nameError = false, _phoneError = false, _alternatePhoneError = false, _addressError = false,
      _statusDescriptionError = false, _productOrderNameError = false, _modelNumberError = false,
      _serialNumberError = false, _orderComplaintError = false, _otherAccessoriesError = false,
      _paidAmountError = false, _balanceAmountError = false, _sparesError = false, _statusError = false;

  List<Map<String, dynamic>> _spareBoxes = [];
  List<Data> _selectProducts = [];

  static const _statuses = [
    'Received', 'Assigned', 'In Progress', 'Estimated', 'Pending', 'Delivered', 'Completed', 'Paid', "Return"
  ];
  static const _payments = ['card', 'Cash', 'Bank Transfer', 'Upi'];

  @override
  void initState() {
    super.initState();
    _fetchData();
    _paidAmountController.addListener(_updateBalanceAmount);
    if (widget.jobData != null) {
      context.read<AllBillsCubit>().spareBills(context: context, jobId: widget.jobData.id);
    }
    _editDetails();
    _validateItems();
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _phoneNumberController.dispose();
    _alternatePhoneNumberController.dispose();
    _addressController.dispose();
    _statusDescriptionController.dispose();
    _productOrderNameController.dispose();
    _modelNumberController.dispose();
    _serialNumberController.dispose();
    _orderComplaintController.dispose();
    _otherAccessoriesController.dispose();
    _paidAmountController.removeListener(_updateBalanceAmount);
    _paidAmountController.dispose();
    _balanceAmountController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('userId') ?? '';
    _companyId = prefs.getString('companyId') ?? '';
    context.read<AddProductsCubit>().getProduct(context, _companyId!);
  }

  void _editDetails() {
    if (widget.jobData != null) {
      _customerNameController.text = widget.jobData.customerName ?? '';
      _phoneNumberController.text = widget.jobData.phoneNumber ?? '';
      _alternatePhoneNumberController.text = widget.jobData.alternatePhoneNumber ?? '';
      _addressController.text = widget.jobData.address ?? '';
      _statusDescriptionController.text = widget.jobData.statusDescription ?? '';
      _productOrderNameController.text = widget.jobData.productName ?? '';
      _modelNumberController.text = widget.jobData.modelNumber ?? '';
      _serialNumberController.text = widget.jobData.serialNumber ?? '';
      _orderComplaintController.text = widget.jobData.complaint ?? '';
      _otherAccessoriesController.text = widget.jobData.otherAccessories ?? '';
      _paidAmountController.text = widget.jobData.paidAmount?.toString() ?? '';
      _balanceAmountController.text = ((widget.jobData.totalAmount ?? 0) - (widget.jobData.paidAmount ?? 0)).toStringAsFixed(2);
      _statusSelected = widget.jobData.status ?? '';
      _paymentMode = widget.jobData.paymentType ?? '';
    }
  }

  void _updateBalanceAmount() {
    final totalAmount = _spareBoxes.fold<double>(0, (sum, box) => sum + ((box['quantity'] ?? 0) * (box['price'] ?? 0.0)));
    final paidAmount = double.tryParse(_paidAmountController.text) ?? 0.0;
    _balanceAmountController.text = (totalAmount - paidAmount).toStringAsFixed(2);
  }

  void _showStatusDialog() => _showRadioDialog(
    title: 'Select Status',
    options: _statuses,
    selected: _statusSelected,
    onSelected: (value) => setState(() => _statusSelected = value),
  );

  void _showPaymentDialog() => _showRadioDialog(
    title: 'Select Payment Mode',
    options: _payments,
    selected: _paymentMode,
    onSelected: (value) => setState(() => _paymentMode = value),
  );

  void _showRadioDialog({required String title, required List<String> options, required String? selected, required ValueChanged<String> onSelected}) {
    showDialog(
      context: context,
      builder: (context) {
        String? tempSelected = selected;
        return AlertDialog(
          backgroundColor: AppColor.white,
          title: Text(title),
          content: StatefulBuilder(
            builder: (context, setState) => SizedBox(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: options.map((option) => RadioListTile<String>(
                  fillColor: MaterialStateProperty.all(AppColor.blue),
                  title: Text(option),
                  value: option,
                  groupValue: tempSelected,
                  onChanged: (value) => setState(() => tempSelected = value),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                )).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(child:  Text('Cancel', style: TextStyle(color: AppColor.black)), onPressed: () => Navigator.of(context).pop()),
            TextButton(child:  Text('OK', style: TextStyle(color: AppColor.blue)), onPressed: () {
              onSelected(tempSelected ?? '');
              Navigator.of(context).pop();
            }),
          ],
        );
      },
    );
  }

  void _showSelectProductDialogForSpareBox(int index) {
    showDialog(
      context: context,
      builder: (context) {
        String? tempProduct = _spareBoxes[index]['selectedProduct'];
        return AlertDialog(
          backgroundColor: AppColor.white,
          title: const Text('Select Product'),
          content: StatefulBuilder(
            builder: (context, setState) => SizedBox(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: _selectProducts.map((product) => RadioListTile<String>(
                  fillColor: MaterialStateProperty.all(AppColor.blue),
                  title: Text(product.productName ?? ''),
                  value: product.productName ?? '',
                  groupValue: tempProduct,
                  onChanged: (value) => setState(() => tempProduct = value),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                )).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(child:  Text('Cancel', style: TextStyle(color: AppColor.black)), onPressed: () => Navigator.of(context).pop()),
            TextButton(child:  Text('OK', style: TextStyle(color: AppColor.blue)), onPressed: () {
              setState(() {
                _spareBoxes[index]['selectedProduct'] = tempProduct;
                _spareBoxes[index]['showOtherItemsFields'] = tempProduct == 'Others Items';
              });
              Navigator.of(context).pop();
            }),
          ],
        );
      },
    );
  }

  void _validateItems() {
    final isValid = _spareBoxes.every((box) {
      final name = (box['name'] as String?)?.trim() ?? '';
      final quantity = box['quantity'] as int? ?? 0;
      final price = box['price'] as double? ?? 0.0;
      return name.isNotEmpty && quantity > 0 && price > 0.0;
    });
    setState(() => buttonError = !isValid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: Text(widget.title == 'Edit Job' ? 'Edit Details' : 'Add Details'),
        backgroundColor: AppColor.white,
        centerTitle: true,
        shadowColor: AppColor.white,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      backgroundColor: AppColor.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(Icons.person_2_outlined, 'Customer Details'),
              customTextField(_customerNameController, 'Customer Name', errorText: _nameError ? 'Please enter a customer name' : null, onChanged: (v) => setState(() => _nameError = v.isEmpty)),
              customTextField(_phoneNumberController, inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)], 'Phone Number', errorText: _phoneError ? 'Please enter a phone number' : null, onChanged: (v) => setState(() => _phoneError = v.isEmpty)),
              customTextField(_alternatePhoneNumberController, inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)], 'Alternate Phone Number', errorText: _alternatePhoneError ? 'Please enter an alternate phone number' : null, onChanged: (v) => setState(() => _alternatePhoneError = v.isEmpty)),
              customTextField(_addressController, 'Address', errorText: _addressError ? 'Please enter an address' : null, onChanged: (v) => setState(() => _addressError = v.isEmpty)),
              const SectionHeader(Icons.wifi, 'Status Details'),
              CustomDropdownField(hintText: 'Select Status', selectedValue: _statusSelected, onTap: _showStatusDialog),
              if (_statusError) Text('please select status', style: TextStyle(color: AppColor.red, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              customTextField(_statusDescriptionController, 'Status Description', errorText: _statusDescriptionError ? 'Please enter a status description' : null, onChanged: (v) => setState(() => _statusDescriptionError = v.isEmpty)),
              const SectionHeader(Icons.build, 'Product / Order Details'),
              customTextField(_productOrderNameController, 'Product / Order Name', errorText: _productOrderNameError ? 'Please enter a product / order name' : null, onChanged: (v) => setState(() => _productOrderNameError = v.isEmpty)),
              customTextField(_modelNumberController, 'Model Number', errorText: _modelNumberError ? 'Please enter a model number' : null, onChanged: (v) => setState(() => _modelNumberError = v.isEmpty)),
              customTextField(_serialNumberController, 'Serial Number', errorText: _serialNumberError ? 'Please enter a serial number' : null, onChanged: (v) => setState(() => _serialNumberError = v.isEmpty)),
              customTextField(_orderComplaintController, 'Order / Complaint', errorText: _orderComplaintError ? 'Please enter an order / complaint' : null, onChanged: (v) => setState(() => _orderComplaintError = v.isEmpty)),
              customTextField(_otherAccessoriesController, 'Other Accessories', errorText: _otherAccessoriesError ? 'Please enter other accessories' : null, onChanged: (v) => setState(() => _otherAccessoriesError = v.isEmpty)),
              const SectionHeader(Icons.circle, 'Spares / Estimations / Services'),
              MultiBlocListener(
                listeners: [
                  BlocListener<AllBillsCubit, AllBillsState>(
                    listener: (context, state) {
                      if (state is SpareBillsLoaded) {
                        setState(() {
                          if (state.billSparesModel.data != null && state.billSparesModel.data!.isNotEmpty) {
                            _spareBoxes = state.billSparesModel.data!.map((spare) => {
                              'id': spare.id,
                              'quantity': spare.quantity ?? 0,
                              'price': spare.price ?? 0.0,
                              'total': (spare.quantity ?? 0) * (spare.price ?? 0.0),
                              'name': spare.product ?? '',
                              'description': spare.description ?? '',
                              'selectedProduct': spare.product ?? '',
                              'showOtherItemsFields': false,
                              'productId': spare.productId ?? '',
                            }).toList();
                            _validateItems();
                          }
                        });
                      }
                    },
                  ),
                  BlocListener<AddProductsCubit, AddProductsState>(
                    listener: (context, state) {
                      if (state is GetProductsLoaded) {
                        setState(() => _selectProducts = state.getProductsListModel.data ?? []);
                      }
                    },
                  ),
                ],
                child: Column(
                  children: [
                    if (_spareBoxes.isNotEmpty)
                      ...List.generate(_spareBoxes.length, (index) {
                        final currentSpareBoxData = _spareBoxes[index];
                        return SpareBox(
                          key: ValueKey(currentSpareBoxData['id']),
                          index: index,
                          spareBox: currentSpareBoxData,
                          selectedProduct: currentSpareBoxData['selectedProduct'],
                          showOtherItemsFields: currentSpareBoxData['showOtherItemsFields'],
                          onNameChanged: (v) => setState(() { currentSpareBoxData['name'] = v; _validateItems(); }),
                          onDescriptionChanged: (v) => setState(() => currentSpareBoxData['description'] = v),
                          onQuantityChanged: (v) => setState(() {
                            currentSpareBoxData['quantity'] = int.tryParse(v) ?? 0;
                            currentSpareBoxData['total'] = (currentSpareBoxData['quantity'] ?? 0) * (currentSpareBoxData['price'] ?? 0.0);
                            _updateBalanceAmount();
                            _validateItems();
                          }),
                          onPriceChanged: (v) => setState(() {
                            currentSpareBoxData['price'] = double.tryParse(v) ?? 0.0;
                            currentSpareBoxData['total'] = (currentSpareBoxData['quantity'] ?? 0) * (currentSpareBoxData['price'] ?? 0.0);
                            _updateBalanceAmount();
                            _validateItems();
                          }),
                          onDelete: () => setState(() {
                            _spareBoxes.removeAt(index);
                            _updateBalanceAmount();
                            _validateItems();
                          }),
                          onSelectProductTap: () {
                            _showSelectProductDialogForSpareBox(index);
                            if (currentSpareBoxData['selectedProduct'] != null) {
                              final selectedProduct = _selectProducts.firstWhere(
                                (product) => product.productName == currentSpareBoxData['selectedProduct'],
                                orElse: () => Data(),
                              );
                              setState(() {
                                currentSpareBoxData['productId'] = selectedProduct.id;
                                currentSpareBoxData['price'] = selectedProduct.price ?? 0.0;
                                currentSpareBoxData['quantity'] = selectedProduct.quantity ?? 0;
                                currentSpareBoxData['name'] = selectedProduct.productName ?? '';
                                currentSpareBoxData['description'] = selectedProduct.description ?? '';
                                currentSpareBoxData['total'] = (selectedProduct.quantity ?? 0) * (selectedProduct.price ?? 0.0);
                              });
                              _updateBalanceAmount();
                            }
                          },
                        );
                      }),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final canAddNew = _spareBoxes.isEmpty ||
                              (_spareBoxes.isNotEmpty &&
                                  _spareBoxes.last['selectedProduct'] != null &&
                                  (_spareBoxes.last['quantity'] ?? 0) > 0 &&
                                  (_spareBoxes.last['price'] ?? 0) > 0);
                          if (canAddNew) {
                            setState(() {
                              _spareBoxes.add({
                                'id': DateTime.now().microsecondsSinceEpoch.toString(),
                                'productId': '',
                                'quantity': 0,
                                'price': 0.0,
                                'total': 0.0,
                                'name': '',
                                'description': '',
                                'selectedProduct': null,
                                'showOtherItemsFields': false,
                              });
                              _validateItems();
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.white,
                          side: BorderSide(
                            color: _spareBoxes.isEmpty ||
                                    (_spareBoxes.isNotEmpty &&
                                        _spareBoxes.last['selectedProduct'] != null &&
                                        (_spareBoxes.last['quantity'] ?? 0) > 0 &&
                                        (_spareBoxes.last['price'] ?? 0) > 0)
                                ? AppColor.blue
                                : AppColor.gray,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, color: _spareBoxes.isEmpty ||
                                    (_spareBoxes.isNotEmpty &&
                                        _spareBoxes.last['selectedProduct'] != null &&
                                        (_spareBoxes.last['quantity'] ?? 0) > 0 &&
                                        (_spareBoxes.last['price'] ?? 0) > 0)
                                ? AppColor.blue
                                : AppColor.gray),
                            const SizedBox(width: 8),
                            Text('ADD SPARES', style: TextStyle(color: _spareBoxes.isEmpty ||
                                    (_spareBoxes.isNotEmpty &&
                                        _spareBoxes.last['selectedProduct'] != null &&
                                        (_spareBoxes.last['quantity'] ?? 0) > 0 &&
                                        (_spareBoxes.last['price'] ?? 0) > 0)
                                ? AppColor.blue
                                : AppColor.gray)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Total Amount: ₹${_spareBoxes.fold<double>(0, (sum, box) => sum + ((box['quantity'] ?? 0) * (box['price'] ?? 0.0))).toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: getHeight(context) * 0.01),
              customTextField(_paidAmountController, 'Paid Amount', inputFormatters: [FilteringTextInputFormatter.digitsOnly], errorText: _paidAmountError ? 'Please enter a paid amount' : null, onChanged: (v) {
                setState(() => _paidAmountError = v.isEmpty);
                _updateBalanceAmount();
              }),
              customTextField(_balanceAmountController, enabled: false, 'Balance Amount', errorText: _balanceAmountError ? 'Please enter a balance amount' : null, onChanged: (_) {}),
              CustomDropdownField(hintText: 'Select Payment Mode', selectedValue: _paymentMode?.isEmpty ?? true ? null : _paymentMode, onTap: _showPaymentDialog),
              SizedBox(height: getHeight(context) * 0.01),
              buildButton(
                text: 'SUBMIT',
                isLoading: isLoading,
                error: buttonError,
                handleAction: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                      _nameError = _customerNameController.text.isEmpty;
                      _phoneError = _phoneNumberController.text.isEmpty;
                      _addressError = _addressController.text.isEmpty;
                      _productOrderNameError = _productOrderNameController.text.isEmpty;
                      _modelNumberError = _modelNumberController.text.isEmpty;
                      _serialNumberError = _serialNumberController.text.isEmpty;
                      _orderComplaintError = _orderComplaintController.text.isEmpty;
                      _sparesError = _spareBoxes.isEmpty;
                      _statusError = _statusSelected == null || _statusSelected!.isEmpty;
                    });

                    if (_nameError || _phoneError || _alternatePhoneError || _addressError || _productOrderNameError || _modelNumberError || _serialNumberError || _orderComplaintError || _otherAccessoriesError || _statusError) {
                      setState(() => isLoading = false);
                      return;
                    }
                    try {
                      final billSpares = _spareBoxes.map((spareBox) => {
                        "id": widget.title == 'Edit Job' ? widget.jobData.id : null,
                        "billId": null,
                        "productId": "2855035b-18f8-4c3a-9a90-812788f70d95",
                        "product": spareBox['selectedProduct'] ?? spareBox['name'] ?? '',
                        "quantity": spareBox['quantity'],
                        "price": spareBox['price'],
                        "description": spareBox['description'] ?? "",
                        "productList": {
                          "id": "2855035b-18f8-4c3a-9a90-812788f70d95",
                          "productName": spareBox['name'] ?? "JR_OTHER_PRODUCT",
                          "price": spareBox['price'] ?? 0.0,
                          "quantity": spareBox['quantity'] ?? 0,
                          "description": spareBox['description'] ?? "",
                          "userId": _userId,
                          "companyId": _companyId,
                        },
                        "otherProduct": spareBox['selectedProduct'] == 'Other Items',
                        "selectedProduct": spareBox['selectedProduct'],
                      }).toList();

                      final totalAmountForApi = _spareBoxes.fold<double>(0, (sum, box) => sum + ((box['quantity'] ?? 0) * (box['price'] ?? 0.0)));

                      await context.read<SaveBillCubit>().save_bill(context, {
                        "id": widget.title == 'Edit Job' ? widget.jobData.id : null,
                        "billId": null,
                        "customerName": _customerNameController.text,
                        "address": _addressController.text,
                        "phoneNumber": _phoneNumberController.text,
                        "productName": _productOrderNameController.text,
                        "modelNumber": _modelNumberController.text,
                        "serialNumber": _serialNumberController.text,
                        "complaint": _orderComplaintController.text,
                        "otherAccessories": _otherAccessoriesController.text,
                        "status": _statusSelected,
                        "paidAmount": double.tryParse(_paidAmountController.text) ?? 0.0,
                        "totalAmount": totalAmountForApi,
                        "paymentType": _paymentMode,
                        "statusDescription": _statusDescriptionController.text,
                        "userId": _userId,
                        "companyId": _companyId,
                        "billSpares": billSpares,
                      }, widget.companyName.toString(), 0);

                      if (mounted) setState(() => isLoading = false);
                    } catch (e) {
                      if (mounted) {
                        setState(() => isLoading = false);
                        CustomSnackbars.showErrorSnack(
                          context: context,
                          title: 'Alert',
                          message: 'Something went wrong, please try again',
                        );
                      }
                    }
                  }
                },
              ),
              SizedBox(height: getHeight(context) * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
