import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/time_utils.dart';
import '../../core/widgets/glass_card.dart';
import '../../providers/app_provider.dart';
import '../auth/login_screen.dart';
import 'points_history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final user = app.currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 120),
        children: [
          // Header banner
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.brandGradient,
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.settings_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () => _showSettings(context),
                        ),
                        IconButton(
                          icon: Icon(
                            app.themeMode == ThemeMode.dark
                                ? Icons.light_mode_rounded
                                : Icons.dark_mode_rounded,
                            color: Colors.white,
                          ),
                          onPressed: app.toggleTheme,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        shape: BoxShape.circle,
                      ),
                      child: AvatarCircle(
                        initials: user.initials,
                        size: 92,
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      user.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${user.department} • ${user.team}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 13,
                      ),
                    ),
                    if (user.bio.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        user.bio,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    // Stats row
                    Row(
                      children: [
                        Expanded(
                          child: _heroStat(
                            'Level',
                            '${user.level}',
                            Icons.bolt_rounded,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 36,
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                        Expanded(
                          child: _heroStat(
                            'Points',
                            TimeUtils.formatNumber(user.totalPoints),
                            Icons.star_rounded,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 36,
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                        Expanded(
                          child: _heroStat(
                            'Trust',
                            '${user.trustScore}%',
                            Icons.verified_rounded,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Achievements
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text(
                            'Achievements',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Spacer(),
                          Text(
                            '8 / 24',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primaryLight,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 80,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _badge('🏆', 'First 10K', true),
                            _badge('🔥', 'Week Streak', true),
                            _badge('💧', 'Hydrated', true),
                            _badge('⚡', 'Quick', true),
                            _badge('🎯', 'Goal Set', true),
                            _badge('⭐', 'Lvl 10', true),
                            _badge('🚀', 'Lvl 25', false),
                            _badge('💎', 'Lvl 50', false),
                            _badge('👑', 'Top 5', false),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn().slideY(begin: 0.1, end: 0),
                const SizedBox(height: 14),

                // Menu items
                _menuTile(
                  context,
                  Icons.history_rounded,
                  'Points History',
                  'See all your transactions',
                  AppColors.accent,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PointsHistoryScreen(),
                    ),
                  ),
                ),
                _menuTile(
                  context,
                  Icons.flag_rounded,
                  'Personal Goals',
                  '${app.personalGoals.length} active goals',
                  AppColors.success,
                  null,
                ),
                _menuTile(
                  context,
                  Icons.coffee_rounded,
                  'Coffee Roulette',
                  '${app.coffeeMatches.length} past matches',
                  AppColors.coffee,
                  null,
                ),
                _menuTile(
                  context,
                  Icons.privacy_tip_rounded,
                  'Privacy & Data',
                  'Manage what you share',
                  AppColors.water,
                  null,
                ),
                _menuTile(
                  context,
                  Icons.help_outline_rounded,
                  'Help & Support',
                  'FAQs and contact',
                  AppColors.ideas,
                  null,
                ),
                _menuTile(
                  context,
                  Icons.logout_rounded,
                  'Sign Out',
                  'See you soon!',
                  AppColors.error,
                  () => _signOut(context),
                ),
                const SizedBox(height: 24),
                Text(
                  'Pulse v1.0.0',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textTertiaryDark
                        : AppColors.textTertiaryLight,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Built with ❤️ for great workplaces',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textTertiaryDark
                        : AppColors.textTertiaryLight,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _badge(String emoji, String label, bool earned) {
    return Container(
      width: 72,
      margin: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: earned ? AppColors.brandGradient : null,
              color: earned ? null : Colors.white.withValues(alpha: 0.05),
              shape: BoxShape.circle,
              boxShadow: earned
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                emoji,
                style: TextStyle(
                  fontSize: 24,
                  color: earned
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: earned
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.4),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _menuTile(BuildContext c, IconData icon, String title, String subtitle,
      Color color, VoidCallback? onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassCard(
        padding: const EdgeInsets.all(14),
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettings(BuildContext c) {
    showModalBottomSheet(
      context: c,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: Theme.of(c).cardTheme.color,
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
            const SizedBox(height: 18),
            const Text(
              'Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.notifications_rounded),
              title: const Text('Notifications'),
              trailing: Switch.adaptive(
                value: true,
                onChanged: (_) {},
                activeThumbColor: AppColors.primary,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.fingerprint_rounded),
              title: const Text('Biometric Lock'),
              trailing: Switch.adaptive(
                value: false,
                onChanged: (_) {},
                activeThumbColor: AppColors.primary,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.language_rounded),
              title: const Text('Language'),
              trailing: const Text('English'),
              onTap: () {},
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _signOut(BuildContext c) {
    showDialog(
      context: c,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Sign out?'),
        content: const Text('You\'ll need to sign in again next time.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(c);
              Navigator.of(c).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (r) => false,
              );
            },
            child: const Text(
              'Sign Out',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
