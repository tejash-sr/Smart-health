import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/time_utils.dart';
import '../../core/widgets/glass_card.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';
import '../../services/mock_data.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  int _filter = 0; // 0 = company, 1 = department, 2 = team

  @override
  Widget build(BuildContext context) {
    final entries = MockData.getLeaderboard();
    final top3 = entries.take(3).toList();
    final rest = entries.skip(3).toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        leading: const BackButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          // Filter chips
          Row(
            children: [
              _chip('Company', 0),
              const SizedBox(width: 8),
              _chip('Department', 1),
              const SizedBox(width: 8),
              _chip('Team', 2),
            ],
          ),
          const SizedBox(height: 24),

          // Podium
          SizedBox(
            height: 240,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // 2nd
                Positioned(
                  left: 8,
                  bottom: 0,
                  child: _podium(top3.length > 1 ? top3[1] : null, 2, 120,
                      AppColors.water),
                ),
                // 3rd
                Positioned(
                  right: 8,
                  bottom: 0,
                  child: _podium(top3.length > 2 ? top3[2] : null, 3, 90,
                      AppColors.warning),
                ),
                // 1st
                Positioned(
                  bottom: 0,
                  child: _podium(top3.isNotEmpty ? top3[0] : null, 1, 160,
                      AppColors.accent),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Rest of leaderboard
          ...rest.map((e) {
            final isMe = e.user.id == context.read<AppProvider>().currentUser.id;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GlassCard(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                gradient: isMe
                    ? LinearGradient(colors: [
                        AppColors.primary.withValues(alpha: 0.2),
                        AppColors.secondary.withValues(alpha: 0.1),
                      ])
                    : null,
                child: Row(
                  children: [
                    SizedBox(
                      width: 28,
                      child: Text(
                        '#${e.rank}',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                    AvatarCircle(initials: e.user.initials, size: 38),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  e.user.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: isDark
                                        ? AppColors.textPrimaryDark
                                        : AppColors.textPrimaryLight,
                                  ),
                                ),
                              ),
                              if (isMe) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'YOU',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Text(
                            '${e.user.department} • Lvl ${e.user.level}',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          TimeUtils.formatNumberWithCommas(e.score),
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              e.delta > 0
                                  ? Icons.arrow_drop_up_rounded
                                  : e.delta < 0
                                      ? Icons.arrow_drop_down_rounded
                                      : Icons.remove_rounded,
                              color: e.delta > 0
                                  ? AppColors.success
                                  : e.delta < 0
                                      ? AppColors.error
                                      : Colors.grey,
                              size: 16,
                            ),
                            Text(
                              '${e.delta.abs()}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: e.delta > 0
                                    ? AppColors.success
                                    : e.delta < 0
                                        ? AppColors.error
                                        : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
                .animate(delay: (rest.indexOf(e) * 50).ms)
                .fadeIn()
                .slideX(begin: 0.1, end: 0);
          }),
        ],
      ),
    );
  }

  Widget _chip(String label, int idx) {
    final selected = _filter == idx;
    return GestureDetector(
      onTap: () => setState(() => _filter = idx),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: selected ? AppColors.brandGradient : null,
          color: selected ? null : Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? Colors.transparent
                : Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? Colors.white
                : Colors.white.withValues(alpha: 0.7),
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _podium(LeaderboardEntry? entry, int rank, double height, Color color) {
    if (entry == null) return const SizedBox.shrink();
    final medals = {1: '🥇', 2: '🥈', 3: '🥉'};
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(medals[rank]!, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 6),
        AvatarCircle(
          initials: entry.user.initials,
          size: rank == 1 ? 64 : 52,
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 100,
          child: Text(
            entry.user.name.split(' ').first,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          TimeUtils.formatNumber(entry.score),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 100,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [color, color.withValues(alpha: 0.4)],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '#$rank',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ).animate().scale(
              begin: const Offset(0.5, 0.5),
              end: const Offset(1, 1),
              duration: 500.ms,
              curve: Curves.easeOutBack,
              delay: (rank * 100).ms,
            ),
      ],
    );
  }
}
