import 'package:assistify/components/custome_text_field.dart';
import 'package:assistify/core/constants/colors.dart';
import 'package:assistify/core/constants/sizes.dart';
import 'package:assistify/presentation/cubit/dashboard/all_bills/all_bills_cubit.dart';
import 'package:assistify/presentation/cubit/dashboard/save_bill/save_bill_cubit.dart';
import 'package:assistify/presentation/widgets/add-job_form_screen_widgets.dart/section_header.dart';
import 'package:assistify/presentation/widgets/add-job_form_screen_widgets.dart/custom_drop_down_field.dart';
import 'package:assistify/presentation/widgets/add-job_form_screen_widgets.dart/spare_box.dart'; // Ensure this import is correct
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddJobFormScreen extends StatefulWidget {
  final dynamic jobData;
  AddJobFormScreen({Key? key, this.jobData}) : super(key: key);
  @override
  _AddJobFormScreenState createState() => _AddJobFormScreenState();
}

class _AddJobFormScreenState extends State<AddJobFormScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _userId;
  String? _companyId;

  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _alternatePhoneNumberController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _statusDescriptionController =
      TextEditingController();
  final TextEditingController _productOrderNameController =
      TextEditingController();
  final TextEditingController _modelNumberController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _orderComplaintController =
      TextEditingController();
  final TextEditingController _otherAccessoriesController =
      TextEditingController();
  final TextEditingController _paidAmountController = TextEditingController();
  final TextEditingController _balanceAmountController =
      TextEditingController();

  bool _nameError = false;
  bool _phoneError = false;
  bool _alternatePhoneError = false;
  bool _addressError = false;
  bool _statusDescriptionError = false;
  bool _productOrderNameError = false;
  bool _modelNumberError = false;
  bool _serialNumberError = false;
  bool _orderComplaintError = false;
  bool _otherAccessoriesError = false;
  bool _paidAmountError = false;
  bool _balanceAmountError = false;
  bool _sparesError = false;
  bool _statusError = false;

  String? _statusSelected;
  String _paymentMode = '';
  List<Map<String, dynamic>> _spareBoxes = [];

  final List<String> _statuses = [
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
  final List<String> _selectProducts = ['ink bottle', 'laptop', 'Other Items'];
  final List<String> _payments = ['card', 'COD', 'Bank Transfer', 'Upi'];

  @override
  void initState() {
    super.initState();
    _fetchData();
    _updateBalanceAmount();
    print(widget.jobData);
    _paidAmountController.addListener(_updateBalanceAmount);
    if (widget.jobData != null) {
      context.read<AllBillsCubit>().spareBills(
        context: context,
        jobId: widget.jobData.id,
      );
    }
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
    setState(() {
      _userId = prefs.getString('userId') ?? '';
      _companyId = prefs.getString('companyId') ?? '';
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

  void _showStatusDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? tempSelectedStatus = _statusSelected;
        return AlertDialog(
          backgroundColor: AppColor.white,
          title: Text('Select Status'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children:
                      _statuses.map((status) {
                        return RadioListTile<String>(
                          fillColor: MaterialStateProperty.all(AppColor.blue),
                          title: Text(status),
                          value: status,
                          groupValue: tempSelectedStatus,
                          onChanged: (value) {
                            setState(() {
                              tempSelectedStatus = value;
                            });
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
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: AppColor.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK', style: TextStyle(color: AppColor.blue)),
              onPressed: () {
                setState(() {
                  _statusSelected = tempSelectedStatus;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showPaymentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? tempPaymentMode = _paymentMode;
        return AlertDialog(
          backgroundColor: AppColor.white,
          title: Text('Select Payment Mode'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children:
                      _payments.map((payment) {
                        return RadioListTile<String>(
                          fillColor: WidgetStateProperty.all(Colors.blue),
                          title: Text(payment),
                          value: payment,
                          groupValue: tempPaymentMode,
                          onChanged: (value) {
                            setState(() {
                              tempPaymentMode = value;
                            });
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
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: AppColor.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK', style: TextStyle(color: AppColor.blue)),
              onPressed: () {
                setState(() {
                  _paymentMode = tempPaymentMode!;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSelectProductDialogForSpareBox(int spareBoxIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? tempProductMode = _spareBoxes[spareBoxIndex]['selectedProduct'];
        return AlertDialog(
          backgroundColor: AppColor.white,
          title: Text('Select Product'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children:
                      _selectProducts.map((product) {
                        return RadioListTile<String>(
                          fillColor: WidgetStateProperty.all(Colors.blue),
                          title: Text(product),
                          value: product,
                          groupValue: tempProductMode,
                          onChanged: (value) {
                            setState(() {
                              tempProductMode = value;
                            });
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
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: AppColor.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK', style: TextStyle(color: AppColor.blue)),
              onPressed: () {
                setState(() {
                  _spareBoxes[spareBoxIndex]['selectedProduct'] =
                      tempProductMode;
                  _spareBoxes[spareBoxIndex]['showOtherItemsFields'] =
                      tempProductMode == 'Other Items';
                });
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
        title: const Text('Add Job'),
        backgroundColor: AppColor.white,
        centerTitle: true,
        shadowColor: AppColor.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
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
                _phoneNumberController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                'Phone Number',
                errorText: _phoneError ? 'Please enter a phone number' : null,
                onChanged: (value) {
                  setState(() {
                    _phoneError = value.isEmpty;
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

              const SectionHeader(Icons.wifi, 'Status Details'),
              CustomDropdownField(
                hintText: 'Select Status',
                selectedValue: _statusSelected,
                onTap: _showStatusDialog,
              ),
              _statusError ?
              Text(
                'please select status',
                style: TextStyle(
                  color: AppColor.red,
                  fontWeight: FontWeight.bold,
                ),
              ) : SizedBox(),
              const SizedBox(height: 10),
              customTextField(
                _statusDescriptionController,
                'Status Description',
                errorText:
                    _statusDescriptionError
                        ? 'Please enter a status description'
                        : null,
                onChanged: (value) {
                  setState(() {
                    _statusDescriptionError = value.isEmpty;
                  });
                },
              ),
              const SectionHeader(Icons.build, 'Product / Order Details'),
              customTextField(
                _productOrderNameController,
                'Product / Order Name',
                errorText:
                    _productOrderNameError
                        ? 'Please enter a product / order name'
                        : null,
                onChanged: (value) {
                  setState(() {
                    _productOrderNameError = value.isEmpty;
                  });
                },
              ),
              customTextField(
                _modelNumberController,
                'Model Number',
                errorText:
                    _modelNumberError ? 'Please enter a model number' : null,
                onChanged: (value) {
                  setState(() {
                    _modelNumberError = value.isEmpty;
                  });
                },
              ),
              customTextField(
                _serialNumberController,
                'Serial Number',
                errorText:
                    _serialNumberError ? 'Please enter a serial number' : null,
                onChanged: (value) {
                  setState(() {
                    _serialNumberError = value.isEmpty;
                  });
                },
              ),
              customTextField(
                _orderComplaintController,
                'Order / Complaint',
                errorText:
                    _orderComplaintError
                        ? 'Please enter an order / complaint'
                        : null,
                onChanged: (value) {
                  setState(() {
                    _orderComplaintError = value.isEmpty;
                  });
                },
              ),
              customTextField(
                _otherAccessoriesController,
                'Other Accessories',
                errorText:
                    _otherAccessoriesError
                        ? 'Please enter other accessories'
                        : null,
                onChanged: (value) {
                  setState(() {
                    _otherAccessoriesError = value.isEmpty;
                  });
                },
              ),
              const SectionHeader(
                Icons.circle,
                'Spares / Estimations / Services',
              ),
              Column(
                children: [
                  ...List.generate(_spareBoxes.length, (index) {
                    final currentSpareBoxData = _spareBoxes[index];
                    return SpareBox(
                      key: ValueKey(currentSpareBoxData['id']),
                      index: index,
                      spareBox: currentSpareBoxData,
                      selectedProduct: currentSpareBoxData['selectedProduct'],
                      showOtherItemsFields:
                          currentSpareBoxData['selectedProduct'] ==
                          'Other Items',
                      onNameChanged: (value) {
                        setState(() {
                          currentSpareBoxData['name'] = value;
                        });
                      },
                      onDescriptionChanged: (value) {
                        setState(() {
                          currentSpareBoxData['description'] = value;
                        });
                      },
                      onQuantityChanged: (value) {
                        setState(() {
                          currentSpareBoxData['quantity'] =
                              int.tryParse(value) ?? 0;
                          currentSpareBoxData['total'] =
                              (currentSpareBoxData['quantity'] ?? 0) *
                              (currentSpareBoxData['price'] ?? 0.0);
                          _updateBalanceAmount();
                        });
                      },
                      onPriceChanged: (value) {
                        setState(() {
                          currentSpareBoxData['price'] =
                              double.tryParse(value) ?? 0.0;
                          currentSpareBoxData['total'] =
                              (currentSpareBoxData['quantity'] ?? 0) *
                              (currentSpareBoxData['price'] ?? 0.0);
                          _updateBalanceAmount();
                        });
                      },
                      onDelete: () {
                        setState(() {
                          _spareBoxes.removeAt(index);
                          _updateBalanceAmount();
                        });
                      },
                      onSelectProductTap:
                          () => _showSelectProductDialogForSpareBox(index),
                    );
                  }),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
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
                          });
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.white,
                        side: BorderSide(color: AppColor.blue),
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
                            'ADD SPARES',
                            style: TextStyle(color: AppColor.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // _sparesError
              //     ? Text(
              //       'Please add spares',
              //       style: TextStyle(
              //         color: AppColor.red,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     )
              //     : SizedBox(),
              Text(
                'Total Amount: ₹${_spareBoxes.fold<double>(0, (sum, box) => sum + ((box['quantity'] ?? 0) * (box['price'] ?? 0.0))).toStringAsFixed(2)}',
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
                onChanged: (value) {
                  setState(() {
                    _paidAmountError = value.isEmpty;
                  });
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
                onChanged: (value) {},
              ),
              CustomDropdownField(
                hintText: 'Select Payment Mode',
                selectedValue: _paymentMode.isEmpty ? null : _paymentMode,
                onTap: _showPaymentDialog,
              ),
              SizedBox(height: getHeight(context) * 0.01),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _nameError = _customerNameController.text.isEmpty;
                        _phoneError = _phoneNumberController.text.isEmpty;
                        _addressError = _addressController.text.isEmpty;
                        _statusDescriptionError =
                            _statusDescriptionController.text.isEmpty;
                        _productOrderNameError =
                            _productOrderNameController.text.isEmpty;
                        _modelNumberError = _modelNumberController.text.isEmpty;
                        _serialNumberError =
                            _serialNumberController.text.isEmpty;
                        _orderComplaintError =
                            _orderComplaintController.text.isEmpty;
                        _paidAmountError = _paidAmountController.text.isEmpty;
                        _spareBoxes.length == 0;
                        _statusSelected == '';
                      });
                    }
                    if (_nameError ||
                        _phoneError ||
                        _alternatePhoneError ||
                        _addressError ||
                        _statusDescriptionError ||
                        _productOrderNameError ||
                        _modelNumberError ||
                        _serialNumberError ||
                        _orderComplaintError ||
                        _otherAccessoriesError ||
                        _paidAmountError ||
                        
                        _statusError) {
                      return;
                    }
                    
                      List<Map<String, dynamic>> billSpares =
                          _spareBoxes.map((spareBox) {
                            return {
                              "id": null,
                              "billId": null,
                              "productId":
                                  "2855035b-18f8-4c3a-9a90-812788f70d95",
                              "product": spareBox['selectedProduct'],
                              "quantity": spareBox['quantity'],
                              "price": spareBox['price'],
                              "description": spareBox['description'] ?? "",
                              "productList": {
                                "id": "2855035b-18f8-4c3a-9a90-812788f70d95",
                                "productName":
                                    spareBox['name'] ?? "JR_OTHER_PRODUCT",
                                "price": spareBox['price'] ?? 0.0,
                                "quantity": spareBox['quantity'] ?? 0,
                                "description": spareBox['description'] ?? "",
                                "userId": _userId,
                                "companyId": _companyId,
                              },
                              "otherProduct":
                                  spareBox['selectedProduct'] == 'Other Items',
                              "selectedProduct": spareBox['selectedProduct'],
                            };
                          }).toList();

                      final totalAmountForApi = _spareBoxes.fold<double>(
                        0,
                        (sum, box) =>
                            sum +
                            ((box['quantity'] ?? 0) * (box['price'] ?? 0.0)),
                      );

                      context.read<SaveBillCubit>().save_bill(context, {
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
                            double.tryParse(_paidAmountController.text) ?? 0.0,
                        "totalAmount": totalAmountForApi,
                        "paymentType": _paymentMode,
                        "statusDescription": _statusDescriptionController.text,
                        "userId": _userId,
                        "companyId": _companyId,
                        "billSpares": billSpares,
                      });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.white,
                    side: BorderSide(color: AppColor.blue),
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(color: AppColor.black),
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
