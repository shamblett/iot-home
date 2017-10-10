/*
 * Package : iot_home_sensors
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 29/09/2017
 * Copyright :  S.Hamblett
 */

part of iot_home_sensors;

/// The interface class to Googles's Iot-Core MQTT bridge
class MqttBridge {

  /// Device Id
  String deviceId;

  /// Construction
  MqttBridge(this.deviceId);

  /// Initialise and connect to the Mqtt bridge
  void initialise() {


  }

  /// Update an integer value
  void update(int value) {

  }
}
