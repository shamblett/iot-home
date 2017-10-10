/*
 * Project : iot-home
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 29/09/2017
 * Copyright :  S.Hamblett
 */

import 'dart:io';
import 'dart:async';
import 'package:iot_home/iot_home_sensors.dart';

Future main(List<String> args) async {
  print("Welcome to iot-home");

  /// Create our sensor and start it
  final DummySensor sensor = new DummySensor();
  sensor.initialise();
  sensor.start();

  /// Create our MQTT bridge and initialise it
  final MqttBridge bridge = new MqttBridge(Secrets.dummyDeviceId);
  bridge.initialise();

  // Listen for any input on stdin, if any stop the sensor
  stdin.listen((List<int> data) => sensor.stop());

  /// Listen for values
  await for (SensorData data in sensor.values) {
    print("Dummy sensor value is ${data.value} at time ${data.at}");
    // Dont publish unless the bridge is ready
    if (bridge.initialised) {
      bridge.update(data.value);
    } else {
      print("iot-home: not updated bridge not ready");
    }
  }

  print("Goodbye from iot-home");
  exit(0);
}
