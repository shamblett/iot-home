/*
 * Package : iot_home_sensors
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 01/04/2018
 * Copyright :  S.Hamblett
 */

part of iot_home_sensors;

/// A helper class to execute an external script to get a value from
/// a sensor on a board. The command should return a single value in
/// stdout as a string, the value can be in integer or float format.
class ExecuteSensorScript {
  ExecuteSensorScript(this._command, this._workingDirectory, this._arguments);

  ExecuteSensorScript.withSudo(
      this._command, this._workingDirectory, this._arguments) {
    _sudo = true;
  }

  String _command;

  List<String> _arguments;

  String _workingDirectory;

  /// Only useful on nix platforms
  bool _sudo = false;

  int _intValue;

  int get valueAsInt => _intValue;

  double _doubleValue;

  double get valueAsDouble => _doubleValue;

  DateTime _lastValueTime;

  DateTime get lastValueTime => _lastValueTime;

  /// Synchronous value update
  void updateValueSync() {}

  /// Asynchronous value update
  Future updateValue() async {}
}
