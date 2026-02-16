import 'package:assistify/core/constants/colors.dart';
import 'package:flutter/material.dart';

class SmallScalePosScreen extends StatefulWidget {
  const SmallScalePosScreen({super.key});

  @override
  State<SmallScalePosScreen> createState() => _SmallScalePosScreenState();
}

class _SmallScalePosScreenState extends State<SmallScalePosScreen> {

  List<Map<String, dynamic>> products = [
    {"id": 1, "name": "Idly", "price": 20.0, "qty": 0},
    {"id": 2, "name": "Dosa", "price": 30.0, "qty": 0},
    {"id": 3, "name": "Poori", "price": 25.0, "qty": 0},
    {"id": 4, "name": "Chapathi", "price": 15.0, "qty": 0},
    {"id": 5, "name": "masala vada", "price": 20.0, "qty": 0},
    {"id": 6, "name": "Pongal", "price": 30.0, "qty": 0},
    {"id": 7, "name": "masala dosa", "price": 25.0, "qty": 0},
    {"id": 8, "name": "bonda", "price": 15.0, "qty": 0},
    {"id": 9, "name": "masala vada", "price": 20.0, "qty": 0},
    {"id": 10, "name": "Pongal", "price": 30.0, "qty": 0},
    {"id": 11, "name": "masala dosa", "price": 25.0, "qty": 0},
    {"id": 12, "name": "bonda", "price": 15.0, "qty": 0},
  ];

  double get totalAmount {
    double total = 0;
    for (var item in products) {
      total += item["price"] * item["qty"];
    }
    return total;
  }

  int get totalQty {
    int qty = 0;
    for (var item in products) {
      qty += item["qty"] as int;
    }
    return qty;
  }

  void clearAll() {
    setState(() {
      for (var item in products) {
        item["qty"] = 0;
      }
    });
  }

  void showBillAlert() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Bill"),
        content: const Text("Bill Triggered Successfully"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

@override
Widget build(BuildContext context) {
  return Column(
    children: [

      const SizedBox(height: 40),

      /// 🔹 TITLE LEFT SIDE
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Tulasi Tiffins',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColor.primaryColor,
            ),
          ),
        ),
      ),

      const SizedBox(height: 10),

      /// 🔹 TOTAL SECTION
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: Colors.blue.shade50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Qty: $totalQty",
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              "Total: ₹${totalAmount.toStringAsFixed(2)}",
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),

      /// 🔹 PRODUCT GRID (Smaller Boxes)
      Expanded(
        child: GridView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 🔥 changed from 2 to 3
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.0, // 🔥 smaller height
          ),
          itemBuilder: (context, index) {
            final product = products[index];

            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    color: Colors.grey.shade300,
                  )
                ],
              ),
              padding: const EdgeInsets.all(8), // 🔥 reduced padding
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  /// Product Name
                  Text(
                    product["name"],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold),
                  ),

                  /// Price
                  Text(
                    "₹${product["price"]}",
                    style: const TextStyle(fontSize: 12),
                  ),

                  /// Quantity Controls
                  product["qty"] == 0
                      ? SizedBox(
                          height: 30,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () {
                              setState(() {
                                product["qty"] = 1;
                              });
                            },
                            child: const Icon(Icons.add, size: 18),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (product["qty"] > 0) {
                                    product["qty"]--;
                                  }
                                });
                              },
                              child: const Icon(Icons.remove, size: 18),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "${product["qty"]}",
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  product["qty"]++;
                                });
                              },
                              child: const Icon(Icons.add, size: 18),
                            ),
                          ],
                        ),
                ],
              ),
            );
          },
        ),
      ),

      /// 🔹 BOTTOM BUTTONS
      Container(
        padding: const EdgeInsets.all(10),
        color: Colors.grey.shade200,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: showBillAlert,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green),
                child: const Text("Print"),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: clearAll,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red),
                child: const Text("Clear"),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
}
