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
      body: _pages[_currentIndex], // depending on which tab the user pressed,
      // the corresponding index will run the Widget constructor. e.g. index 0
      // will run the OrdersWidget constructor
      appBar: AppBar(
        // displays a bar at the top of the screen with the title of the app
        title: Text('Handyman'),
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        foregroundColor: Colors.grey[50],
      ),
      backgroundColor: Color(0xFF37454a),
      bottomNavigationBar: BottomNavigationBar(
        // navigation bar at the bottom
        // of the screen
        currentIndex: _currentIndex, // tells Dart which icon in the
        // navigation bar to highlight to show it's selected
        onTap: (int index) {
          // sends the index of the button tapped through
          setState(() {
            // calls for the page to be updated
            _currentIndex = index; // updates the button to be highlighted
          });
        },
        items: const [
          BottomNavigationBarItem(
            // adds the icons to the navigation bar
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
  // orderswidget class
  const OrdersWidget({super.key});
  @override
  State<OrdersWidget> createState() => StatefulOrdersWidget();
}

class StatefulOrdersWidget extends State<OrdersWidget> {
  // stateful class
  // for orders widget
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('This is the Orders page.'));
  }
}

class HomeWidget extends StatelessWidget {
  // class for home widget
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(child: Image.asset("images/brain.jpg")), //puts image of House
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(20.0), // spaces image from text by 20
            // pixels
            child: Text(
              'Welcome, Malcom',
              style: TextStyle(
                // determines font, bold, text colour/size etc
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Align(
          // determines where widgets are aligned
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color?>((
                  Set<WidgetState> states,
                ) {
                  if (states.contains(WidgetState.pressed)) {
                    return Color(0xFF292828); // if the button is being pressed,
                    // the background colour of the button changes to this
                  }

                  return Color(0xFF3B3939); // if it's stationary, it is this
                  // colour by default. when a new page is opened, these sort of
                  // if statements are always run once, so this means that by
                  // default the colour 3B3939 will be the background colour
                  // of the button
                }),
              ),

              onPressed: () {
                Navigator.push(
                  // pushes the current widget onto a widget stack,
                  // this allows for it later to be returned to, flutter has a
                  // feature where if the page being connected to has an appbar,
                  // it will automatically implement a back button to allow the
                  // user to return back to the previous page.
                  context,
                  MaterialPageRoute(builder: (context) => AddCustomer()),
                  // opens the AddCustomer page
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
          // all this stuff is the same as the Add Customer button
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
