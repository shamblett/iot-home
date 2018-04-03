/*
 * Package : iot_home_sensors
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 01/04/2018
 * Copyright :  S.Hamblett
 */

import 'package:iot_home/iot_home_sensors.dart';
import 'package:test/test.dart';

void main() {
  group("Script Commands", () {
    test("Default constructor", () {
      final ExecuteSensorScript exe =
      new ExecuteSensorScript("echo", "test", ["hello"]);
      expect(exe.command, "echo");
      expect(exe.arguments[0], "hello");
      expect(exe.workingDirectory, "test");
    });

    test("Execute sync", () {
      final ExecuteSensorScript exe =
      new ExecuteSensorScript("echo", "test", ["hello"]);
      expect(exe.command, "echo");
      expect(exe.arguments, ["hello"]);
      expect(exe.workingDirectory, "test");
      exe.updateValueSync();
      expect(exe.output, "hello\n");
      expect(exe.lastValueTime, isNotNull);
    });

    test("Execute async", () async {
      final ExecuteSensorScript exe =
      new ExecuteSensorScript("echo", "test", ["hello"]);
      expect(exe.command, "echo");
      expect(exe.arguments, ["hello"]);
      expect(exe.workingDirectory, "test");
      await exe.updateValueAsync();
      expect(exe.output, "hello\n");
      expect(exe.lastValueTime, isNotNull);
    });

    test("Execute script", () {
      final ExecuteSensorScript exe = new ExecuteSensorScript(
          "/home/steve/Development/google/dart/projects/iot-home/test/sensorscripts/dummy-sensor.sh",
          "/home/steve/Development/google/dart/projects/iot-home/test/sensorscripts/",
          []);
      expect(exe.command,
          "/home/steve/Development/google/dart/projects/iot-home/test/sensorscripts/dummy-sensor.sh");
      expect(exe.arguments, []);
      expect(exe.workingDirectory,
          "/home/steve/Development/google/dart/projects/iot-home/test/sensorscripts/");
      exe.updateValueSync();
      expect(exe.output, "Hello from Dummy sensor\n");
      expect(exe.lastValueTime, isNotNull);
    });
  });

}
