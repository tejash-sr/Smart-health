import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/glass_card.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Goals'),
        leading: const BackButton(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.success,
        onPressed: () => _showAddGoal(context),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'New Goal',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
        children: [
          // Summary
          GradientCard(
            gradient: AppColors.successGradient,
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Habits',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${app.personalGoals.length} active goals',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Text('🔥',
                              style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 4),
                          Text(
                            'Best streak: ${app.personalGoals.map((g) => g.streakDays).fold<int>(0, (a, b) => a > b ? a : b)} days',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Text('🎯', style: TextStyle(fontSize: 50)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          ...app.personalGoals.asMap().entries.map((entry) {
            final i = entry.key;
            final g = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GlassCard(
                child: Row(
                  children: [
                    // Circular progress
                    SizedBox(
                      width: 72,
                      height: 72,
                      child: CircularPercentIndicator(
                        radius: 36,
                        lineWidth: 7,
                        percent: g.progress,
                        backgroundColor: g.color.withValues(alpha: 0.15),
                        progressColor: g.color,
                        circularStrokeCap: CircularStrokeCap.round,
                        center: Text(
                          g.iconEmoji,
                          style: const TextStyle(fontSize: 26),
                        ),
                        animation: true,
                        animationDuration: 800,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            g.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${g.current} / ${g.target} ${g.unit}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.warning
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text('🔥',
                                        style: TextStyle(fontSize: 10)),
                                    const SizedBox(width: 3),
                                    Text(
                                      '${g.streakDays}d streak',
                                      style: const TextStyle(
                                        color: AppColors.warning,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: g.color.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${(g.progress * 100).round()}%',
                                  style: TextStyle(
                                    color: g.color,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline_rounded),
                      color: g.color,
                      onPressed: () {
                        app.updateGoalProgress(
                          g.id,
                          (g.current + (g.target ~/ 20)).clamp(0, g.target),
                        );
                      },
                    ),
                  ],
                ),
              )
                  .animate(delay: (i * 80).ms)
                  .fadeIn()
                  .slideX(begin: 0.1, end: 0),
            );
          }),
        ],
      ),
    );
  }

  void _showAddGoal(BuildContext c) {
    final title = TextEditingController();
    final target = TextEditingController();
    final unit = TextEditingController(text: 'reps');
    String emoji = '🎯';
    final emojis = ['🎯', '📚', '💪', '🧘', '🏃', '💧', '😴', '🥗'];
    showModalBottomSheet(
      context: c,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSt) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(c).viewInsets.bottom,
          ),
          child: Container(
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
                  'New Personal Goal',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  children: emojis
                      .map(
                        (e) => GestureDetector(
                          onTap: () => setSt(() => emoji = e),
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: emoji == e
                                  ? AppColors.success.withValues(alpha: 0.2)
                                  : Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: emoji == e
                                    ? AppColors.success
                                    : Colors.transparent,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                e,
                                style: const TextStyle(fontSize: 22),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: title,
                  decoration: const InputDecoration(
                    hintText: 'Goal name (e.g. Read daily)',
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: target,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Target (e.g. 30)',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: unit,
                        decoration: const InputDecoration(
                          hintText: 'Unit (e.g. pages)',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                    ),
                    onPressed: () {
                      final t = int.tryParse(target.text) ?? 10;
                      if (title.text.trim().isEmpty) return;
                      c.read<AppProvider>().addGoal(
                            PersonalGoal(
                              id: 'g_${DateTime.now().millisecondsSinceEpoch}',
                              title: title.text.trim(),
                              iconEmoji: emoji,
                              target: t,
                              current: 0,
                              unit: unit.text.trim(),
                              createdAt: DateTime.now(),
                              color: AppColors.success,
                            ),
                          );
                      Navigator.pop(c);
                    },
                    child: const Text('Create Goal'),
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
