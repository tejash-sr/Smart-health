import '../../models/models.dart';
import '../../core/network/result.dart';

abstract class UserRepository {
  Future<Result<User>> getCurrentUser();
  Future<Result<User>> login(String email, String password);
  Future<Result<void>> logout();
  Future<Result<List<PointsTransaction>>> getPointsHistory(String userId);
}
