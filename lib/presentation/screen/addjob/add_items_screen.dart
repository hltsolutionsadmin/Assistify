import 'package:assistify/components/custome_text_field.dart';
import 'package:assistify/core/constants/colors.dart';
import 'package:assistify/core/constants/sizes.dart';
import 'package:assistify/presentation/cubit/add_products/add_products_cubit.dart';
import 'package:assistify/presentation/cubit/add_products/add_products_state.dart';
import 'package:assistify/presentation/cubit/dashboard/all_bills/all_bills_cubit.dart';
import 'package:assistify/presentation/cubit/dashboard/all_bills/all_bills_state.dart';
import 'package:assistify/presentation/cubit/dashboard/save_bill/save_bill_cubit.dart';
import 'package:assistify/presentation/cubit/search_phone_number/search_phone_number_cubit.dart';
import 'package:assistify/presentation/cubit/search_phone_number/search_phone_number_state.dart';
import 'package:assistify/presentation/widgets/add-job_form_screen_widgets.dart/section_header.dart';
import 'package:assistify/presentation/widgets/add-job_form_screen_widgets.dart/spare_items.dart';
import 'package:assistify/presentation/widgets/helper_widgets.dart/button_widget.dart';
import 'package:assistify/presentation/widgets/search_phone_number_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:assistify/data/model/add_product/get_products_list_model.dart';

// ignore: must_be_immutable
class AddItemsScreen extends StatefulWidget {
  final dynamic jobData;
  String? title;
  String? companyName;
  num? category;
  String? companyPhone;

  AddItemsScreen({
    super.key,
    this.jobData,
    this.title,
    this.companyName,
    this.category,
    this.companyPhone,
  });

  @override
  _AddJobFormScreenState createState() => _AddJobFormScreenState();
}

