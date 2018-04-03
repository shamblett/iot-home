/*
 * Package : iot_home_sensors
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 29/09/2017
 * Copyright :  S.Hamblett
 */

part of iot_home_sensors;

/// Project/ Device Id's etc
class Secrets {
  static const String projectId = 'warm-actor-356';
  static const String region = 'europe-west1';
  static const String registry = 'home-sensors';

  static const String dummyDeviceId = 'dummy-sensor';
  static const String temperatureDeviceId = 'temperature-sensor';

  static const String workingDirectory =
      '/home/debian/Development/scripts/analogue/';
  static const String temperatureScript = workingDirectory + 'temperature.sh';
}
