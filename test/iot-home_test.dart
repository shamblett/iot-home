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
      expect(exe.sudo, false);
      expect(exe.workingDirectory, "test");
    });

    test("Sudo constructor", () {
      final ExecuteSensorScript exe =
      new ExecuteSensorScript.withSudo("echo", "test", ["hello"]);
      expect(exe.command, "sudo echo");
      expect(exe.arguments[0], "hello");
      expect(exe.sudo, true);
      expect(exe.workingDirectory, "test");
    });

    test("Execute sync", () {
      final ExecuteSensorScript exe = new ExecuteSensorScript(
          "echo", "test", ["hello"]);
      expect(exe.command, "echo");
      expect(exe.arguments, ["hello"]);
      expect(exe.sudo, false);
      expect(exe.workingDirectory, "test");
      exe.updateValueSync();
      expect(exe.output, "hello\n");
      expect(exe.lastValueTime, isNotNull);
    });

    test("Execute async", () async {
      final ExecuteSensorScript exe = new ExecuteSensorScript(
          "echo", "test", ["hello"]);
      expect(exe.command, "echo");
      expect(exe.arguments, ["hello"]);
      expect(exe.sudo, false);
      expect(exe.workingDirectory, "test");
      await exe.updateValueAsync();
      expect(exe.output, "hello\n");
      expect(exe.lastValueTime, isNotNull);
    });
  });
}
