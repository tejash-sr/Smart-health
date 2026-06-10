import '../../core/network/result.dart';
import '../../core/error/exceptions.dart';
import '../../models/models.dart';
import '../../services/mock_data.dart';
import 'user_repository.dart';

class MockUserRepository implements UserRepository {
  @override
  Future<Result<User>> getCurrentUser() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      return Success(MockData.currentUser);
    } catch (e) {
      return Failure(
        exception: ServerException(message: 'Failed to fetch user: $e'),
        message: 'Failed to fetch user',
      );
    }
  }

  @override
  Future<Result<User>> login(String email, String password) async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      if (email == 'user@pulse.com' && password == 'password') {
        return Success(MockData.currentUser);
      } else {
        throw UnauthorizedException(message: 'Invalid credentials');
      }
    } on UnauthorizedException catch (e) {
      return Failure(exception: e, message: e.message);
    } catch (e) {
      return Failure(
        exception: ServerException(message: e.toString()),
        message: 'Login failed',
      );
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return const Success(null);
    } catch (e) {
      return Failure(
        exception: CacheException(message: e.toString()),
        message: 'Logout failed',
      );
    }
  }

  @override
  Future<Result<List<PointsTransaction>>> getPointsHistory(String userId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return Success(MockData.pointsHistory);
    } catch (e) {
      return Failure(
        exception: ServerException(message: e.toString()),
        message: 'Failed to fetch points history',
      );
    }
  }
}
