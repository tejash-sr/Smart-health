import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/time_utils.dart';
import '../../core/widgets/glass_card.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90),
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColors.brandGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: _showCreatePost,
            child: const Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                children: [
                  ShaderMask(
                    shaderCallback: (b) =>
                        AppColors.successGradient.createShader(b),
                    child: const Text(
                      'Community',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.social.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.groups_rounded,
                        color: AppColors.social),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                children: [
                  // Composer
                  GestureDetector(
                    onTap: _showCreatePost,
                    child: GlassCard(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          AvatarCircle(
                              initials: app.currentUser.initials, size: 38),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Share something with your team...',
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.textTertiaryDark
                                    : AppColors.textTertiaryLight,
                                fontSize: 13.5,
                              ),
                            ),
                          ),
                          Icon(Icons.image_outlined,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Posts
                  ...app.posts.asMap().entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _postCard(entry.value)
                          .animate(delay: (entry.key * 60).ms)
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: 0.05, end: 0),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _postCard(SocialPost post) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final app = context.read<AppProvider>();

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              AvatarCircle(initials: post.author.initials, size: 42),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            post.author.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        _typeBadge(post.type),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${post.author.department} • ${TimeUtils.timeAgo(post.createdAt)}',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark
                            ? AppColors.textTertiaryDark
                            : AppColors.textTertiaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.more_horiz_rounded,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight),
            ],
          ),
          const SizedBox(height: 14),

          // Recognition badge
          if (post.recognizedUser != null)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.accent.withValues(alpha: 0.18),
                    AppColors.secondary.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.accent.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  const Text('🙌', style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Shoutout to ${post.recognizedUser!.name}',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  AvatarCircle(
                      initials: post.recognizedUser!.initials, size: 28),
                ],
              ),
            ),

          // Content
          Text(
            post.content,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),

          if (post.badgeEmoji != null) ...[
            const SizedBox(height: 12),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                gradient: AppColors.brandGradient,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(post.badgeEmoji!,
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  const Text(
                    'Achievement Unlocked',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 14),
          const Divider(),
          const SizedBox(height: 8),

          // Actions
          Row(
            children: [
              _actionBtn(
                icon: post.liked
                    ? Icons.favorite_rounded
                    : Icons.favorite_outline_rounded,
                count: post.likes,
                color: post.liked ? AppColors.error : null,
                onTap: () => app.toggleLike(post.id),
              ),
              const SizedBox(width: 18),
              _actionBtn(
                icon: Icons.chat_bubble_outline_rounded,
                count: post.comments,
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  Icons.share_outlined,
                  size: 18,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Share functionality coming soon!')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _typeBadge(PostType type) {
    final config = switch (type) {
      PostType.achievement => (label: '🏆', color: AppColors.accent),
      PostType.recognition => (label: '⭐', color: AppColors.secondary),
      PostType.milestone => (label: '✨', color: AppColors.primary),
      PostType.image => (label: '📸', color: AppColors.water),
      _ => (label: '', color: AppColors.success),
    };
    if (config.label.isEmpty) return const SizedBox.shrink();
    return Text(config.label, style: const TextStyle(fontSize: 12));
  }

  Widget _actionBtn({
    required IconData icon,
    int? count,
    Color? color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon,
              size: 19, color: color ?? Colors.white.withValues(alpha: 0.7)),
          if (count != null) ...[
            const SizedBox(width: 5),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color ?? Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showCreatePost() {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'New Post',
                style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: controller,
                maxLines: 4,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'What\'s on your mind?',
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.text.trim().isNotEmpty) {
                      context.read<AppProvider>().addPost(controller.text);
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Share',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
