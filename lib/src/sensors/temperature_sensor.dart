/*
 * Package : iot_home_sensors
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 03/004/2018
 * Copyright :  S.Hamblett
 */

part of iot_home_sensors;

/// A temperature sensor class, this class generates a stream of integer centigrade values generated
/// from the beaglebone board temperature sensor.
/// A value is generated every sampleTime seconds.
class TemperatureSensor extends ISensor {
  /// Construction
  TemperatureSensor([sampleTime = ISensor.defaultSampleTime]) {
    type = SensorTypes.temperature;
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
    final String command = "python " + Secrets.temperatureScript;
    _script =
    new ExecuteSensorScript.withSudo(command, Secrets.workingDirectory, []);
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
    _script.updateValueSync();
    final String output = _script.output;
    value = int.parse(output);
    at = _script.lastValueTime;
  }
}
