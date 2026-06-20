import '../../models/models.dart';
import '../../core/network/result.dart';

abstract class SocialRepository {
  Future<Result<List<SocialPost>>> getFeed();
  Future<Result<void>> likePost(String postId);
  Future<Result<void>> addComment(String postId, String text);
}
