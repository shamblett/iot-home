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
/// The update is performed synchronously unless the async flag is set;
class ExecuteSensorScript {
  ExecuteSensorScript(this._command, this._workingDirectory, this._arguments,
      [this._async]);

  ExecuteSensorScript.withSudo(this._command, this._workingDirectory,
      this._arguments,
      [this._async]) {
    _sudo = true;
    _command = "sudo " + _command;
  }

  String _command;

  List<String> _arguments;

  String _workingDirectory;

  bool _async = false;

  /// Only useful on nix platforms
  bool _sudo = false;

  bool get sudo => _sudo;

  int _intValue;

  int get valueAsInt => _intValue;

  double _doubleValue;

  double get valueAsDouble => _doubleValue;

  DateTime _lastValueTime;

  DateTime get lastValueTime => _lastValueTime;

  /// Synchronous value update
  void _updateValueSync() {
    final ProcessResult res = Process.runSync(_command, _arguments,
        workingDirectory: _workingDirectory);
    if (res.exitCode != 0) return;
    _setValues(res.stdout);
  }

  /// Updates to the latest value
  Future updateValue() async {
    if (_async) {
      await _updateValueAsync();
    } else {
      _updateValueSync();
    }
  }

  /// Asynchronous value update
  Future<ProcessResult> _updateValueAsync() async {
    Completer completer;
    Process
        .run(_command, _arguments, workingDirectory: _workingDirectory)
        .then((ProcessResult res) {
      if (res.exitCode != 0) {
        completer.complete(null);
      } else {
        _setValues(res.stdout);
        completer.complete(res);
      }
    });
    return completer.future;
  }

  /// Value setter
  void _setValues(String value) {
    _doubleValue = double.parse(value);
    _intValue = _doubleValue.toInt();
    _lastValueTime = new DateTime.now();
  }
}
