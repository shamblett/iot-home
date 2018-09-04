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

  /// The MQTT client
  mqtt.MqttClient client;

  /// The Iot-Core server and port, we use 443
  final String server = 'mqtt.googleapis.com';
  final int port = 443;

  /// Logging
  bool logging = false;

  /// Password- encoded and signed JWYT
  String password;

  /// Are we initialised
  bool initialised = false;

  /// Construction
  MqttBridge(this.deviceId);

  /// Initialise and connect to the Mqtt bridge
  void initialise() {
    // Initialize the token signers, in our case just RS256
    final String sensorPkFilename = deviceId + "-pk.key";
    final String pkPath =
    path.join(path.current, "lib", "src", "secret", sensorPkFilename);
    final File pkFile = new File(pkPath);
    final String pk = pkFile.readAsStringSync();
    getJWT(pk).then((String enc) {
      password = enc;
      client = new mqtt.MqttClient(server, getClientId());
      client.port = port;
      client.secure = true;
      final String username = "unused";
      client.setProtocolV311();
      client.logging(logging);
      client.connect(username, password).then((dynamic f) {
        if (client.connectionState != mqtt.ConnectionState.connected) {
          print(
              "ERROR - the MQTT bridge is not connected - try again with logging on");
        }
        initialised = true;
      });
    });
  }

  /// Update an integer value
  void update(SensorData data) {
    final typed.Uint8Buffer buff = _sensorDataBuffer(data);
    client.publishMessage(getTelemetryTopic(), mqtt.MqttQos.atMostOnce, buff);
  }

  /// Get the client id for the sensor
  String getClientId() {
    return "projects/" +
        Secrets.projectId +
        "/locations/" +
        Secrets.region +
        "/registries/" +
        Secrets.registry +
        "/devices/" +
        deviceId;
  }

  /// Get the telemetry topic
  String getTelemetryTopic() {
    return "/devices/" + deviceId + "/events";
  }

  /// Get the JWT token
  Future<String> getJWT(String pk) async {
    final int iat =
    ((new DateTime.now().millisecondsSinceEpoch) / 1000).round();
    final int exp = ((new DateTime.now()
        .add(new Duration(hours: 24))
        .millisecondsSinceEpoch) /
        1000)
        .round();
    final claimSet = new jwt.JwtClaim(
        audience: <String>[Secrets.projectId],
        payload: {'iat': iat, 'exp': exp});
    return jwt.issueJwtHS256(claimSet, pk);
  }

  typed.Uint8Buffer _sensorDataBuffer(SensorData data) {
    return new typed.Uint8Buffer()
      ..addAll(data
          .toString()
          .codeUnits
          .toList());
  }
}
