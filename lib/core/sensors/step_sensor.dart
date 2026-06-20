import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

/// Pedometer-based step sensor for the Pulse Engage hardware-integration
/// layer (V6).
///
/// On Android the service requests the `ACTIVITY_RECOGNITION` runtime
/// permission and subscribes to:
///   - `Pedometer.stepCountStream` (cumulative steps since boot)
///   - `Pedometer.pedestrianStatusStream` (walking / stopped / unknown)
///
/// On web and any other unsupported platform the service is a no-op:
///   - [isSupported] returns `false`
///   - [initPlatformState] returns immediately
///   - [stepStream] never emits
///
/// Callers should always check [isSupported] before relying on sensor data
/// and fall back to mock / manual step entry on web and (today) iOS.
class StepSensorService {
  StepSensorService();

  StreamSubscription<StepCount>? _stepCountSub;
  StreamSubscription<PedestrianStatus>? _pedestrianStatusSub;

  int _steps = 0;
  String _status = 'unknown';

  final StreamController<int> _stepController =
      StreamController<int>.broadcast();

  /// Current cumulative step count since the device booted.
  int get currentSteps => _steps;

  /// Last reported pedestrian status. One of: `walking`, `stopped`,
  /// `unknown`.
  String get pedestrianStatus => _status;

  /// Broadcast stream of step counts. Emits whenever the OS pushes a new
  /// reading from the hardware step counter.
  Stream<int> get stepStream => _stepController.stream;

  /// Whether the current platform exposes a hardware step sensor that
  /// this service can read from. Currently Android only.
  bool get isSupported => !kIsWeb && Platform.isAndroid;

  /// Requests the runtime permission required to read the activity
  /// recognition sensor. Returns `true` if the permission was granted
  /// (and we are on a supported platform).
  Future<bool> checkPermission() async {
    if (!isSupported) return false;
    final status = await Permission.activityRecognition.request();
    return status.isGranted;
  }

  /// Initialises the hardware streams. Safe to call on every platform:
  /// on web / iOS it returns immediately and does nothing.
  Future<void> initPlatformState() async {
    if (!isSupported) return;

    final granted = await checkPermission();
    if (!granted) return;

    _pedestrianStatusSub = Pedometer.pedestrianStatusStream.listen(
      _onPedestrianStatusChanged,
      onError: _onPedestrianStatusError,
      cancelOnError: false,
    );

    _stepCountSub = Pedometer.stepCountStream.listen(
      _onStepCount,
      onError: _onStepCountError,
      cancelOnError: false,
    );
  }

  void _onStepCount(StepCount event) {
    _steps = event.steps;
    _stepController.add(_steps);
  }

  void _onPedestrianStatusChanged(PedestrianStatus event) {
    _status = event.status;
  }

  void _onPedestrianStatusError(Object error) {
    _status = 'unknown';
  }

  void _onStepCountError(Object error) {
    _stepController.addError(error);
  }

  Future<void> dispose() async {
    await _stepCountSub?.cancel();
    await _pedestrianStatusSub?.cancel();
    await _stepController.close();
  }
}
