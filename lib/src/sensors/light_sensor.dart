/*
 * Package : iot_home_sensors
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 03/004/2018
 * Copyright :  S.Hamblett
 */

part of iot_home_sensors;

/// A light sensor class, this class generates a stream of raw integer values generated
/// from the beaglebone board light sensor.
/// A value is generated every sampleTime seconds.
class LightSensor extends ISensor {
  /// Construction
  LightSensor([sampleTime = ISensor.defaultSampleTime]) {
    type = SensorTypes.light;
    value = 0;
    state = SensorState.stopped;
    this.sampleTime = sampleTime;
    // Initialise Mraa
    _mraa.noJsonLoading = true;
    _mraa.initialise();
    _mraa.common.initialise();
    // The light sensor is on AIO 1 on the beaglebone green
    _aioContext = _mraa.aio.initialise(1);
    _lightSensor = sensor.GroveLight(_mraa, _aioContext);
  }

  /// The value generation period timer and its callback
  Timer _timer;

  void _timerCallBack(Timer timer) {
    _generateValue();
    final SensorData data = getSensorData();
    _values.add(data);
  }

  /// Mraa
  mraa.Mraa _mraa = mraa.Mraa.fromLib('beaglebone/libmraa.so.2.0.0');
  ffi.Pointer<mraa.MraaAioContext> _aioContext;

  /// Grove sensors
  sensor.GroveLight _lightSensor;

  /// Initialiser
  void initialise() {}

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
      final sensor.GroveLightValues values = _lightSensor.getValues();
      value = values.lux;
      at = DateTime.now();
    } catch (e) {
      print(Secrets.lightDeviceId + " exception raised getting sensor value");
      print(e);
    }
  }
}
