import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/di/injection_container.dart';
import '../../core/network/result.dart';
import '../../core/theme/app_colors.dart';
import '../../data/repositories/admin_repository.dart';
import '../../models/models.dart';

/// V7 — Admin / management dashboard.
///
/// Visible only to users whose [User.role] is [UserRole.admin] or
/// [UserRole.superAdmin]. Surfaces the analytics, challenge management and
/// reward inventory exposed by [AdminRepository].
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  AdminAnalytics? _analytics;
  List<Challenge> _challenges = const <Challenge>[];
  List<Reward> _rewards = const <Reward>[];

  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _refresh());
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final results = await Future.wait<Object>([
      sl.adminRepository.getAnalytics(),
      sl.adminRepository.getAllChallenges(),
      sl.adminRepository.getAllRewards(),
    ]);

    final analyticsRes = results[0] as Result<AdminAnalytics>;
    final challengesRes = results[1] as Result<List<Challenge>>;
    final rewardsRes = results[2] as Result<List<Reward>>;

    if (!mounted) return;

    setState(() {
      _loading = false;
      if (analyticsRes is Success<AdminAnalytics>) {
        _analytics = analyticsRes.data;
      } else if (analyticsRes is Failure<AdminAnalytics>) {
        _error = analyticsRes.message;
      }
      if (challengesRes is Success<List<Challenge>>) {
        _challenges = challengesRes.data;
      }
      if (rewardsRes is Success<List<Reward>>) {
        _rewards = rewardsRes.data;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Console'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loading ? null : _refresh,
            tooltip: 'Refresh',
          ),
        ],
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(icon: Icon(Icons.analytics_rounded), text: 'Overview'),
            Tab(icon: Icon(Icons.emoji_events_rounded), text: 'Challenges'),
            Tab(icon: Icon(Icons.card_giftcard_rounded), text: 'Rewards'),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _ErrorState(message: _error!, onRetry: _refresh)
              : TabBarView(
                  controller: _tabs,
                  children: [
                    _OverviewTab(analytics: _analytics),
                    _ChallengesTab(
                      challenges: _challenges,
                      onDelete: _onDeleteChallenge,
                    ),
                    _RewardsTab(
                      rewards: _rewards,
                      onAdjustStock: _onAdjustStock,
                    ),
                  ],
                ),
      floatingActionButton: _tabs.index == 1
          ? FloatingActionButton.extended(
              onPressed: _onCreateChallengePlaceholder,
              icon: const Icon(Icons.add_rounded),
              label: const Text('New challenge'),
              backgroundColor: theme.colorScheme.primary,
            )
          : null,
    );
  }

  Future<void> _onDeleteChallenge(Challenge c) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete challenge?'),
        content: Text(
          'This will remove "${c.title}" from the active list. '
          'Participants will keep any points already awarded.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final res = await sl.adminRepository.deleteChallenge(c.id);
    if (!mounted) return;
    if (res is Success<void>) {
      setState(() => _challenges =
          _challenges.where((x) => x.id != c.id).toList(growable: false));
      _snack('Challenge deleted');
    } else if (res is Failure<void>) {
      _snack(res.message, isError: true);
    }
  }

  Future<void> _onAdjustStock(Reward r, int delta) async {
    final res = await sl.adminRepository.updateRewardStock(r.id, delta);
    if (!mounted) return;
    if (res is Success<void>) {
      await _refresh();
    } else if (res is Failure<void>) {
      _snack(res.message, isError: true);
    }
  }

  void _onCreateChallengePlaceholder() {
    _snack(
      'Create challenge wired to AdminRepository — POST /api/admin/challenges will '
      'be enabled once the backend goes live.',
    );
  }

  void _snack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : null,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// ─── Overview ────────────────────────────────────────────────────────────────

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.analytics});

  final AdminAnalytics? analytics;

  @override
  Widget build(BuildContext context) {
    final a = analytics;
    if (a == null) {
      return const Center(child: Text('No analytics available'));
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        const _SectionTitle('Engagement at a glance'),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.45,
          children: [
            _MetricCard(
              icon: Icons.group_rounded,
              label: 'Employees',
              value: '${a.totalEmployees}',
              accent: AppColors.primary,
            ),
            _MetricCard(
              icon: Icons.bolt_rounded,
              label: 'Active today',
              value: '${a.activeToday}',
              accent: AppColors.success,
            ),
            _MetricCard(
              icon: Icons.directions_walk_rounded,
              label: 'Steps logged',
              value: _compact(a.totalSteps),
              accent: AppColors.steps,
            ),
            _MetricCard(
              icon: Icons.stars_rounded,
              label: 'Points awarded',
              value: _compact(a.totalPointsAwarded),
              accent: AppColors.accent,
            ),
            _MetricCard(
              icon: Icons.emoji_events_rounded,
              label: 'Challenges running',
              value: '${a.challengesRunning}',
              accent: AppColors.challenges,
            ),
            _MetricCard(
              icon: Icons.verified_user_rounded,
              label: 'Avg. trust score',
              value: a.averageTrustScore.toStringAsFixed(1),
              accent: AppColors.info,
            ),
          ],
        ),
        const SizedBox(height: 24),
        const _SectionTitle('Top departments by points'),
        const SizedBox(height: 12),
        ...a.topDepartments.asMap().entries.map(
              (e) => _DepartmentRow(
                rank: e.key + 1,
                stat: e.value,
              ).animate().fadeIn(delay: (60 * e.key).ms).slideX(begin: 0.05),
            ),
      ],
    );
  }

  static String _compact(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return '$n';
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accent.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accent, size: 20),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
                ),
          ),
        ],
      ),
    );
  }
}

