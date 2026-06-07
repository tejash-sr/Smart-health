import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/time_utils.dart';
import '../../core/widgets/glass_card.dart';
import '../../providers/app_provider.dart';

class PointsHistoryScreen extends StatelessWidget {
  const PointsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final earned = app.pointsHistory.where((t) => t.amount > 0).toList();
    final spent = app.pointsHistory.where((t) => t.amount < 0).toList();
    final totalEarned = earned.fold<int>(0, (s, t) => s + t.amount);
    final totalSpent = spent.fold<int>(0, (s, t) => s + t.amount.abs());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Points History'),
        leading: const BackButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Summary
          Row(
            children: [
              Expanded(
                child: GradientCard(
                  gradient: AppColors.successGradient,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.trending_up_rounded,
                              color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'Earned',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '+${TimeUtils.formatNumberWithCommas(totalEarned)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GradientCard(
                  gradient: AppColors.rewardsGradient,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.shopping_bag_outlined,
                              color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'Spent',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '-${TimeUtils.formatNumberWithCommas(totalSpent)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'All Transactions',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          ...app.pointsHistory.asMap().entries.map((entry) {
            final i = entry.key;
            final tx = entry.value;
            final isPositive = tx.amount > 0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GlassCard(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: (isPositive
                                ? AppColors.success
                                : AppColors.error)
                            .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          tx.iconEmoji,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tx.description,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${tx.actionType} • ${TimeUtils.timeAgo(tx.timestamp)}',
                            style: TextStyle(
                              fontSize: 10.5,
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${isPositive ? '+' : ''}${tx.amount}',
                      style: TextStyle(
                        color:
                            isPositive ? AppColors.success : AppColors.error,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ).animate(delay: (i * 40).ms).fadeIn().slideX(begin: 0.1, end: 0),
            );
          }),
        ],
      ),
    );
  }
}
