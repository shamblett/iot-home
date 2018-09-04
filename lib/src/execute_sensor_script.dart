/*
 * Package : iot_home_sensors
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 01/04/2018
 * Copyright :  S.Hamblett
 */

part of iot_home_sensors;

/// A helper class to execute an external script to get a value from
/// a sensor. The output of the script is made available in
/// the output property.
class ExecuteSensorScript {
  ExecuteSensorScript(this.command, this.workingDirectory, this.arguments);

  String command;

  List<String> arguments;

  String workingDirectory;

  /// The output of the script
  String _output;

  String get output => _output;

  DateTime _lastValueTime;

  DateTime get lastValueTime => _lastValueTime;

  /// Synchronous value update
  void updateValueSync() {
    final ProcessResult res =
    Process.runSync(command, arguments, workingDirectory: workingDirectory);
    if (res.exitCode != 0) return;
    _setOutput(res.stdout);
  }

  /// Asynchronous value update.
  Future<ProcessResult> updateValueAsync() async {
    final Completer<ProcessResult> completer = new Completer<ProcessResult>();
    Process.run(command, arguments, workingDirectory: workingDirectory)
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
