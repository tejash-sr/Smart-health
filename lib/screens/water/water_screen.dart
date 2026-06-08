import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/time_utils.dart';
import '../../core/widgets/glass_card.dart';
import '../../providers/app_provider.dart';

class WaterScreen extends StatelessWidget {
  const WaterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hydration'),
        leading: const BackButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Hero glass card
          GradientCard(
            gradient: AppColors.waterGradient,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Animated water bottle
                SizedBox(
                  height: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Bottle outline
                      Container(
                        width: 140,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                      ),
                      // Water fill
                      Positioned(
                        bottom: 4,
                        left: 4,
                        right: 4,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOutCubic,
                          height: (192 * app.waterProgress).clamp(8.0, 192.0),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFFB3E5FC),
                                Color(0xFF4FC3F7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(38),
                          ),
                        ),
                      ),
                      // Center text
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${(app.totalWaterMl / 1000).toStringAsFixed(1)}L',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1,
                            ),
                          ),
                          Text(
                            'of ${(app.waterGoalMl / 1000).toStringAsFixed(0)}L',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '${(app.waterProgress * 100).round()}% of daily goal',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'Quick Add',
            style:
                TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(child: _addBtn(context, app, 250, '🥤', 'Glass')),
              const SizedBox(width: 10),
              Expanded(child: _addBtn(context, app, 500, '💧', 'Bottle')),
              const SizedBox(width: 10),
              Expanded(child: _addBtn(context, app, 1000, '🍶', 'Liter')),
            ],
          ),
          const SizedBox(height: 24),

          const Text(
            'Today\'s Log',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),

          ...app.waterLogs.reversed.map((log) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GlassCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: AppColors.waterGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Icon(Icons.water_drop_rounded,
                              color: Colors.white, size: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${log.amountMl} ml',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              TimeUtils.timeOfDay(log.time),
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
                        '+${(log.amountMl / 100).round()} pts',
                        style: const TextStyle(
                          color: AppColors.water,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 24),

          // Streak
          GlassCard(
            gradient: LinearGradient(
              colors: [
                AppColors.warning.withValues(alpha: 0.15),
                AppColors.error.withValues(alpha: 0.05),
              ],
            ),
            child: const Row(
              children: [
                Text('🔥', style: TextStyle(fontSize: 36)),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '8-day Hydration Streak',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Keep it going! Hit 3L today.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn().shake(hz: 1, duration: 600.ms),
        ],
      ),
    );
  }

  Widget _addBtn(
      BuildContext c, AppProvider app, int ml, String emoji, String label) {
    return GestureDetector(
      onTap: () {
        app.addWater(ml);
        ScaffoldMessenger.of(c).showSnackBar(
          SnackBar(
            content: Text('+$ml ml logged'),
            backgroundColor: AppColors.water,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.water.withValues(alpha: 0.18),
              AppColors.water.withValues(alpha: 0.06),
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.water.withValues(alpha: 0.25),
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '${ml}ml',
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.water,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
