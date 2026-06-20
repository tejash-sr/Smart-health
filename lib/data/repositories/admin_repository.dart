import '../../core/network/result.dart';
import '../../models/models.dart';

/// Aggregated analytics snapshot powering the V7 admin dashboard.
class AdminAnalytics {
  const AdminAnalytics({
    required this.totalEmployees,
    required this.activeToday,
    required this.totalSteps,
    required this.totalPointsAwarded,
    required this.challengesRunning,
    required this.postsThisWeek,
    required this.averageTrustScore,
    required this.topDepartments,
  });

  final int totalEmployees;
  final int activeToday;
  final int totalSteps;
  final int totalPointsAwarded;
  final int challengesRunning;
  final int postsThisWeek;
  final double averageTrustScore;
  final List<DepartmentStat> topDepartments;
}

/// Per-department engagement breakdown used in the dashboard table.
class DepartmentStat {
  const DepartmentStat({
    required this.department,
    required this.members,
    required this.totalPoints,
    required this.activePercent,
  });

  final String department;
  final int members;
  final int totalPoints;
  final double activePercent;
}

/// V7 — Admin / management surface.
///
/// Backs the admin dashboard (analytics, challenge management, reward
/// inventory). All operations return [Result] so the UI layer can render
/// loading / success / error states uniformly with the rest of the app.
abstract class AdminRepository {
  Future<Result<AdminAnalytics>> getAnalytics();
  Future<Result<List<Challenge>>> getAllChallenges();
  Future<Result<Challenge>> createChallenge(Challenge challenge);
  Future<Result<void>> deleteChallenge(String challengeId);
  Future<Result<List<Reward>>> getAllRewards();
  Future<Result<Reward>> createReward(Reward reward);
  Future<Result<void>> updateRewardStock(String rewardId, int delta);
}
