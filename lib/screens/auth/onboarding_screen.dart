import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/theme/app_colors.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pc = PageController();
  int _index = 0;

  final List<_Slide> _slides = const [
    _Slide(
      emoji: '🏃',
      title: 'Move More',
      subtitle:
          'Automatic step tracking from your phone. No manual entry. No cheating.',
      gradient: AppColors.stepsGradient,
    ),
    _Slide(
      emoji: '🏆',
      title: 'Compete Together',
      subtitle:
          'Join challenges with your team. Win points. Climb the leaderboard.',
      gradient: AppColors.challengesGradient,
    ),
    _Slide(
      emoji: '🎁',
      title: 'Real Rewards',
      subtitle:
          'Redeem points for vouchers, time off, merchandise and more.',
      gradient: AppColors.rewardsGradient,
    ),
    _Slide(
      emoji: '☕',
      title: 'Build Connections',
      subtitle:
          'Coffee roulette, ideas, events. Get to know your coworkers.',
      gradient: AppColors.successGradient,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: SafeArea(
        child: Column(
          children: [
            // Skip
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: TextButton(
                  onPressed: _goToLogin,
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pc,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (_, i) => _buildSlide(_slides[i], i),
              ),
            ),
            // Indicator
            SmoothPageIndicator(
              controller: _pc,
              count: _slides.length,
              effect: ExpandingDotsEffect(
                activeDotColor: AppColors.primary,
                dotColor: Colors.white.withValues(alpha: 0.2),
                dotHeight: 8,
                dotWidth: 8,
                expansionFactor: 4,
                spacing: 6,
              ),
            ),
            const SizedBox(height: 32),
            // Next button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: double.infinity,
                height: 58,
                decoration: BoxDecoration(
                  gradient: AppColors.brandGradient,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {
                      if (_index < _slides.length - 1) {
                        _pc.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOutCubic,
                        );
                      } else {
                        _goToLogin();
                      }
                    },
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _index == _slides.length - 1
                                ? 'Get Started'
                                : 'Continue',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide(_Slide s, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon disc
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: s.gradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: s.gradient.colors.first.withValues(alpha: 0.45),
                  blurRadius: 50,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Center(
              child: Text(s.emoji, style: const TextStyle(fontSize: 100)),
            ),
          )
              .animate(key: ValueKey(index))
              .scale(
                begin: const Offset(0.7, 0.7),
                end: const Offset(1, 1),
                duration: 500.ms,
                curve: Curves.easeOutBack,
              )
              .fadeIn(),
          const SizedBox(height: 56),
          Text(
            s.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          )
              .animate(key: ValueKey('t$index'))
              .fadeIn(delay: 200.ms, duration: 400.ms)
              .slideY(begin: 0.3, end: 0),
          const SizedBox(height: 16),
          Text(
            s.subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 16,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          )
              .animate(key: ValueKey('s$index'))
              .fadeIn(delay: 350.ms, duration: 400.ms)
              .slideY(begin: 0.3, end: 0),
        ],
      ),
    );
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, a, __) => const LoginScreen(),
        transitionsBuilder: (_, a, __, child) =>
            FadeTransition(opacity: a, child: child),
      ),
    );
  }
}

class _Slide {
  final String emoji;
  final String title;
  final String subtitle;
  final Gradient gradient;
  const _Slide({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.gradient,
  });
}