class _DepartmentRow extends StatelessWidget {
  const _DepartmentRow({required this.rank, required this.stat});

  final int rank;
  final DepartmentStat stat;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary.withValues(alpha: 0.15),
            child: Text(
              '$rank',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stat.department,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  '${stat.members} members · ${stat.activePercent.toStringAsFixed(0)}% active',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Text(
            '${stat.totalPoints} pts',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

// ─── Challenges ──────────────────────────────────────────────────────────────

class _ChallengesTab extends StatelessWidget {
  const _ChallengesTab({required this.challenges, required this.onDelete});

  final List<Challenge> challenges;
  final Future<void> Function(Challenge) onDelete;

  @override
  Widget build(BuildContext context) {
    if (challenges.isEmpty) {
      return const Center(child: Text('No challenges yet'));
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      itemCount: challenges.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final c = challenges[i];
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: c.color.withValues(alpha: 0.2),
            ),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            leading: CircleAvatar(
              backgroundColor: c.color.withValues(alpha: 0.15),
              child: Text(c.iconEmoji, style: const TextStyle(fontSize: 20)),
            ),
            title: Text(
              c.title,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(
              '${c.status.name.toUpperCase()} · ${c.participants} participants · '
              '${c.pointsReward} pts',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline_rounded),
              color: AppColors.error,
              onPressed: () => onDelete(c),
              tooltip: 'Delete',
            ),
          ),
        );
      },
    );
  }
}

// ─── Rewards ─────────────────────────────────────────────────────────────────

class _RewardsTab extends StatelessWidget {
  const _RewardsTab({required this.rewards, required this.onAdjustStock});

  final List<Reward> rewards;
  final Future<void> Function(Reward, int) onAdjustStock;

  @override
  Widget build(BuildContext context) {
    if (rewards.isEmpty) {
      return const Center(child: Text('No rewards yet'));
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      itemCount: rewards.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final r = rewards[i];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: r.color.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: r.color.withValues(alpha: 0.15),
                child: Text(r.iconEmoji, style: const TextStyle(fontSize: 22)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r.title,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${r.pointsCost} pts · ₹${r.valueInRupees} value',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              _StockStepper(
                stock: r.stock,
                onDecrement: () => onAdjustStock(r, -1),
                onIncrement: () => onAdjustStock(r, 1),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StockStepper extends StatelessWidget {
  const _StockStepper({
    required this.stock,
    required this.onDecrement,
    required this.onIncrement,
  });

  final int stock;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_rounded, size: 18),
            onPressed: stock > 0 ? onDecrement : null,
            visualDensity: VisualDensity.compact,
            tooltip: 'Decrement stock',
          ),
          SizedBox(
            width: 26,
            child: Text(
              '$stock',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded, size: 18),
            onPressed: onIncrement,
            visualDensity: VisualDensity.compact,
            tooltip: 'Increment stock',
          ),
        ],
      ),
    );
  }
}

// ─── Shared ──────────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.w800),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 48, color: AppColors.error),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
