/*
 * Package : iot_home_sensors
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 03/004/2018
 * Copyright :  S.Hamblett
 */

part of iot_home_sensors;

/// A light sensor class, this class generates a stream of integer lux values generated
/// from the beaglebone board light sensor.
/// A value is generated every sampleTime seconds.
class LightSensor extends ISensor {
  /// Construction
  LightSensor([sampleTime = ISensor.defaultSampleTime]) {
    type = SensorTypes.light;
    value = 0;
    state = SensorState.stopped;
    this.sampleTime = sampleTime;
  }

  /// The value generation period timer and its callback
  Timer _timer;

  void _timerCallBack(Timer timer) {
    _generateValue();
    final SensorData data = getSensorData();
    _values.add(data);
  }

  /// The script execution object
  ExecuteSensorScript _script;

  /// Initialiser
  void initialise() {
    /// Create the script execution object
    final String command = Secrets.lightScript;
    _script = new ExecuteSensorScript(command, Secrets.workingDirectory, []);
  }

  /// Start sensing
  void start() {
    /// Start the periodic timer
    _timer =
        new Timer.periodic(new Duration(seconds: sampleTime), _timerCallBack);

    /// Generate an initial value
    _generateValue();
    final SensorData data = getSensorData();
    _values.add(data);
    state = SensorState.started;
  }

  /// Stop sensing
  void stop() {
    _timer.cancel();
    state = SensorState.stopped;
    _values.close();
  }

  /// Get the temperature from the board sensor
  void _generateValue() {
    try {
      _script.updateValueSync();
      final String output = _script.output;
      value = int.parse(output);
      at = _script.lastValueTime;
    } catch (e) {
      print(Secrets.lightDeviceId + " exception raised getting sensor value");
      print(e);
    }
  }
}
