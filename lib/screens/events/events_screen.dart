import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/time_utils.dart';
import '../../models/models.dart';
import '../../providers/app_provider.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        leading: const BackButton(),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: app.events.length,
        itemBuilder: (_, i) {
          final e = app.events[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _eventCard(context, e, app)
                .animate(delay: (i * 60).ms)
                .fadeIn()
                .slideY(begin: 0.1, end: 0),
          );
        },
      ),
    );
  }

  Widget _eventCard(BuildContext c, Event e, AppProvider app) {
    final isDark = Theme.of(c).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(c).cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: e.color.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        children: [
          // Banner
          Container(
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  e.color.withValues(alpha: 0.9),
                  e.color.withValues(alpha: 0.5),
                ],
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(23)),
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(e.iconEmoji,
                      style: const TextStyle(fontSize: 56)),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      e.category.name.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded,
                            size: 12, color: AppColors.accent),
                        const SizedBox(width: 3),
                        Text(
                          '+${e.pointsReward}',
                          style: TextStyle(
                            color: e.color,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  e.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),
                _infoRow(Icons.calendar_today_rounded,
                    '${TimeUtils.shortDate(e.startTime)} • ${TimeUtils.timeOfDay(e.startTime)}'),
                const SizedBox(height: 6),
                _infoRow(Icons.location_on_outlined, e.location),
                const SizedBox(height: 6),
                _infoRow(Icons.person_outline_rounded, e.organizer),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: e.registered / e.capacity,
                              minHeight: 5,
                              backgroundColor:
                                  e.color.withValues(alpha: 0.15),
                              valueColor: AlwaysStoppedAnimation(e.color),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${e.registered}/${e.capacity} registered',
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
                    const SizedBox(width: 14),
                    ElevatedButton(
                      onPressed: () => app.toggleEventRegistration(e.id),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            e.isRegistered ? Colors.grey.shade800 : e.color,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 12),
                      ),
                      child: Text(
                        e.isRegistered ? 'Registered ✓' : 'Register',
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.white.withValues(alpha: 0.6)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12.5,
              color: Colors.white.withValues(alpha: 0.85),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
