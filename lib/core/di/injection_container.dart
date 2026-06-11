import 'package:http/http.dart' as http;

import '../../data/repositories/admin_repository.dart';
import '../../data/repositories/challenge_repository.dart';
import '../../data/repositories/mock_admin_repository.dart';
import '../../data/repositories/mock_challenge_repository.dart';
import '../../data/repositories/mock_social_repository.dart';
import '../../data/repositories/mock_user_repository.dart';
import '../../data/repositories/social_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../network/api_client.dart';
import '../sensors/step_sensor.dart';
import '../storage/local_storage.dart';

/// Compile-time switch between mock (in-memory) and live API repositories.
///
/// Mock implementations let the app run end-to-end without a backend, which
/// is exactly what we ship in v1.x. Once V5 backend services are deployed,
/// flip this to `false` (or wire it to a dart-define / env flag) and the
/// app will resolve real API-backed repositories from [ServiceLocator].
const bool kUseMockRepositories = true;

/// Default base URL for the V5 Spring Boot backend. Override at build time
/// with `--dart-define=PULSE_API_BASE_URL=https://api.example.com/v1`.
const String _defaultApiBaseUrl =
    String.fromEnvironment('PULSE_API_BASE_URL',
        defaultValue: 'https://api.pulseengage.com/v1');

/// Application-wide service locator.
///
/// Holds singletons for cross-cutting infrastructure (HTTP client, local
/// storage, sensors) and for every data-access repository. All singletons
/// are initialised in [init] which must be awaited before [runApp].
///
/// Accessed everywhere via the top-level [sl] reference.
class ServiceLocator {
  ServiceLocator._internal();
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;

  // Infrastructure ---------------------------------------------------------
  late final ApiClient apiClient;
  late final LocalStorage localStorage;
  late final StepSensorService stepSensor;

  // Repositories -----------------------------------------------------------
  late final UserRepository userRepository;
  late final ChallengeRepository challengeRepository;
  late final SocialRepository socialRepository;
  late final AdminRepository adminRepository;

  bool _initialised = false;

  Future<void> init() async {
    if (_initialised) return;

    // Infrastructure
    localStorage = await LocalStorage.init();
    apiClient = ApiClient(
      client: http.Client(),
      baseUrl: _defaultApiBaseUrl,
    );
    stepSensor = StepSensorService();

    // Repositories
    if (kUseMockRepositories) {
      userRepository = MockUserRepository();
      challengeRepository = MockChallengeRepository();
      socialRepository = MockSocialRepository();
      adminRepository = MockAdminRepository();
    } else {
      // V5 wiring point: replace these with ApiUserRepository(apiClient),
      // ApiChallengeRepository(apiClient), etc. once the Spring Boot
      // endpoints are live.
      userRepository = MockUserRepository();
      challengeRepository = MockChallengeRepository();
      socialRepository = MockSocialRepository();
      adminRepository = MockAdminRepository();
    }

    _initialised = true;
  }

  /// Releases held resources. Currently only used from tests and from
  /// platform lifecycle hooks (e.g. iOS terminate).
  Future<void> dispose() async {
    apiClient.close();
    await stepSensor.dispose();
    _initialised = false;
  }
}

/// Convenience top-level handle. Identical to `ServiceLocator()`.
final ServiceLocator sl = ServiceLocator();
