import '../../core/error/exceptions.dart';
import '../../core/network/result.dart';
import '../../models/models.dart';
import '../../services/mock_data.dart';
import 'admin_repository.dart';

/// In-memory [AdminRepository] used until the V5 backend admin endpoints
/// are live. Backed by [MockData] and a mutable cache of challenges /
/// rewards so the dashboard can simulate create / delete / stock-edit
/// flows during demos.
class MockAdminRepository implements AdminRepository {
  MockAdminRepository()
      : _challenges = List<Challenge>.from(MockData.getChallenges()),
        _rewards = List<Reward>.from(MockData.getRewards());

  final List<Challenge> _challenges;
  final List<Reward> _rewards;

  @override
  Future<Result<AdminAnalytics>> getAnalytics() async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 350));

      final users = MockData.users;
      final posts = MockData.getSocialPosts();
      final running = _challenges
          .where((c) => c.status == ChallengeStatus.active)
          .length;

      final byDepartment = <String, List<User>>{};
      for (final u in users) {
        byDepartment.putIfAbsent(u.team, () => <User>[]).add(u);
      }
      final departmentStats = byDepartment.entries
          .map(
            (e) => DepartmentStat(
              department: e.key,
              members: e.value.length,
              totalPoints:
                  e.value.fold<int>(0, (sum, u) => sum + u.totalPoints),
              activePercent: 65 + (e.key.length * 3) % 30,
            ),
          )
          .toList()
        ..sort((a, b) => b.totalPoints.compareTo(a.totalPoints));

      final avgTrust = users.isEmpty
          ? 0.0
          : users.map((u) => u.trustScore).reduce((a, b) => a + b) /
              users.length;

      return Success(
        AdminAnalytics(
          totalEmployees: users.length,
          activeToday: (users.length * 0.78).round(),
          totalSteps: users.length * 8420,
          totalPointsAwarded:
              users.fold<int>(0, (sum, u) => sum + u.totalPoints),
          challengesRunning: running,
          postsThisWeek: posts.length,
          averageTrustScore: avgTrust,
          topDepartments: departmentStats.take(5).toList(),
        ),
      );
    } catch (e) {
      return Failure(
        exception: ServerException(message: e.toString()),
        message: 'Failed to load analytics',
      );
    }
  }

  @override
  Future<Result<List<Challenge>>> getAllChallenges() async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      return Success(List<Challenge>.unmodifiable(_challenges));
    } catch (e) {
      return Failure(
        exception: ServerException(message: e.toString()),
        message: 'Failed to load challenges',
      );
    }
  }

  @override
  Future<Result<Challenge>> createChallenge(Challenge challenge) async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      _challenges.insert(0, challenge);
      return Success(challenge);
    } catch (e) {
      return Failure(
        exception: ServerException(message: e.toString()),
        message: 'Failed to create challenge',
      );
    }
  }

  @override
  Future<Result<void>> deleteChallenge(String challengeId) async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      _challenges.removeWhere((c) => c.id == challengeId);
      return const Success(null);
    } catch (e) {
      return Failure(
        exception: ServerException(message: e.toString()),
        message: 'Failed to delete challenge',
      );
    }
  }

  @override
  Future<Result<List<Reward>>> getAllRewards() async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      return Success(List<Reward>.unmodifiable(_rewards));
    } catch (e) {
      return Failure(
        exception: ServerException(message: e.toString()),
        message: 'Failed to load rewards',
      );
    }
  }

  @override
  Future<Result<Reward>> createReward(Reward reward) async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      _rewards.insert(0, reward);
      return Success(reward);
    } catch (e) {
      return Failure(
        exception: ServerException(message: e.toString()),
        message: 'Failed to create reward',
      );
    }
  }

  @override
  Future<Result<void>> updateRewardStock(String rewardId, int delta) async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      final idx = _rewards.indexWhere((r) => r.id == rewardId);
      if (idx == -1) {
        return Failure(
          exception: ServerException(message: 'Reward not found'),
          message: 'Reward not found',
        );
      }
      final existing = _rewards[idx];
      _rewards[idx] = Reward(
        id: existing.id,
        title: existing.title,
        description: existing.description,
        iconEmoji: existing.iconEmoji,
        category: existing.category,
        pointsCost: existing.pointsCost,
        valueInRupees: existing.valueInRupees,
        stock: (existing.stock + delta).clamp(0, 1 << 31).toInt(),
        isPopular: existing.isPopular,
        color: existing.color,
      );
      return const Success(null);
    } catch (e) {
      return Failure(
        exception: ServerException(message: e.toString()),
        message: 'Failed to update reward stock',
      );
    }
  }
}
