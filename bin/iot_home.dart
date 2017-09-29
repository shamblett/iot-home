/*
 * Project : iot-home
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 29/09/2017
 * Copyright :  S.Hamblett
 */

import 'dart:io';
import 'package:iot_home/iot_home_sensors.dart';

int main(List<String> args) {
  print("Welcome to iot-home");

  /// Create our sensor and start it
  final DummySensor sensor = new DummySensor();
  sensor.initialise();
  sensor.start();

  /// Listen for values
  while (true) {
    sensor.values.listen((SensorData data) {
      print("The latest value is ${data.value} at time ${data.at.toString()}");
    });
  }
  return 0;
}