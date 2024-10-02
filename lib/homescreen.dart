import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'stock.dart'; // Import the Stock model

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  String? selectedStore;
  late Future<Box<Stock>>
      stockBoxFuture; // For storing the future of box opening

  @override
  void initState() {
    super.initState();
    stockBoxFuture =
        Hive.openBox<Stock>('thestocks'); // Open the box asynchronously
  }

  List<DropdownMenuItem<String>> get items {
    return [
      const DropdownMenuItem(value: "Store 1", child: Text("Store 1")),
      const DropdownMenuItem(value: "Store 2", child: Text("Store 2")),
      const DropdownMenuItem(value: "Store 3", child: Text("Store 3")),
      const DropdownMenuItem(value: "Store 4", child: Text("Store 4")),
      const DropdownMenuItem(value: "Store 5", child: Text("Store 5")),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 37, 33, 243),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontSize: 34.0,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 37, 33, 243),
        title: Center(
          child: Text(
            "Stocks",
            style: GoogleFonts.poppins(
              fontSize: 40.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: FutureBuilder<Box<Stock>>(
        future: stockBoxFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading stocks."));
          }

          final stockBox = snapshot.data!; // The box is now available

          return Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text("Store:", style: GoogleFonts.poppins()),
                    const SizedBox(width: 16),
                    DropdownButton<String>(
                      value: selectedStore,
                      items: items,
                      onChanged: (value) {
                        setState(() {
                          selectedStore = value;
                        });
                      },
                      hint: const Text("Select Store"),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: stockBox.listenable(),
                    builder: (context, Box<Stock> box, _) {
                      if (box.isEmpty) {
                        return const Text("No stock available.");
                      }

                      // Filter the stocks by the selected store
                      final filteredStocks = box.values.where((stock) {
                        return selectedStore == null ||
                            stock.store == selectedStore;
                      }).toList();

                      if (filteredStocks.isEmpty) {
                        return const Text(
                            "No stock available for the selected store.");
                      }

                      return Table(
                        border: TableBorder.all(color: Colors.black),
                        children: [
                          TableRow(
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(85, 223, 222, 222),
                            ),
                            children: [
                              _buildTableCell('Name'),
                              _buildTableCell('Units'),
                              _buildTableCell('Unit Price'),
                              _buildTableCell('Total Price'),
                            ],
                          ),
                          ...filteredStocks.map((stock) {
                            return _buildDataRow(
                              stock.name,
                              stock.units.toString(),
                              stock.unitPrice.toString(),
                              stock.totalPrice.toString(),
                            );
                          }),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _showAddStockDialog(context), // Show the dialog when pressed
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddStockDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController unitsController = TextEditingController();
    final TextEditingController unitPriceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Stock'),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(8), // Less rounded for boxy look
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Stock Name'),
              ),
              TextField(
                controller: unitsController,
                decoration: const InputDecoration(labelText: 'Units'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: unitPriceController,
                decoration: const InputDecoration(labelText: 'Unit Price'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red, // Text color for Cancel button
                textStyle: TextStyle(
                  fontSize: 18,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Boxy button
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, // Text color for Cancel button
                textStyle: TextStyle(
                  fontSize: 18,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  // fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Boxy button
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              onPressed: () {
                final name = nameController.text;
                final units = int.tryParse(unitsController.text) ?? 0;
                final unitPrice =
                    double.tryParse(unitPriceController.text) ?? 0.0;

                if (name.isNotEmpty && units > 0 && unitPrice > 0) {
                  if (selectedStore != null) {
                    _addStock(
                        name, units, unitPrice, selectedStore!); // Add stock
                  } else {
                    // Handle the case when selectedStore is null
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select a store')),
                    );
                  }
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addStock(String name, int units, double unitPrice, String store) async {
    final stockBox =
        await Hive.openBox<Stock>('thestocks'); // Ensure the box is open
    final stock =
        Stock(name: name, units: units, unitPrice: unitPrice, store: store);
    await stockBox.add(stock); // Add stock to Hive
  }

  TableRow _buildDataRow(
      String name, String units, String unitPrice, String totalPrice) {
    return TableRow(
      children: [
        _buildDataCell(name),
        _buildDataCell(units),
        _buildDataCell(unitPrice),
        _buildDataCell(totalPrice),
      ],
    );
  }

  Widget _buildTableCell(String text) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
      ),
    );
  }

  Widget _buildDataCell(String text) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: GoogleFonts.roboto(
          fontSize: 25.0,
          color: Colors.black,
        ),
      ),
    );
  }
}
