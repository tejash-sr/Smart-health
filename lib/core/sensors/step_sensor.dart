import 'dart:async';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class StepSensorService {
  StreamSubscription<StepCount>? _stepCountStream;
  StreamSubscription<PedestrianStatus>? _pedestrianStatusStream;

  int _steps = 0;
  String _status = 'Unknown';

  int get currentSteps => _steps;
  String get pedestrianStatus => _status;

  final StreamController<int> _stepController = StreamController<int>.broadcast();
  Stream<int> get stepStream => _stepController.stream;

  Future<bool> checkPermission() async {
    if (await Permission.activityRecognition.request().isGranted) {
      return true;
    }
    return false;
  }

  Future<void> initPlatformState() async {
    bool granted = await checkPermission();
    if (!granted) return;

    _pedestrianStatusStream = Pedometer.pedestrianStatusStream.listen(
      _onPedestrianStatusChanged,
      onError: _onPedestrianStatusError,
    );

    _stepCountStream = Pedometer.stepCountStream.listen(
      _onStepCount,
      onError: _onStepCountError,
    );
  }

  void _onStepCount(StepCount event) {
    _steps = event.steps;
    _stepController.add(_steps);
  }

  void _onPedestrianStatusChanged(PedestrianStatus event) {
    _status = event.status;
  }

  void _onPedestrianStatusError(error) {
    _status = 'Pedestrian Status not available';
  }

  void _onStepCountError(error) {
    _steps = 0;
    _stepController.addError(error);
  }

  void dispose() {
    _stepCountStream?.cancel();
    _pedestrianStatusStream?.cancel();
    _stepController.close();
  }
}
