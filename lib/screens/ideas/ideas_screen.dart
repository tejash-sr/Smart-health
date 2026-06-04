import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/time_utils.dart';
import '../../core/widgets/glass_card.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';

class IdeasScreen extends StatefulWidget {
  const IdeasScreen({super.key});

  @override
  State<IdeasScreen> createState() => _IdeasScreenState();
}

class _IdeasScreenState extends State<IdeasScreen> {
  IdeaStatus? _filter;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final all = app.ideas;
    final filtered =
        _filter == null ? all : all.where((i) => i.status == _filter).toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Ideas'),
        leading: const BackButton(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.ideas,
        onPressed: () => _showShareDialog(context),
        icon: const Icon(Icons.lightbulb_rounded, color: Colors.white),
        label: const Text(
          'Share Idea',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          // Status filter chips
          SizedBox(
            height: 48,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              children: [
                _chip(null, 'All', null),
                _chip(IdeaStatus.proposed, 'Proposed', AppColors.info),
                _chip(IdeaStatus.underReview, 'Under Review', AppColors.warning),
                _chip(IdeaStatus.accepted, 'Accepted', AppColors.success),
                _chip(IdeaStatus.implemented, 'Implemented', AppColors.primary),
                _chip(IdeaStatus.rejected, 'Rejected', AppColors.error),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final idea = filtered[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            AvatarCircle(
                              initials: idea.author.initials,
                              size: 32,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    idea.author.name,
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    '${idea.category} • ${TimeUtils.timeAgo(idea.createdAt)}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark
                                          ? AppColors.textTertiaryDark
                                          : AppColors.textTertiaryLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _statusBadge(idea.status),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          idea.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          idea.description,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.5,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            // Upvote button
                            GestureDetector(
                              onTap: () => app.toggleIdeaUpvote(idea.id),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  gradient: idea.upvoted
                                      ? AppColors.brandGradient
                                      : null,
                                  color: idea.upvoted
                                      ? null
                                      : AppColors.ideas
                                          .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.arrow_upward_rounded,
                                      size: 14,
                                      color: idea.upvoted
                                          ? Colors.white
                                          : AppColors.ideas,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${idea.upvotes}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 12.5,
                                        color: idea.upvoted
                                            ? Colors.white
                                            : AppColors.ideas,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.chat_bubble_outline_rounded,
                              size: 14,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${idea.comments}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                            ),
                            const Spacer(),
                            if (idea.upvotes > 100)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.accent.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('🔥', style: TextStyle(fontSize: 10)),
                                    SizedBox(width: 3),
                                    Text(
                                      'TRENDING',
                                      style: TextStyle(
                                        color: AppColors.accent,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  )
                      .animate(delay: (i * 60).ms)
                      .fadeIn()
                      .slideY(begin: 0.1, end: 0),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(IdeaStatus? s, String label, Color? color) {
    final selected = _filter == s;
    return Padding(
      padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
      child: GestureDetector(
        onTap: () => setState(() => _filter = s),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? (color ?? AppColors.ideas).withValues(alpha: 0.2)
                : Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected
                  ? (color ?? AppColors.ideas)
                  : Colors.white.withValues(alpha: 0.1),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected
                    ? (color ?? AppColors.ideas)
                    : Colors.white.withValues(alpha: 0.7),
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusBadge(IdeaStatus status) {
    final config = switch (status) {
      IdeaStatus.proposed => (label: 'Proposed', color: AppColors.info),
      IdeaStatus.underReview =>
        (label: 'Review', color: AppColors.warning),
      IdeaStatus.accepted => (label: 'Accepted', color: AppColors.success),
      IdeaStatus.implemented =>
        (label: 'Done ✓', color: AppColors.primary),
      IdeaStatus.rejected => (label: 'Declined', color: AppColors.error),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        config.label,
        style: TextStyle(
          color: config.color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  void _showShareDialog(BuildContext c) {
    final title = TextEditingController();
    final body = TextEditingController();
    String category = 'Workplace';
    final cats = ['Workplace', 'Culture', 'Innovation', 'Wellness', 'Other'];
    showModalBottomSheet(
      context: c,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(c).viewInsets.bottom,
        ),
        child: StatefulBuilder(
          builder: (ctx, setSt) => Container(
            decoration: BoxDecoration(
              color: Theme.of(c).cardTheme.color,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
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
                  'Share Your Idea',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: title,
                  decoration: const InputDecoration(hintText: 'Idea title'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: body,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Describe your idea...',
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: cats
                      .map(
                        (k) => GestureDetector(
                          onTap: () => setSt(() => category = k),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: category == k
                                  ? AppColors.ideas
                                  : AppColors.ideas.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              k,
                              style: TextStyle(
                                color: category == k
                                    ? Colors.white
                                    : AppColors.ideas,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.ideas,
                    ),
                    onPressed: () {
                      if (title.text.trim().isEmpty) return;
                      c.read<AppProvider>().addIdea(
                            title.text.trim(),
                            body.text.trim(),
                            category,
                          );
                      Navigator.pop(c);
                    },
                    child: const Text('Submit Idea'),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
