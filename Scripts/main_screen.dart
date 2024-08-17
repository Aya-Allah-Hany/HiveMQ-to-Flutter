import 'package:flutter/material.dart';
import 'sensor_reading_screen.dart'; // Import your sensor readings screen
import 'servo_controller_screen.dart'; // Import your servo controller screen

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SubscribeScreen()),
                );
              },
              child: Text('Sensor Readings'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => servo()),
                );
              },
              child: Text('Servo Controller'),
            ),
          ],
        ),
      ),
    );
  }
}
