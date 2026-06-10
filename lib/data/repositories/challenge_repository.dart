import '../../models/models.dart';
import '../../core/network/result.dart';

abstract class ChallengeRepository {
  Future<Result<List<Challenge>>> getChallenges();
  Future<Result<void>> joinChallenge(String challengeId);
  Future<Result<void>> updateChallengeProgress(String challengeId, double progress);
}
