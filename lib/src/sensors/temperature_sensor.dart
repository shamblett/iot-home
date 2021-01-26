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
    // Initialise Mraa
    _mraa.noJsonLoading = true;
    _mraa.initialise();
    _mraa.common.initialise();
    // The temperature sensor is on AIO 2 on the beaglebone green
    _aioContext = _mraa.aio.initialise(2);
    _temperatureSensor = sensor.GroveTemperatureV12(_mraa, _aioContext);
  }

  /// The value generation period timer and its callback
  late Timer _timer;

  void _timerCallBack(Timer timer) {
    _generateValue();
    final data = getSensorData();
    _values.add(data);
  }

  /// Mraa
  final mraa.Mraa _mraa = mraa.Mraa.fromLib('beaglebone/libmraa.so.2.0.0');
  late ffi.Pointer<mraa.MraaAioContext> _aioContext;

  /// Grove sensors
  late sensor.GroveTemperatureV12 _temperatureSensor;

  /// Initialiser
  @override
  void initialise() {}

  /// Start sensing
  @override
  void start() {
    /// Start the periodic timer
    _timer = Timer.periodic(Duration(seconds: sampleTime), _timerCallBack);

    /// Generate an initial value
    _generateValue();
    final data = getSensorData();
    _values.add(data);
    state = SensorState.started;
  }

  /// Stop sensing
  @override
  void stop() {
    _timer.cancel();
    state = SensorState.stopped;
    _values.close();
  }

  /// Get the temperature from the board sensor
  void _generateValue() {
    try {
      final values = _temperatureSensor.values;
      value = values.celsius;
    } catch (e) {
      print(Secrets.temperatureDeviceId +
          ' exception raised getting sensor value');
      print(e);
    }
  }
}
