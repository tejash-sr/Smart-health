import '../../core/network/result.dart';
import '../../core/error/exceptions.dart';
import '../../models/models.dart';
import '../../services/mock_data.dart';
import 'social_repository.dart';

class MockSocialRepository implements SocialRepository {
  @override
  Future<Result<List<SocialPost>>> getFeed() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return Success(MockData.getSocialPosts());
    } catch (e) {
      return Failure(
        exception: ServerException(message: e.toString()),
        message: 'Could not load social feed',
      );
    }
  }

  @override
  Future<Result<void>> likePost(String postId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      return const Success(null);
    } catch (e) {
      return Failure(
        exception: ServerException(message: e.toString()),
        message: 'Could not like post',
      );
    }
  }

  @override
  Future<Result<void>> addComment(String postId, String text) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return const Success(null);
    } catch (e) {
      return Failure(
        exception: ServerException(message: e.toString()),
        message: 'Could not add comment',
      );
    }
  }
}
