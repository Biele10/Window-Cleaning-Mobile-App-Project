import 'package:flutter/material.dart';
import 'package:test2/app_screens/add_customer.dart';
import 'package:test2/app_screens/add_job.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});
  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  int _currentIndex = 1; // index for home page which is default page
  final List<Widget> _pages = [OrdersWidget(), HomeWidget(), SettingsWidget()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      appBar: AppBar(
        title: Text('Sponge'),
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        foregroundColor: Colors.grey[50],
      ),
      backgroundColor: Color(0xFF2E8B57),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_chart_rounded),
            label: 'Customers & Orders',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class OrdersWidget extends StatefulWidget {
  const OrdersWidget({super.key});
  @override
  State<OrdersWidget> createState() => StatefulOrdersWidget();
}

class StatefulOrdersWidget extends State<OrdersWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('This is the Orders page.'));
  }
}

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(child: Image.asset("images/brain.jpg")),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Welcome, Malcom',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color?>((
                  Set<WidgetState> states,
                ) {
                  if (states.contains(WidgetState.pressed)) {
                    return Color(0xFF292828);
                  }

                  return Color(0xFF3B3939);
                }),
              ),

              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddCustomer()),
                );
              },
              child: Text(
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD9D9D9),
                ),
                'Add Customer',
              ),
            ),
          ),
        ),

        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color?>((
                  Set<WidgetState> states,
                ) {
                  if (states.contains(WidgetState.pressed)) {
                    return Color(0xFF292828);
                  }

                  return Color(0xFF3B3939);
                }),
              ),

              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddJob()),
                );
              },
              child: Text(
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD9D9D9),
                ),
                'Add Job',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('This is the Settings page.'));
  }
}
