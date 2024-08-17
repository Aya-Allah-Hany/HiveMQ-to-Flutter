
import 'package:flutter/material.dart';
import 'package:problem8/Scripts/mqtt_manager.dart';
import 'package:syncfusion_flutter_charts/charts.dart';  // Make sure you have the correct import

class SubscribeScreen extends StatefulWidget {
  @override
  _SubscribeScreenState createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  final topicController = TextEditingController();
  final List<String> _messages = [];
  final List<ChartData> _chartData = []; // Add chart data list
  final MQTTClientWrapper mqttClientWrapper = MQTTClientWrapper();
  String? _currentTopic;
  double _currentReading = 0.0;

  @override
  void initState() {
    super.initState();
    mqttClientWrapper.prepareMqttClient();
    mqttClientWrapper.onMessageReceived = (message) {
      setState(() {
        _messages.add(message);
        _currentReading = double.parse(message); // Parse message to double
        _chartData.add(ChartData(DateTime.now(), _currentReading));
        if (_chartData.length > 20) {
          _chartData.removeAt(0);
        }
      });
      print('Message received: $message');
    };
  }

  void _subscribeToTopic(String topic) {
    if (_currentTopic != topic) {
      mqttClientWrapper.subscribeToTopic(topic);
      _currentTopic = topic;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscribe to Topic'),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.popAndPushNamed(context, '/home');
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: topicController,
              decoration: InputDecoration(
                labelText: 'Topic',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (topic) {
                _subscribeToTopic(topic);
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final topic = topicController.text;
                if (topic.isNotEmpty) {
                  _subscribeToTopic(topic);
                }
              },
              child: Text('Subscribe'),
            ),
            SizedBox(height: 20),
            // Add the chart widget
            Expanded(
              flex: 2, // Adjust flex to control size
              child: SfCartesianChart(
                primaryXAxis: DateTimeAxis(),
                primaryYAxis: NumericAxis(),
                series: <ChartSeries>[
                  LineSeries<ChartData, DateTime>(
                    dataSource: _chartData,
                    xValueMapper: (ChartData data, _) => data.time,
                    yValueMapper: (ChartData data, _) => data.value,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Display current reading below the chart
            Text('Current Reading: $_currentReading'),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_messages[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.time, this.value);
  final DateTime time;
  final double value;
}
