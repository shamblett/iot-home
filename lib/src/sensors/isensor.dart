/*
 * Package : iot_home_sensors
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 29/09/2017
 * Copyright :  S.Hamblett
 */

part of iot_home_sensors;

/// Sensor types
enum SensorTypes { none, dummy, temperature, light, pir }

/// Sensor state
enum SensorState { none, started, stopped }

/// Sensor data packet
class SensorData {
  SensorTypes type;
  dynamic value;
  int at;

  /// toString, remove the enum type from SensorTypes
  String toString() {
    return type.toString().split(".").toList()[1] +
        ":" +
        value.toString() +
        ":" +
        at.toString();
  }
}

/// Interface for all the sensors
abstract class ISensor {
  static const int defaultSampleTime = 10;

  /// The type of the sensor
  SensorTypes type = SensorTypes.none;

  /// The state the sensor is in
  SensorState state = SensorState.none;

  /// The value of the sensor
  dynamic value;

  /// The time the value was set(acquired)
  DateTime at;

  /// Time between sensor samples in seconds.
  int sampleTime;

  /// The stream of values emitted by the sensor
  final StreamController _values = new StreamController.broadcast();

  Stream<SensorData> get values => _values.stream;

  /// Initialiser
  void initialise();

  /// Start sensing
  void start();

  /// Stop sensing
  void stop();

  /// Get the latest sensor data as a message
  SensorData getSensorData() {
    final SensorData message = new SensorData();
    message.value = value;
    message.at = at.millisecondsSinceEpoch;
    message.type = type;
    return message;
  }
}
