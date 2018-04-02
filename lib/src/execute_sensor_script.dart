/*
 * Package : iot_home_sensors
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 01/04/2018
 * Copyright :  S.Hamblett
 */

part of iot_home_sensors;

/// A helper class to execute an external script to get a value from
/// a sensor on a board. The output of the script is made available in
/// the output property.
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

  /// The output of the script
  String _output;

  String get output => _output;

  DateTime _lastValueTime;

  DateTime get lastValueTime => _lastValueTime;

  /// Synchronous value update
  void _updateValueSync() {
    final ProcessResult res = Process.runSync(_command, _arguments,
        workingDirectory: _workingDirectory);
    if (res.exitCode != 0) return;
    _setOutput(res.stdout);
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
        _setOutput(res.stdout);
        completer.complete(res);
      }
    });
    return completer.future;
  }

  /// Output setter
  void _setOutput(String value) {
    _output = value;
    _lastValueTime = new DateTime.now();
  }
}