class _AddJobFormScreenState extends State<AddItemsScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _userId;
  String? _companyId;
  bool isLoading = false;
  bool showSearchResults = false;
  List<Data> _selectProducts = [];

  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _alternatePhoneNumberController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _statusDescriptionController =
      TextEditingController();
  final TextEditingController _productOrderNameController =
      TextEditingController();
  final TextEditingController _paidAmountController = TextEditingController();
  final TextEditingController _balanceAmountController =
      TextEditingController();

  bool _nameError = false;
  bool _phoneError = false;
  bool _phoneLengthError = false;
  bool _alternatePhoneError = false;
  bool _addressError = false;
  bool _sparesError = false;
  bool buttonError = true;
  String? selectedProduct = '';

  List<Map<String, dynamic>> _spareBoxes = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
    print('company mobile: ${widget.companyPhone}');
    _updateBalanceAmount();
    _paidAmountController.addListener(_updateBalanceAmount);
    // final state = context.read<
    if (widget.jobData != null) {
      context.read<AllBillsCubit>().spareBills(
        context: context,
        jobId: widget.jobData.id,
      );
      final spares = context.read<AllBillsCubit>();
      final state = spares.state;
      if (state is SpareBillsLoaded) {
        _spareBoxes =
            (state.billSparesModel.data ?? []).cast<Map<String, dynamic>>();
      }
    }
    edit_details();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        buttonError = !_validateItems();
      });
    });
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

  edit_details() async {
    if (widget.jobData != null) {
      _customerNameController.text = widget.jobData.customerName ?? '';
      _phoneNumberController.text = widget.jobData.phoneNumber ?? '';
      _alternatePhoneNumberController.text =
          widget.jobData.alternatePhoneNumber ?? '';
      _addressController.text = widget.jobData.address ?? '';
      _statusDescriptionController.text =
          widget.jobData.statusDescription ?? '';
      _productOrderNameController.text = widget.jobData.productName ?? '';
    }
  }

  Future<void> _fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId') ?? '';
      _companyId = prefs.getString('companyId') ?? '';
      context.read<AddProductsCubit>().getProduct(context, _companyId!);
    });
  }

  void _handleCustomerSelection(dynamic customer) {
    setState(() {
      _customerNameController.text = customer.customerName ?? '';
      _phoneNumberController.text = customer.phoneNumber ?? '';
      _addressController.text = customer.address ?? '';
      showSearchResults = false;
    });
  }

  void _updateBalanceAmount() {
    final totalAmount = _spareBoxes.fold<double>(
      0,
      (sum, box) => sum + ((box['quantity'] ?? 0) * (box['price'] ?? 0.0)),
    );
    final paidAmount = double.tryParse(_paidAmountController.text) ?? 0.0;
    final balance = totalAmount - paidAmount;
    if (mounted) {
      _balanceAmountController.text = balance.toStringAsFixed(2);
    }
  }

  bool get _canAddNewItem {
    if (_spareBoxes.isEmpty) return true;

    final last = _spareBoxes.last;
    final name = (last['name'] as String?)?.trim() ?? '';
    final quantity = last['quantity'] as int? ?? 0;
    final price = last['price'] as double? ?? 0.0;

    return name.isNotEmpty && quantity > 0 && price > 0.0;
  }

  void _showSelectProductDialogForSpareBox(int index) {
    showDialog(
      context: context,
      builder: (context) {
        String? tempProductSelectedName = _spareBoxes[index]['selectedProduct'];
        Data? selectedProductObject;

        return AlertDialog(
          backgroundColor: AppColor.white,
          title: const Text('Select Item'),
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              return SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children:
                      _selectProducts.map((product) {
                        return RadioListTile<String>(
                          fillColor: WidgetStateProperty.all(AppColor.blue),
                          title: Text(product.productName ?? ''),
                          value: product.productName ?? '',
                          groupValue: tempProductSelectedName,
                          onChanged: (value) {
                            setStateDialog(() {
                              tempProductSelectedName = value;
                              selectedProductObject = _selectProducts
                                  .firstWhere(
                                    (p) => p.productName == value,
                                    orElse: () => Data(),
                                  );
                            });

                            // ✅ Instantly update spare box and close dialog
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
                                _spareBoxes[index]['productId'] =
                                    selectedProductObject!.id;
                              } else {
                                _spareBoxes[index]['quantity'] = 0;
                                _spareBoxes[index]['price'] = 0.0;
                                _spareBoxes[index]['maxQuantity'] = 100;
                                _spareBoxes[index]['name'] =
                                    tempProductSelectedName;
                                _spareBoxes[index]['productId'] = '';
                              }

                              _spareBoxes[index]['total'] =
                                  (_spareBoxes[index]['quantity'] ?? 0) *
                                  (_spareBoxes[index]['price'] ?? 0.0);
                              _updateBalanceAmount();
                              _validateItems();
                            });

                            Navigator.of(context).pop(); // ✅ Close instantly
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        );
                      }).toList(),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              child: Text('Cancel', style: TextStyle(color: AppColor.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: Text(
          widget.title == 'Edit details' ? 'Edit Details' : 'Add details',
        ),
        backgroundColor: AppColor.white,
        centerTitle: true,
        shadowColor: AppColor.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
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
              BuildSearchNumberField(
                enabled: widget.title == 'Edit Details' ? false : true,
                context: context,
                prefixIcon: Icon(Icons.search),
                searchController: _phoneNumberController,
                onChanged: (value) {
                  setState(() {
                    showSearchResults = value.isNotEmpty;
                    _phoneError = false;
                  });
                  Future.delayed(const Duration(milliseconds: 100), () {
                    if (value == _phoneNumberController.text) {
                      context.read<SearchPhoneNumberCubit>().searchPhoneNumber(
                        context: context,
                        mobileNumber: value,
                      );
                    }
                  });
                },
              ),
              if (showSearchResults)
                BlocBuilder<SearchPhoneNumberCubit, SearchPhoneNumberState>(
                  builder: (context, state) {
                    if (state is SearchPhoneNumberLoading) {
                      return Center(
                        child: CupertinoActivityIndicator(color: AppColor.blue),
                      );
                    } else if (state is SearchPhoneNumberLoaded &&
                        state.seachMobileNumberModel.data!.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  showSearchResults = false;
                                });
                              },
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Icon(
                                  Icons.cancel,
                                  color: AppColor.black,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColor.gray),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: ListView.builder(
                                itemCount:
                                    state.seachMobileNumberModel.data?.length ??
                                    0,
                                itemBuilder: (context, index) {
                                  final customer =
                                      state.seachMobileNumberModel.data?[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 6.0,
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: AppColor.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColor.gray.withOpacity(
                                              0.3,
                                            ),
                                            spreadRadius: 1,
                                            blurRadius: 6,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                        border: Border(
                                          bottom: BorderSide(
                                            color: AppColor.gray,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(12.0),
                                      child: InkWell(
                                        onTap:
                                            () => {
                                              _handleCustomerSelection(
                                                customer,
                                              ),
                                            },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              customer?.customerName ?? '',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(customer?.phoneNumber ?? ''),
                                            SizedBox(height: 4),
                                            Text(customer?.address ?? ''),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container(child: Text(''));
                    }
                  },
                ),
              _phoneError == true
                  ? Text(
                    'Please enter a phone number',
                    style: TextStyle(color: AppColor.red),
                  )
                  : _phoneLengthError == true
                  ? Text(
                    'Please enter a valid phone number',
                    style: TextStyle(color: AppColor.red),
                  )
                  : SizedBox(),
              SizedBox(height: 10),
              customTextField(
                _customerNameController,
                'Customer Name',
                errorText: _nameError ? 'Please enter a customer name' : null,
                onChanged: (value) {
                  setState(() {
                    _nameError = value.isEmpty;
                  });
                },
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
                onChanged: (value) {
                  setState(() {
                    _alternatePhoneError = value.isEmpty;
                  });
                },
              ),
              customTextField(
                _addressController,
                'Address',
                errorText: _addressError ? 'Please enter an address' : null,
                onChanged: (value) {
                  setState(() {
                    _addressError = value.isEmpty;
                  });
                },
              ),
              const SectionHeader(Icons.circle, 'Add Items'),
              MultiBlocListener(
                listeners: [
                  BlocListener<AllBillsCubit, AllBillsState>(
                    listener: (context, state) {
                      if (state is SpareBillsLoaded) {
                        setState(() {
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
                                          : spare.product ?? '',
                                  'description':
                                      isOtherItem
                                          ? (spare.description ?? '')
                                          : spare.description ?? '',
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
                          _validateItems();
                        });
                      }
                    },
                  ),
                  BlocListener<AddProductsCubit, AddProductsState>(
                    listener: (context, state) {
                      if (state is GetProductsLoaded) {
                        print('-----${state.getProductsListModel.data?[0]}');
                        setState(() {
                          _selectProducts =
                              state.getProductsListModel.data ?? [];
                        });
                      }
                    },
                  ),
                ],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_spareBoxes.isNotEmpty)
                      ...List.generate(_spareBoxes.length, (index) {
                        final currentSpareBoxData = _spareBoxes[index];
                        print(index);
                        return SpareItemsBox(
                          key: ValueKey(currentSpareBoxData['id']),
                          index: index,
                          spareBox: currentSpareBoxData,
                          selectedProduct:
                              currentSpareBoxData['selectedProduct'],
                          showOtherItemsFields:
                              currentSpareBoxData['showOtherItemsFields'],
                          onNameChanged:
                              (v) => _onSpareBoxChanged(index, {'name': v}),

                          onDescriptionChanged:
                              (v) =>
                                  _onSpareBoxChanged(index, {'description': v}),
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
                          onSelectProductTap: () async {
                            _showSelectProductDialogForSpareBox(index);
                            return null;
                          },
                          maxQuantity:
                              currentSpareBoxData['maxQuantity'] ?? 1000,
                        );
                      }),
                    Text(
                      'Total Amount: ₹${_spareBoxes.fold<double>(0, (sum, box) => sum + ((box['quantity'] ?? 0) * (box['price'] ?? 0.0))).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: getHeight(context) * 0.01),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            _canAddNewItem
                                ? () {
                                  setState(() {
                                    _spareBoxes.add({
                                      'id':
                                          DateTime.now().microsecondsSinceEpoch
                                              .toString(),
                                      'quantity': 0,
                                      'price': 0.0,
                                      'total': 0.0,
                                      'name': '',
                                      'description': '',
                                      'selectedProduct': null,
                                      'showOtherItemsFields': false,
                                      'maxQuantity': 1000,
                                    });
                                    _validateItems();
                                  });
                                }
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.white,
                          side: BorderSide(
                            color:
                                _canAddNewItem ? AppColor.blue : AppColor.gray,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, color: AppColor.blue),
                            SizedBox(width: 8),
                            Text(
                              'ADD ITEMS',
                              style: TextStyle(color: AppColor.blue),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_sparesError)
                      Text(
                        'Please add at least one item',
                        style: TextStyle(color: Colors.red),
                      ),
                    buildButton(
                      text: 'SUBMIT',
                      isLoading: isLoading,
                      error: buttonError,
                      handleAction: () async {
                        if (buttonError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please fill all item fields'),
                            ),
                          );
                          return;
                        }
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                            _nameError = _customerNameController.text.isEmpty;
                            _phoneError = _phoneNumberController.text.isEmpty;
                            _phoneLengthError =
                                _phoneNumberController.text.length < 10;
                            _addressError = _addressController.text.isEmpty;
                            _sparesError = _spareBoxes.isEmpty;
                          });
                          try {
                            if (_nameError ||
                                _phoneError ||
                                _phoneLengthError ||
                                _alternatePhoneError ||
                                _addressError ||
                                _sparesError) {
                              return;
                            }
                            List<Map<String, dynamic>> billSpares =
                                _spareBoxes.map((spareBox) {
                                  return {
                                    "id":
                                        widget.title == 'Edit Details'
                                            ? widget.jobData.id
                                            : null,
                                    "billId": null,
                                    "productId":
                                        "2855035b-18f8-4c3a-9a90-812788f70d95",
                                    "product": spareBox['name'],
                                    "quantity": spareBox['quantity'],
                                    "price": spareBox['price'],
                                    "description":
                                        spareBox['description'] ?? "",
                                    "productList": {
                                      "id":
                                          "2855035b-18f8-4c3a-9a90-812788f70d95",
                                      "productName":
                                          spareBox['name'] ??
                                          "JR_OTHER_PRODUCT",
                                      "price": spareBox['price'] ?? 0.0,
                                      "quantity": spareBox['quantity'] ?? 0,
                                      "description":
                                          spareBox['description'] ?? "",
                                      "userId": _userId,
                                      "companyId": _companyId,
                                    },
                                    "selectedProduct": 'JR_OTHER_PRODUCT',
                                  };
                                }).toList();

                            final totalAmountForApi = _spareBoxes.fold<double>(
                              0,
                              (sum, box) =>
                                  sum +
                                  ((box['quantity'] ?? 0) *
                                      (box['price'] ?? 0.0)),
                            );
                            await context.read<SaveBillCubit>().save_bill(
                              context,
                              {
                                "id":
                                    widget.title == 'Edit Details'
                                        ? widget.jobData.id
                                        : null,
                                "billId": null,
                                "customerName": _customerNameController.text,
                                "address": _addressController.text,
                                "phoneNumber": _phoneNumberController.text,
                                "productName": 'category${widget.category}',
                                "status": 'received',
                                "modelNumber": 'category${widget.category}',
                                "serialNumber": 'category${widget.category}',
                                "complaint": "nan",
                                "otherAccessories": "nan",
                                "statusDescription": "",
                                "paidAmount": "0",
                                "totalAmount": totalAmountForApi,
                                "paymentType": "cash",
                                "userId": _userId,
                                "companyId": _companyId,
                                "billSpares": billSpares,
                              },
                              widget.companyName.toString(),
                              widget.companyPhone.toString(),
                              widget.category,
                            );
                          } finally {
                            if (mounted) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        }
                      },
                    ),
                    SizedBox(height: getHeight(context) * 0.05),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
