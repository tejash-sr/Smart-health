import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/time_utils.dart';
import '../../core/widgets/glass_card.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';
import '../steps/steps_screen.dart';
import '../water/water_screen.dart';
import '../leaderboard/leaderboard_screen.dart';
import '../events/events_screen.dart';
import '../doubts/doubts_screen.dart';
import '../ideas/ideas_screen.dart';
import '../coffee/coffee_screen.dart';
import '../goals/goals_screen.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final user = app.currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 600));
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
            children: [
              // Header
              Row(
                children: [
                  AvatarCircle(initials: user.initials, size: 48),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _greeting(),
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          user.name.split(' ').first,
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Notification bell
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.06)
                              : Colors.black.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.notifications_none_rounded,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NotificationsScreen(),
                            ),
                          ),
                        ),
                      ),
                      if (app.unreadNotifications > 0)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              app.unreadNotifications.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2),

              const SizedBox(height: 24),

              // Points hero card
              _buildPointsHero(context, app),

              const SizedBox(height: 20),

              // Step + Water row
              Row(
                children: [
                  Expanded(child: _buildStepsCard(context, app)),
                  const SizedBox(width: 14),
                  Expanded(child: _buildWaterCard(context, app)),
                ],
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),

              const SizedBox(height: 24),

              _sectionTitle(context, 'Quick Access'),
              const SizedBox(height: 12),
              _buildQuickAccess(context),

              const SizedBox(height: 28),

              _sectionTitle(
                context,
                'Active Challenges',
                action: 'See all',
                onAction: () {},
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 168,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: app.activeChallenges.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) =>
                      _buildChallengeCard(context, app.activeChallenges[i]),
                ),
              ),

              const SizedBox(height: 28),

              _sectionTitle(context, 'Top Performers This Week'),
              const SizedBox(height: 12),
              _buildLeaderboardPreview(context, app),

              const SizedBox(height: 28),

              _sectionTitle(context, 'Recent Activity'),
              const SizedBox(height: 12),
              _buildRecentActivity(context, app),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning ☀️';
    if (h < 17) return 'Good afternoon ✨';
    return 'Good evening 🌙';
  }

  Widget _sectionTitle(BuildContext c, String t,
      {String? action, VoidCallback? onAction}) {
    final isDark = Theme.of(c).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          t,
          style: TextStyle(
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        if (action != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            child: Text(
              action,
              style: const TextStyle(
                color: AppColors.primaryLight,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPointsHero(BuildContext c, AppProvider app) {
    return GradientCard(
      gradient: AppColors.brandGradient,
      padding: const EdgeInsets.all(22),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            right: 30,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star_rounded,
                            color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'Level 12',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.trending_up_rounded,
                      color: Colors.white, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    '+312 today',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Your Points',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    TimeUtils.formatNumberWithCommas(app.currentUser.totalPoints),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'pts',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // Progress to next level
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: 0.72,
                  minHeight: 6,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '1,180 pts to Level 13',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1, 1),
          duration: 400.ms,
          curve: Curves.easeOutBack,
        );
  }

  Widget _buildStepsCard(BuildContext c, AppProvider app) {
    final isDark = Theme.of(c).brightness == Brightness.dark;
    return GlassCard(
      padding: const EdgeInsets.all(18),
      onTap: () => Navigator.push(
        c,
        MaterialPageRoute(builder: (_) => const StepsScreen()),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppColors.stepsGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.directions_walk_rounded,
                    color: Colors.white, size: 16),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified_rounded,
                        color: AppColors.success, size: 10),
                    const SizedBox(width: 2),
                    Text(
                      '${app.todaySteps.trustScore}%',
                      style: const TextStyle(
                        color: AppColors.success,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            TimeUtils.formatNumberWithCommas(app.todaySteps.steps),
            style: TextStyle(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          Text(
            'steps today',
            style: TextStyle(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (app.todaySteps.steps / 10000).clamp(0.0, 1.0),
              minHeight: 4,
              backgroundColor: AppColors.steps.withValues(alpha: 0.15),
              valueColor: const AlwaysStoppedAnimation(AppColors.steps),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterCard(BuildContext c, AppProvider app) {
    final isDark = Theme.of(c).brightness == Brightness.dark;
    return GlassCard(
      padding: const EdgeInsets.all(18),
      onTap: () => Navigator.push(
        c,
        MaterialPageRoute(builder: (_) => const WaterScreen()),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppColors.waterGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.water_drop_rounded,
                    color: Colors.white, size: 16),
              ),
              const Spacer(),
              Text(
                '${(app.waterProgress * 100).round()}%',
                style: const TextStyle(
                  color: AppColors.water,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                (app.totalWaterMl / 1000).toStringAsFixed(1),
                style: TextStyle(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  'L / 3L',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Text(
            'water today',
            style: TextStyle(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: app.waterProgress,
              minHeight: 4,
              backgroundColor: AppColors.water.withValues(alpha: 0.15),
              valueColor: const AlwaysStoppedAnimation(AppColors.water),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccess(BuildContext c) {
    final items = [
      _QA(Icons.leaderboard_rounded, 'Leaderboard', AppColors.accent,
          const LeaderboardScreen()),
      _QA(Icons.event_rounded, 'Events', AppColors.events,
          const EventsScreen()),
      _QA(Icons.help_outline_rounded, 'Ask', AppColors.doubts,
          const DoubtsScreen()),
      _QA(Icons.lightbulb_outline_rounded, 'Ideas', AppColors.ideas,
          const IdeasScreen()),
      _QA(Icons.coffee_rounded, 'Coffee', AppColors.coffee,
          const CoffeeScreen()),
      _QA(Icons.flag_rounded, 'Goals', AppColors.success,
          const GoalsScreen()),
    ];

    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final item = items[i];
          return GestureDetector(
            onTap: () => Navigator.push(
              c,
              MaterialPageRoute(builder: (_) => item.screen),
            ),
            child: Container(
              width: 84,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              decoration: BoxDecoration(
                color: Theme.of(c).cardTheme.color,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: item.color.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: item.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(item.icon, color: item.color, size: 22),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(c).textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
            ),
          )
              .animate(delay: (50 * i).ms)
              .fadeIn(duration: 400.ms)
              .slideX(begin: 0.2, end: 0);
        },
      ),
    );
  }

  Widget _buildChallengeCard(BuildContext c, Challenge ch) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ch.color.withValues(alpha: 0.85),
            ch.color.withValues(alpha: 0.55),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: ch.color.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(ch.iconEmoji, style: const TextStyle(fontSize: 24)),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '+${ch.pointsReward} pts',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            ch.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                '${(ch.progress * 100).round()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: ch.progress,
                    minHeight: 5,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.people_alt_rounded,
                  color: Colors.white.withValues(alpha: 0.85), size: 13),
              const SizedBox(width: 4),
              Text(
                '${ch.participants} joined',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                '${ch.daysRemaining}d left',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardPreview(BuildContext c, AppProvider app) {
    final isDark = Theme.of(c).brightness == Brightness.dark;
    final users = app.posts.map((p) => p.author).toList();
    final medals = ['🥇', '🥈', '🥉'];

    return GlassCard(
      onTap: () => Navigator.push(
        c,
        MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: List.generate(3, (i) {
          final u = users.length > i ? users[i] : app.currentUser;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Text(medals[i], style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 12),
                AvatarCircle(initials: u.initials, size: 36),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        u.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                      Text(
                        u.department,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  TimeUtils.formatNumberWithCommas(u.totalPoints),
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext c, AppProvider app) {
    final isDark = Theme.of(c).brightness == Brightness.dark;
    final activities = app.pointsHistory.take(3).toList();
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: activities.map((tx) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: (tx.amount > 0 ? AppColors.success : AppColors.error)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(tx.iconEmoji,
                        style: const TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tx.description,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        TimeUtils.timeAgo(tx.timestamp),
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
                Text(
                  '${tx.amount > 0 ? '+' : ''}${tx.amount}',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: tx.amount > 0
                        ? AppColors.success
                        : AppColors.error,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _QA {
  final IconData icon;
  final String label;
  final Color color;
  final Widget screen;
  _QA(this.icon, this.label, this.color, this.screen);
}
