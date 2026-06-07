import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/time_utils.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  RewardCategory? _filter;
  final _confetti = ConfettiController(duration: const Duration(seconds: 2));

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final all = app.rewards;
    final filtered =
        _filter == null ? all : all.where((r) => r.category == _filter).toList();

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
              children: [
                // Header
                Row(
                  children: [
                    ShaderMask(
                      shaderCallback: (b) =>
                          AppColors.rewardsGradient.createShader(b),
                      child: const Text(
                        'Rewards',
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: AppColors.brandGradient,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded,
                              color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            TimeUtils.formatNumberWithCommas(
                                app.currentUser.totalPoints),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Redeem your hard-earned points',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 18),

                // Categories
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _catChip(null, 'All'),
                      ...RewardCategory.values.map(
                        (c) => _catChip(c, _categoryLabel(c)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.78,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) => _rewardCard(filtered[i], i),
                ),
              ],
            ),
          ),
          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                AppColors.primary,
                AppColors.secondary,
                AppColors.accent,
                AppColors.success,
              ],
              numberOfParticles: 30,
              gravity: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  String _categoryLabel(RewardCategory c) => switch (c) {
        RewardCategory.voucher => 'Vouchers',
        RewardCategory.merchandise => 'Merch',
        RewardCategory.experience => 'Experiences',
        RewardCategory.timeOff => 'Time Off',
        RewardCategory.food => 'Food',
      };

  Widget _catChip(RewardCategory? c, String label) {
    final selected = _filter == c;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => setState(() => _filter = c),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: selected ? AppColors.rewardsGradient : null,
            color: selected ? null : Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected
                  ? Colors.transparent
                  : Colors.white.withValues(alpha: 0.1),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected
                    ? Colors.white
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

  Widget _rewardCard(Reward r, int idx) {
    final app = context.read<AppProvider>();
    final canAfford = app.currentUser.totalPoints >= r.pointsCost;

    return GestureDetector(
      onTap: () => _showRewardDetails(r, canAfford),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: r.color.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image area
            Container(
              height: 110,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    r.color.withValues(alpha: 0.9),
                    r.color.withValues(alpha: 0.5),
                  ],
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(19)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      r.iconEmoji,
                      style: const TextStyle(fontSize: 56),
                    ),
                  ),
                  if (r.isPopular)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.local_fire_department_rounded,
                                color: AppColors.error, size: 12),
                            const SizedBox(width: 2),
                            Text(
                              'HOT',
                              style: TextStyle(
                                color: r.color,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${r.stock} left',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    r.title,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: AppColors.accent, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        TimeUtils.formatNumberWithCommas(r.pointsCost),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: canAfford
                              ? AppColors.accent
                              : Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '₹${r.valueInRupees}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.5),
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate(delay: (idx * 50).ms).fadeIn().slideY(begin: 0.1, end: 0);
  }

  void _showRewardDetails(Reward r, bool canAfford) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    r.color,
                    r.color.withValues(alpha: 0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: r.color.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Text(r.iconEmoji,
                    style: const TextStyle(fontSize: 56)),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              r.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              r.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: AppColors.brandGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star_rounded,
                      color: Colors.white, size: 22),
                  const SizedBox(width: 6),
                  Text(
                    '${TimeUtils.formatNumberWithCommas(r.pointsCost)} points',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      canAfford ? AppColors.primary : Colors.grey.shade700,
                ),
                onPressed: canAfford
                    ? () {
                        Navigator.pop(context);
                        final ok =
                            context.read<AppProvider>().redeemReward(r);
                        if (ok) {
                          _confetti.play();
                          _showSuccess(r);
                        }
                      }
                    : null,
                child: Text(
                  canAfford ? 'Redeem Now' : 'Not enough points',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _showSuccess(Reward r) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded,
                    color: AppColors.success, size: 48),
              )
                  .animate()
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(1, 1),
                    duration: 400.ms,
                    curve: Curves.elasticOut,
                  )
                  .then()
                  .shake(hz: 2, duration: 400.ms),
              const SizedBox(height: 16),
              const Text(
                'Redeemed! 🎉',
                style:
                    TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                '${r.title} is on its way. Check your email.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Awesome'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
