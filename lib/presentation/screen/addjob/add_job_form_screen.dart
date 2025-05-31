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
import 'package:assistify/presentation/widgets/add-job_form_screen_widgets.dart/spare_box.dart'; // Ensure this is imported
import 'package:assistify/presentation/widgets/helper_widgets.dart/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddJobFormScreen extends StatefulWidget {
  final dynamic jobData;
  final String? title;
  final String? companyName;
  const AddJobFormScreen({Key? key, this.jobData, this.title, this.companyName})
    : super(key: key);

  @override
  State<AddJobFormScreen> createState() => _AddJobFormScreenState();
}

class _AddJobFormScreenState extends State<AddJobFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late FocusScopeNode _focusScopeNode;

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

  bool _nameError = false,
      _phoneError = false,
      _phoneLengthError = false,
      _alternatePhoneError = false,
      _addressError = false,
      _statusDescriptionError = false,
      _productOrderNameError = false,
      _modelNumberError = false,
      _serialNumberError = false,
      _orderComplaintError = false,
      _otherAccessoriesError = false,
      _paidAmountError = false,
      _balanceAmountError = false,
      _paymentError = false,
      _sparesError = false,
      _statusError = false;
  String? selectedProduct = '';
  List<Map<String, dynamic>> _spareBoxes = [];
  List<Data> _selectProducts = [];

  static const _statuses = [
    'Received',
    'Assigned',
    'In Progress',
    'Estimated',
    'Pending',
    'Delivered',
    'Completed',
    'Paid',
    "Return",
  ];
  static const _payments = ['card', 'Cash', 'Bank Transfer', 'Upi'];

  @override
  void initState() {
    super.initState();
    _focusScopeNode = FocusScopeNode();
    _fetchData();
    _paidAmountController.addListener(_updateBalanceAmount);
    if (widget.jobData != null) {
      context.read<AllBillsCubit>().spareBills(
        context: context,
        jobId: widget.jobData.id,
      );
    }
    _editDetails();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        buttonError = !_validateItems();
      });
    });
  }

  @override
  void dispose() {
    _focusScopeNode.dispose();
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
    final data = widget.jobData;
    if (data != null) {
      _customerNameController.text = data.customerName ?? '';
      _phoneNumberController.text = data.phoneNumber ?? '';
      _alternatePhoneNumberController.text = data.alternatePhoneNumber ?? '';
      _addressController.text = data.address ?? '';
      _statusDescriptionController.text = data.statusDescription ?? '';
      _productOrderNameController.text = data.productName ?? '';
      _modelNumberController.text = data.modelNumber ?? '';
      _serialNumberController.text = data.serialNumber ?? '';
      _orderComplaintController.text = data.complaint ?? '';
      _otherAccessoriesController.text = data.otherAccessories ?? '';
      _paidAmountController.text = data.paidAmount?.toString() ?? '';
      _balanceAmountController.text =
          ((data.totalAmount ?? 0) - (data.paidAmount ?? 0)).toStringAsFixed(2);
      _statusSelected = data.status ?? '';
      _paymentMode = data.paymentType ?? '';
    }
  }

  void _updateBalanceAmount() {
    final totalAmount = _getTotalAmount();
    final paidAmount = double.tryParse(_paidAmountController.text) ?? 0.0;
    _balanceAmountController.text = (totalAmount - paidAmount).toStringAsFixed(
      2,
    );
  }

  double _getTotalAmount() => _spareBoxes.fold<double>(
    0,
    (sum, box) => sum + ((box['quantity'] ?? 0) * (box['price'] ?? 0.0)),
  );

  void _showRadioDialog({
    required String title,
    required List<String> options,
    required String? selected,
    required ValueChanged<String> onSelected,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        String? tempSelected = selected;
        return AlertDialog(
          backgroundColor: AppColor.white,
          title: Text(title),
          content: StatefulBuilder(
            builder:
                (context, setState) => SizedBox(
                  width: double.maxFinite,
                  child: ListView(
                    shrinkWrap: true,
                    children:
                        options
                            .map(
                              (option) => RadioListTile<String>(
                                fillColor: MaterialStateProperty.all(
                                  AppColor.blue,
                                ),
                                title: Text(option),
                                value: option,
                                groupValue: tempSelected,
                                onChanged:
                                    (value) =>
                                        setState(() => tempSelected = value),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel', style: TextStyle(color: AppColor.black)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('OK', style: TextStyle(color: AppColor.blue)),
              onPressed: () {
                onSelected(tempSelected ?? '');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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

  void _showSelectProductDialogForSpareBox(int index) {
    showDialog(
      context: context,
      builder: (context) {
        String? tempProductSelectedName = _spareBoxes[index]['selectedProduct'];
        Data? selectedProductObject;
        selectedProduct = _spareBoxes[index]['selectedProduct'];
        return AlertDialog(
          backgroundColor: AppColor.white,
          title: const Text('Select Product'),
          content: StatefulBuilder(
            builder:
                (context, setState) => SizedBox(
                  width: double.maxFinite,
                  child: ListView(
                    shrinkWrap: true,
                    children:
                        _selectProducts
                            .map(
                              (product) => RadioListTile<String>(
                                fillColor: MaterialStateProperty.all(
                                  AppColor.blue,
                                ),
                                title: Text(product.productName ?? ''),
                                value: product.productName ?? '',
                                groupValue: tempProductSelectedName,
                                onChanged: (value) {
                                  setState(() {
                                    tempProductSelectedName = value;
                                    selectedProductObject = _selectProducts
                                        .firstWhere(
                                          (p) => p.productName == value,
                                          orElse: () => Data(),
                                        );
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel', style: TextStyle(color: AppColor.black)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('OK', style: TextStyle(color: AppColor.blue)),
              onPressed: () {
                setState(() {
                  _spareBoxes[index]['selectedProduct'] =
                      tempProductSelectedName;
                  _spareBoxes[index]['showOtherItemsFields'] =
                      tempProductSelectedName == 'Others Items';

                  if (selectedProductObject != null) {
                    _spareBoxes[index]['quantity'] =
                        selectedProductObject!.quantity ?? 0;
                    _spareBoxes[index]['price'] =
                        selectedProductObject!.price ?? 0.0;
                    _spareBoxes[index]['maxQuantity'] =
                        selectedProductObject!.quantity ?? 0;
                    _spareBoxes[index]['name'] =
                        selectedProductObject!.productName;
                    _spareBoxes[index]['productId'] = selectedProductObject!.id;
                  } else {
                    _spareBoxes[index]['quantity'] = 0;
                    _spareBoxes[index]['price'] = 0.0;
                    _spareBoxes[index]['maxQuantity'] = 100;
                    _spareBoxes[index]['name'] = tempProductSelectedName;
                    _spareBoxes[index]['productId'] = '';
                  }
                  _spareBoxes[index]['total'] =
                      (_spareBoxes[index]['quantity'] ?? 0) *
                      (_spareBoxes[index]['price'] ?? 0.0);
                  _updateBalanceAmount();

                  buttonError = !_validateItems();
                  print(
                    'DEBUG: After OK in dialog, _spareBoxes[$index]: ${_spareBoxes[index]}',
                  );
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  bool _validateItems() {
    final isValid = _spareBoxes.every((box) {
      final name = (box['name'] as String?)?.trim() ?? '';
      final quantity = box['quantity'] as int? ?? 0;
      final price = box['price'] as double? ?? 0.0;
      final bool nameValidForOthers =
          box['selectedProduct'] == 'Others Items' ? name.isNotEmpty : true;
      final bool productSelected =
          box['selectedProduct'] != null &&
          (box['selectedProduct'] as String).isNotEmpty;
      if (!productSelected) {
        return name.isNotEmpty && quantity > 0 && price > 0.0;
      } else if (box['selectedProduct'] == 'Others Items') {
        return name.isNotEmpty && quantity > 0 && price > 0.0;
      } else {
        return quantity > 0 && price > 0.0;
      }
    });
    return isValid;
  }

  void _onSpareBoxChanged(int index, Map<String, dynamic> changes) {
    setState(() {
      final updatedBox = {..._spareBoxes[index], ...changes};

      if (selectedProduct != 'Others Items') {
        final quantity =
            double.tryParse(updatedBox['quantity'].toString()) ?? 0;
        final price = double.tryParse(updatedBox['price'].toString()) ?? 0.0;
        updatedBox['total'] = quantity * price;
      }

      _spareBoxes[index] = updatedBox;
      _updateBalanceAmount();
      buttonError = !_validateItems();
    });
  }

  bool _canAddNewSpareBox() {
    if (_spareBoxes.isEmpty) return true;
    final last = _spareBoxes.last;
    final name = (last['name'] as String?)?.trim() ?? '';
    final quantity = last['quantity'] as int? ?? 0;
    final price = last['price'] as double? ?? 0.0;

    final bool isProductSelectedOrOthersNamed =
        (last['selectedProduct'] != null &&
            (last['selectedProduct'] as String).isNotEmpty &&
            last['selectedProduct'] != 'Others Items') ||
        (last['selectedProduct'] == 'Others Items' && name.isNotEmpty);

    return isProductSelectedOrOthersNamed && quantity > 0 && price > 0;
  }

  @override
  Widget build(BuildContext context) {
    final totalAmount = _getTotalAmount();
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: Text(
          widget.title == 'Edit Job' ? 'Edit Details' : 'Add Details',
        ),
        backgroundColor: AppColor.white,
        centerTitle: true,
        shadowColor: AppColor.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: AppColor.white,
      body: FocusScope(
        node: _focusScopeNode,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(
                  Icons.person_2_outlined,
                  'Customer Details',
                ),
                customTextField(
                  _customerNameController,
                  'Customer Name',
                  errorText: _nameError ? 'Please enter a customer name' : null,
                  onChanged: (v) => setState(() => _nameError = v.isEmpty),
                ),
                customTextField(
                  _phoneNumberController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  'Phone Number',
                  errorText:
                      _phoneError
                          ? 'Please enter a valid phone number'
                          : _phoneLengthError
                          ? 'Phone number must be 10 digits'
                          : null,
                  onChanged:
                      (v) => setState(() {
                        _phoneError = v.isEmpty;
                        _phoneLengthError = v.length < 10 && v.isNotEmpty;
                      }),
                ),
                customTextField(
                  _alternatePhoneNumberController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  'Alternate Phone Number',
                  errorText:
                      _alternatePhoneError
                          ? 'Please enter an alternate phone number'
                          : null,
                  onChanged:
                      (v) => setState(() => _alternatePhoneError = false),
                ),
                customTextField(
                  _addressController,
                  'Address',
                  errorText: _addressError ? 'Please enter an address' : null,
                  onChanged: (v) => setState(() => _addressError = v.isEmpty),
                ),
                const SectionHeader(Icons.wifi, 'Status Details'),
                CustomDropdownField(
                  hintText: 'Select Status',
                  selectedValue: _statusSelected,
                  onTap: () {
                    _focusScopeNode.unfocus();
                    _showStatusDialog();
                    setState(() {
                      _statusError == false;
                    });
                  },
                ),
                if (_statusError)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                    child: Text(
                      'Please select status',
                      style: TextStyle(
                        color: AppColor.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                customTextField(
                  _statusDescriptionController,
                  'Status Description',
                  errorText:
                      _statusDescriptionError
                          ? 'Please enter a status description'
                          : null,
                  onChanged:
                      (v) =>
                          setState(() => _statusDescriptionError = v.isEmpty),
                ),
                const SectionHeader(Icons.build, 'Product / Order Details'),
                customTextField(
                  _productOrderNameController,
                  'Product / Order Name',
                  errorText:
                      _productOrderNameError
                          ? 'Please enter a product / order name'
                          : null,
                  onChanged:
                      (v) => setState(() => _productOrderNameError = v.isEmpty),
                ),
                customTextField(
                  _modelNumberController,
                  'Model Number',
                  errorText:
                      _modelNumberError ? 'Please enter a model number' : null,
                  onChanged:
                      (v) => setState(() => _modelNumberError = v.isEmpty),
                ),
                customTextField(
                  _serialNumberController,
                  'Serial Number',
                  errorText:
                      _serialNumberError
                          ? 'Please enter a serial number'
                          : null,
                  onChanged:
                      (v) => setState(() => _serialNumberError = v.isEmpty),
                ),
                customTextField(
                  _orderComplaintController,
                  'Order / Complaint',
                  errorText:
                      _orderComplaintError
                          ? 'Please enter an order / complaint'
                          : null,
                  onChanged:
                      (v) => setState(() => _orderComplaintError = v.isEmpty),
                ),
                customTextField(
                  _otherAccessoriesController,
                  'Other Accessories',
                  errorText:
                      _otherAccessoriesError
                          ? 'Please enter other accessories'
                          : null,
                  onChanged:
                      (v) => setState(() => _otherAccessoriesError = v.isEmpty),
                ),
                const SectionHeader(
                  Icons.circle,
                  'Spares / Estimations / Services',
                ),
                MultiBlocListener(
                  listeners: [
                    BlocListener<AllBillsCubit, AllBillsState>(
                      listener: (context, state) {
                        if (state is SpareBillsLoaded) {
                          setState(() {
                            if (state.billSparesModel.data != null &&
                                state.billSparesModel.data!.isNotEmpty) {
                              _spareBoxes =
                                  state.billSparesModel.data!.map((spare) {
                                    final isOtherItem =
                                        spare.productId ==
                                        "2855035b-18f8-4c3a-9a90-812788f70d95";
                                    return {
                                      'id': spare.id,
                                      'quantity': spare.quantity ?? 0,
                                      'price': spare.price ?? 0.0,
                                      'total':
                                          (spare.quantity ?? 0) *
                                          (spare.price ?? 0.0),
                                      'name':
                                          isOtherItem
                                              ? (spare.product ?? '')
                                              : '',
                                      'description':
                                          isOtherItem
                                              ? (spare.description ?? '')
                                              : '',
                                      'selectedProduct':
                                          isOtherItem
                                              ? 'Others Items'
                                              : (spare.product ?? ''),
                                      'showOtherItemsFields':
                                          isOtherItem ||
                                          spare.product == 'Others Items',
                                      'productId': spare.productId ?? '',
                                      'maxQuantity': 1000,
                                    };
                                  }).toList();
                              buttonError = !_validateItems();
                            }
                          });
                        }
                      },
                    ),
                    BlocListener<AddProductsCubit, AddProductsState>(
                      listener: (context, state) {
                        if (state is GetProductsLoaded) {
                          setState(
                            () =>
                                _selectProducts =
                                    state.getProductsListModel.data ?? [],
                          );
                        }
                      },
                    ),
                  ],
                  child: Column(
                    children: [
                      if (_spareBoxes.isNotEmpty)
                        ...List.generate(_spareBoxes.length, (index) {
                          final box = _spareBoxes[index];
                          print(
                            'DEBUG: AddJobFormScreen building SpareBox[$index] with data: $box',
                          );
                          return SpareBox(
                            key: ValueKey(box['id']),
                            index: index,

                            spareBox: box,
                            prodId: box['productId'],
                            selectedProduct: box['selectedProduct'],
                            showOtherItemsFields:
                                box['showOtherItemsFields'] ?? false,
                            onNameChanged:
                                (v) => _onSpareBoxChanged(index, {'name': v}),
                            onDescriptionChanged:
                                (v) => _onSpareBoxChanged(index, {
                                  'description': v,
                                }),
                            onQuantityChanged:
                                (v) => _onSpareBoxChanged(index, {
                                  'quantity': int.tryParse(v) ?? 0,
                                }),
                            onPriceChanged:
                                (v) => _onSpareBoxChanged(index, {
                                  'price': double.tryParse(v) ?? 0,
                                }),
                            onDelete: () {
                              setState(() {
                                _spareBoxes.removeAt(index);
                                _updateBalanceAmount();
                                _validateItems();
                              });
                            },
                            onSelectProductTap: () {
                              _showSelectProductDialogForSpareBox(index);
                            },
                            maxQuantity: box['maxQuantity'] ?? 1000,
                          );
                        }),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              _canAddNewSpareBox()
                                  ? () {
                                    setState(() {
                                      _spareBoxes.add({
                                        'id':
                                            DateTime.now()
                                                .microsecondsSinceEpoch
                                                .toString(),
                                        'productId': '',
                                        'quantity': 0,
                                        'price': 0.0,
                                        'total': 0.0,
                                        'name': '',
                                        'description': '',
                                        'selectedProduct': null,
                                        'showOtherItemsFields': false,
                                        'maxQuantity': 1000,
                                      });
                                      buttonError = !_validateItems();
                                    });
                                  }
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.white,
                            side: BorderSide(
                              color:
                                  _canAddNewSpareBox()
                                      ? AppColor.blue
                                      : AppColor.gray,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add,
                                color:
                                    _canAddNewSpareBox()
                                        ? AppColor.blue
                                        : AppColor.black,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'ADD SPARES',
                                style: TextStyle(
                                  color:
                                      _canAddNewSpareBox()
                                          ? AppColor.blue
                                          : AppColor.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Total Amount: ₹${totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: getHeight(context) * 0.01),
                customTextField(
                  _paidAmountController,
                  'Paid Amount',
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  errorText:
                      _paidAmountError ? 'Please enter a paid amount' : null,
                  onChanged: (v) {
                    setState(() => _paidAmountError = v.isEmpty);
                    _updateBalanceAmount();
                  },
                ),
                customTextField(
                  _balanceAmountController,
                  enabled: false,
                  'Balance Amount',
                  errorText:
                      _balanceAmountError
                          ? 'Please enter a balance amount'
                          : null,
                  onChanged: (_) {},
                ),
                CustomDropdownField(
                  hintText: 'Select Payment Mode',
                  selectedValue:
                      _paymentMode?.isEmpty ?? true ? null : _paymentMode,
                  onTap: () {
                    _focusScopeNode.unfocus();
                    _showPaymentDialog();
                  },
                ),
                _paymentError
                    ? Text(
                      'Plese select payment mode',
                      style: TextStyle(color: AppColor.red),
                    )
                    : SizedBox(),

                SizedBox(height: getHeight(context) * 0.01),
                buildButton(
                  text: 'SUBMIT',
                  isLoading: isLoading,
                  error: buttonError,
                  handleAction: () async {
                    _focusScopeNode.unfocus();
                    setState(() {
                      _nameError = _customerNameController.text.isEmpty;
                      _phoneError = _phoneNumberController.text.isEmpty;
                      _addressError = _addressController.text.isEmpty;
                      _phoneLengthError =
                          _phoneNumberController.text.length < 10 &&
                          _phoneNumberController.text.isNotEmpty;
                      _productOrderNameError =
                          _productOrderNameController.text.isEmpty;
                      _modelNumberError = _modelNumberController.text.isEmpty;
                      _serialNumberError = _serialNumberController.text.isEmpty;
                      _orderComplaintError =
                          _orderComplaintController.text.isEmpty;
                      _statusError =
                          _statusSelected == null || _statusSelected!.isEmpty;
                      _paymentError =
                          _paymentMode == null || _paymentMode!.isEmpty;
                      _validateItems();
                    });

                    if (_nameError ||
                        _phoneError ||
                        _phoneLengthError ||
                        _addressError ||
                        _productOrderNameError ||
                        _modelNumberError ||
                        _serialNumberError ||
                        _orderComplaintError ||
                        _statusError ||
                        _paidAmountError ||
                        buttonError ||
                        _paymentError) {
                      CustomSnackbars.showErrorSnack(
                        context: context,
                        title: 'Validation Error',
                        message:
                            'Please fill all required fields and ensure all spare items are complete.',
                      );
                      setState(() => isLoading = false);
                      return;
                    }
                    setState(() => isLoading = true);
                    try {
                      final billSpares =
                          _spareBoxes
                              .map(
                                (spareBox) => {
                                  "id":
                                      widget.title == 'Edit Job' &&
                                              spareBox.containsKey('id') &&
                                              spareBox['id'] is String &&
                                              (spareBox['id'] as String)
                                                      .length ==
                                                  36
                                          ? spareBox['id']
                                          : null,
                                  "billId": null,
                                  "productId": spareBox['productId'] ?? null,
                                  "product":
                                      spareBox['selectedProduct'] ==
                                              'Others Items'
                                          ? spareBox['name']
                                          : spareBox['selectedProduct'],
                                  "quantity": spareBox['quantity'],
                                  "price": spareBox['price'],
                                  "description": spareBox['description'] ?? "",
                                  "productList": {
                                    "id":
                                        spareBox['productId'] ??
                                        "00000000-0000-0000-0000-000000000000",
                                    "productName":
                                        spareBox['name'] ??
                                        spareBox['selectedProduct'],
                                    "price": spareBox['price'] ?? 0.0,
                                    "quantity": spareBox['maxQuantity'] ?? 0,
                                    "description":
                                        spareBox['description'] ?? "",
                                    "userId": _userId,
                                    "companyId": _companyId,
                                  },
                                  "otherProduct":
                                      spareBox['selectedProduct'] ==
                                      'Others Items',
                                },
                              )
                              .toList();

                      await context.read<SaveBillCubit>().save_bill(
                        context,
                        {
                          "id":
                              widget.title == 'Edit Job'
                                  ? widget.jobData.id
                                  : null,
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
                          "paidAmount":
                              double.tryParse(_paidAmountController.text) ??
                              0.0,
                          "totalAmount": totalAmount,
                          "paymentType": _paymentMode,
                          "statusDescription":
                              _statusDescriptionController.text,
                          "userId": _userId,
                          "companyId": _companyId,
                          "billSpares": billSpares,
                        },
                        widget.companyName.toString(),
                        0,
                      );

                      if (mounted) setState(() => isLoading = false);
                      CustomSnackbars.showSuccessSnack(
                        context: context,
                        title: 'Success',
                        message:
                            widget.title == 'Edit Job'
                                ? 'Job updated successfully!'
                                : 'Job added successfully!',
                      );
                    } catch (e) {
                      if (mounted) {
                        setState(() => isLoading = false);
                        CustomSnackbars.showErrorSnack(
                          context: context,
                          title: 'Alert',
                          message: 'Something went wrong, please try again: $e',
                        );
                      }
                    }
                  },
                ),
                SizedBox(height: getHeight(context) * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
