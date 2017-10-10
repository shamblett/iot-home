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

  /// Get the client id for the sensor
  String getClientId(String sensorId) {
    return "projects/" + Secrets.projectId + "/locations/" +
        Secrets.region + "/registries/" + Secrets.registry + "/devices/" +
        deviceId;
  }

  /// Get the telemetry topic
  String getTelemetryTopic(String sensorId) {
    return "/devices/" + deviceId + "/events";
  }

  /// Get the JWT token
  String getJWT() {

  }
}
