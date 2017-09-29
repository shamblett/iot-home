/*
 * Package : iot_home_sensors
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 29/09/2017
 * Copyright :  S.Hamblett
 */

part of iot_home_sensors;

/// A dummy sensor class, this class generates a stream of integer values generated
/// randomly between the range of 0..40. A value is generated every 10 seconds.
class DummySensor extends ISensor {
  /// Construction
  DummySensor() {
    type = SensorTypes.dummy;
    value = 0;
    state = SensorState.stopped;
    _random = new Random();
  }

  /// The value generation period timer and its callback
  Timer _timer;

  void _timerCallBack(Timer timer) {
    _generateValue();
    final SensorData data = getSensorData();
    _values.add(data);
  }

  /// The random number generator
  Random _random;

  /// Initialiser
  void initialise() {
    /// Nothing to do here
  }

  /// Start sensing
  void start() {
    /// Start the periodic timer
    _timer = new Timer.periodic(new Duration(seconds: 10), _timerCallBack);

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

  /// Generate a random value at this time
  void _generateValue() {
    value = _random.nextInt(40);
    at = new DateTime.now();
  }
}
