import 'package:problem8/Scripts/mqtt_manager.dart'; // Ensure this import is correct based on your project structure
import 'package:flutter/material.dart';

class servo extends StatefulWidget {
  @override
  _ServoState createState() => _ServoState();
}

class _ServoState extends State<servo> {
  final _topicController = TextEditingController();
  double _currentValue = 0;
  final MQTTClientWrapper mqttClientWrapper = MQTTClientWrapper();

  @override
  void initState() {
    super.initState();
    mqttClientWrapper.prepareMqttClient();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Publish Message'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, '/home');
            },
            icon: Icon(Icons.home),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: _topicController,
              decoration: InputDecoration(
                icon: Icon(Icons.topic),
                labelText: 'Topic',
                hintText: "Enter the TOPIC name",
              ),
            ),
            Slider(
              value: _currentValue,
              min: 0,
              max: 180,
              divisions: 6,
              label: _currentValue.round().toString(),
              onChanged: (value) {
                setState(() {
                  _currentValue = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Publish'),
              onPressed: () {
                if (_topicController.text.isNotEmpty) {
                  mqttClientWrapper.publishMessage(
                    _topicController.text,
                    _currentValue.toString(),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a topic name')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
