import 'package:http/http.dart' as http;
import '../network/api_client.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/mock_user_repository.dart';
import '../../data/repositories/challenge_repository.dart';
import '../../data/repositories/mock_challenge_repository.dart';
import '../../data/repositories/social_repository.dart';
import '../../data/repositories/mock_social_repository.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  late final ApiClient apiClient;
  
  // Repositories
  late final UserRepository userRepository;
  late final ChallengeRepository challengeRepository;
  late final SocialRepository socialRepository;

  Future<void> init() async {
    // Core
    final httpClient = http.Client();
    apiClient = ApiClient(client: httpClient, baseUrl: 'https://api.pulse.com/v1');

    // Repositories
    // Currently using Mock Repositories for development
    // Once real API is ready, switch to ApiUserRepository(apiClient: apiClient) etc.
    userRepository = MockUserRepository();
    challengeRepository = MockChallengeRepository();
    socialRepository = MockSocialRepository();
  }
}

final sl = ServiceLocator();
