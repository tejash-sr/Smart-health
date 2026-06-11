import '../../core/network/result.dart';
import '../../core/error/exceptions.dart';
import '../../models/models.dart';
import '../../services/mock_data.dart';
import 'challenge_repository.dart';

class MockChallengeRepository implements ChallengeRepository {
  @override
  Future<Result<List<Challenge>>> getChallenges() async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      return Success(MockData.getChallenges());
    } catch (e) {
      return Failure(
        exception: ServerException(message: e.toString()),
        message: 'Failed to fully load challenges',
      );
    }
  }

  @override
  Future<Result<void>> joinChallenge(String challengeId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      // Normally would update real backend here
      return const Success(null);
    } catch (e) {
      return Failure(
        exception: ServerException(message: 'Failed: $e'),
        message: 'Could not join challenge',
      );
    }
  }

  @override
  Future<Result<void>> updateChallengeProgress(String challengeId, double progress) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return const Success(null);
    } catch (e) {
      return Failure(
        exception: ServerException(message: 'Failed: $e'),
        message: 'Could not update progress',
      );
    }
  }
}
