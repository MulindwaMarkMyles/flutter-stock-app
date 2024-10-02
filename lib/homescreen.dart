import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  String? selectedStore; // To hold the selected dropdown value
  List<DropdownMenuItem<String>> get items {
    return [
      DropdownMenuItem(value: "Store 1", child: Text("Store 1")),
      DropdownMenuItem(value: "Store 2", child: Text("Store 2")),
      DropdownMenuItem(value: "Store 3", child: Text("Store 3")),
      DropdownMenuItem(value: "Store 4", child: Text("Store 4")),
      DropdownMenuItem(value: "Store 5", child: Text("Store 5")),
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
              decoration: BoxDecoration(
                color: Colors.black,
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
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Handle navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                // Handle logout
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Center(
          child: Text(
            "Stocks",
            style: GoogleFonts.poppins(
              fontSize: 40.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Container(
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
            Table(
              border: TableBorder.all(color: Colors.black),
              children: [
                TableRow(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(85, 223, 222, 222)),
                  children: [
                    _buildTableCell('Name'),
                    _buildTableCell('Units'),
                    _buildTableCell('Unit Price'),
                    _buildTableCell('Total Price'),
                  ],
                ),
                _buildDataRow('AAPL', '120', '10000', '12000000'),
                _buildDataRow('AAPL', '120', '10000', '12000000'),
                _buildDataRow('AAPL', '120', '10000', '12000000'),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      
    );
  }

  TableRow _buildDataRow(String name, String units, String unitPrice, String totalPrice) {
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
