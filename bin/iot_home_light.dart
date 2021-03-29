/*
 * Project : iot-home
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 04/04/2018
 * Copyright :  S.Hamblett
 */

import 'dart:io';
import 'dart:async';
import 'package:iot_home/iot_home_sensors.dart';
import 'package:args/args.dart';
import 'package:intl/intl.dart';

Future main(List<String> args) async {
  var mqttLogging = false;
  var sampleRate = ISensor.defaultSampleTime;

  /// Command line parameters
  final parser = ArgParser();
  parser.addFlag('log',
      abbr: 'l', defaultsTo: false, callback: (log) => mqttLogging = log);
  parser.addOption('sampleRate',
      abbr: 's', defaultsTo: ISensor.defaultSampleTime.toString(),
      callback: (sampleRateOption) {
    sampleRate = int.parse(sampleRateOption!);
    if (sampleRate <= 0) {
      sampleRate = ISensor.defaultSampleTime;
    }
  });

  parser.parse(args);

  /// Announce and start
  print(
      'Welcome to iot-home for device ${Secrets.lightDeviceId} with a sample rate of $sampleRate seconds');

  /// Create our sensor and start it
  final sensor = LightSensor(sampleRate);
  sensor.initialise();
  sensor.start();

  /// Create our MQTT bridge and initialise it
  final bridge = MqttBridge(Secrets.lightDeviceId);
  bridge.logging = mqttLogging;
  bridge.initialise();

  // Listen for any input on stdin, if any stop the sensor
  stdin.listen((List<int> data) => sensor.stop());

  /// Listen for values
  final format = DateFormat('y-MM-dd-HH:mm:ss');
  await for (SensorData data in sensor.values) {
    final dateString =
        format.format(DateTime.fromMillisecondsSinceEpoch(data.at));
    print(
        '${Secrets.lightDeviceId} value is ${data.value} at time $dateString');
    // Dont publish unless the bridge is ready
    if (bridge.initialised) {
      bridge.update(data);
    } else {
      print('iot-home: not updated bridge not ready');
    }
  }

  print('Goodbye from iot-home');
  exit(0);
}
