import 'dart:async';

import 'package:flutter/material.dart';

import '../core/di/injection_container.dart';
import '../core/network/result.dart';
import '../models/models.dart';
import '../services/mock_data.dart';

/// Single source of truth for app-wide UI state.
///
/// Pulls data via the [ServiceLocator]-resolved repositories ([sl.userRepository],
/// [sl.challengeRepository], [sl.socialRepository]) — when [kUseMockRepositories]
/// is true those return mock data, when false they hit the V5 backend.
///
/// Eagerly seeds local lists from [MockData] so the UI has something to paint
/// during the first frame, then refreshes asynchronously from the repositories
/// so the rest of the screens never see a 'null' state.
class AppProvider extends ChangeNotifier {
  AppProvider() {
    _init();
  }

  // ─── State ─────────────────────────────────────────────────────────────────
  ThemeMode _themeMode = ThemeMode.dark;
  User _currentUser = MockData.currentUser;

  late List<Challenge> _challenges;
  late List<Reward> _rewards;
  late List<SocialPost> _posts;
  late List<Event> _events;
  late List<Doubt> _doubts;
  late List<Idea> _ideas;
  late List<CoffeeMatch> _coffeeMatches;
  late List<PersonalGoal> _personalGoals;
  late List<PointsTransaction> _pointsHistory;
  late List<AppNotification> _notifications;
  late StepRecord _todaySteps;
  late List<WaterLog> _waterLogs;

  bool _loading = false;
  String? _lastError;

  // Step simulation (anti-cheat trust score). In production this is driven
  // by the V6 StepSensorService; the timer is only a UI fallback so the
  // 'today steps' card animates during demos on platforms without sensors.
  Timer? _stepTimer;
  int _liveSteps = 7842;

  void _init() {
    // Synchronous seed so the UI never crashes on first build.
    _challenges = MockData.getChallenges();
    _rewards = MockData.getRewards();
    _posts = MockData.getSocialPosts();
    _events = MockData.getEvents();
    _doubts = MockData.getDoubts();
    _ideas = MockData.getIdeas();
    _coffeeMatches = MockData.getCoffeeMatches();
    _personalGoals = MockData.getPersonalGoals();
    _pointsHistory = MockData.getPointsHistory();
    _notifications = MockData.getNotifications();
    _todaySteps = MockData.todaySteps;
    _waterLogs = MockData.getTodayWaterLogs();

    // Kick off async hydration from repositories without blocking the UI.
    // ignore: discarded_futures — fire-and-forget by design.
    refreshAll();

    _stepTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      _liveSteps += 12 + (DateTime.now().second % 18);
      _todaySteps = StepRecord(
        date: DateTime.now(),
        steps: _liveSteps,
        distanceKm: _liveSteps * 0.0007,
        caloriesBurned: (_liveSteps * 0.04).round(),
        activeMinutes: (_liveSteps / 100).round(),
        trustScore: 98,
      );
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _stepTimer?.cancel();
    super.dispose();
  }

  // ─── Async hydration ───────────────────────────────────────────────────────

  /// Pulls every top-level collection through the repository layer.
  ///
  /// Failures are non-fatal: the mock-seeded lists remain in place and
  /// [_lastError] surfaces the first non-success so the UI can show a
  /// transient banner without losing what's already on screen.
  Future<void> refreshAll() async {
    _loading = true;
    _lastError = null;
    notifyListeners();

    try {
      await Future.wait<void>([
        _refreshCurrentUser(),
        _refreshChallenges(),
        _refreshPosts(),
        _refreshPointsHistory(),
      ]);
    } catch (e, st) {
      _lastError = e.toString();
      debugPrint('AppProvider.refreshAll failed: $e\n$st');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> _refreshCurrentUser() async {
    final res = await sl.userRepository.getCurrentUser();
    if (res is Success<User>) {
      _currentUser = res.data;
    } else if (res is Failure<User>) {
      _lastError ??= res.message;
    }
  }

  Future<void> _refreshChallenges() async {
    final res = await sl.challengeRepository.getChallenges();
    if (res is Success<List<Challenge>>) {
      _challenges = List<Challenge>.from(res.data);
    } else if (res is Failure<List<Challenge>>) {
      _lastError ??= res.message;
    }
  }

  Future<void> _refreshPosts() async {
    final res = await sl.socialRepository.getFeed();
    if (res is Success<List<SocialPost>>) {
      _posts = List<SocialPost>.from(res.data);
    } else if (res is Failure<List<SocialPost>>) {
      _lastError ??= res.message;
    }
  }

  Future<void> _refreshPointsHistory() async {
    final res = await sl.userRepository.getPointsHistory(_currentUser.id);
    if (res is Success<List<PointsTransaction>>) {
      _pointsHistory = List<PointsTransaction>.from(res.data);
    } else if (res is Failure<List<PointsTransaction>>) {
      _lastError ??= res.message;
    }
  }

  // ─── Getters ───────────────────────────────────────────────────────────────
  ThemeMode get themeMode => _themeMode;
  User get currentUser => _currentUser;
  List<Challenge> get challenges => _challenges;
  List<Challenge> get activeChallenges =>
      _challenges.where((c) => c.status == ChallengeStatus.active).toList();
  List<Reward> get rewards => _rewards;
  List<SocialPost> get posts => _posts;
  List<Event> get events => _events;
  List<Event> get upcomingEvents =>
      _events.where((e) => e.status == EventStatus.upcoming).toList();
  List<Doubt> get doubts => _doubts;
  List<Idea> get ideas => _ideas;
  List<CoffeeMatch> get coffeeMatches => _coffeeMatches;
  List<PersonalGoal> get personalGoals => _personalGoals;
  List<PointsTransaction> get pointsHistory => _pointsHistory;
  List<AppNotification> get notifications => _notifications;
  int get unreadNotifications =>
      _notifications.where((n) => !n.read).length;
  StepRecord get todaySteps => _todaySteps;
  List<WaterLog> get waterLogs => _waterLogs;
  int get totalWaterMl =>
      _waterLogs.fold<int>(0, (sum, w) => sum + w.amountMl);
  int get waterGoalMl => 3000;
  double get waterProgress =>
      (totalWaterMl / waterGoalMl).clamp(0.0, 1.0);

  bool get isLoading => _loading;
  String? get lastError => _lastError;

  // ─── Actions ───────────────────────────────────────────────────────────────
  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void addWater(int amountMl) {
    _waterLogs.add(WaterLog(time: DateTime.now(), amountMl: amountMl));
    notifyListeners();
  }

  /// Optimistic like-toggle: update local state first, then ask the
  /// repository to persist. On failure we roll the local state back.
  Future<void> toggleLike(String postId) async {
    final post = _posts.firstWhere((p) => p.id == postId);
    post.liked = !post.liked;
    post.likes += post.liked ? 1 : -1;
    notifyListeners();

    final res = await sl.socialRepository.likePost(postId);
    if (res is Failure<void>) {
      // Roll back on failure.
      post.liked = !post.liked;
      post.likes += post.liked ? 1 : -1;
      _lastError = res.message;
      notifyListeners();
    }
  }

  void toggleDoubtUpvote(String id) {
    final d = _doubts.firstWhere((d) => d.id == id);
    d.upvoted = !d.upvoted;
    d.upvotes += d.upvoted ? 1 : -1;
    notifyListeners();
  }

  void toggleIdeaUpvote(String id) {
    final i = _ideas.firstWhere((e) => e.id == id);
    i.upvoted = !i.upvoted;
    i.upvotes += i.upvoted ? 1 : -1;
    notifyListeners();
  }

  void toggleEventRegistration(String id) {
    final e = _events.firstWhere((ev) => ev.id == id);
    e.isRegistered = !e.isRegistered;
    notifyListeners();
  }

  void markNotificationRead(String id) {
    final n = _notifications.firstWhere((x) => x.id == id);
    n.read = true;
    notifyListeners();
  }

  void markAllNotificationsRead() {
    for (final n in _notifications) {
      n.read = true;
    }
    notifyListeners();
  }

  /// Joins a challenge through the repository. Returns true on success so
  /// the caller can show a snackbar.
  Future<bool> joinChallenge(String challengeId) async {
    final res = await sl.challengeRepository.joinChallenge(challengeId);
    if (res is Success<void>) {
      // Optimistic participant bump while we wait for the next refresh.
      final idx = _challenges.indexWhere((c) => c.id == challengeId);
      if (idx != -1) {
        final c = _challenges[idx];
        _challenges[idx] = Challenge(
          id: c.id,
          title: c.title,
          description: c.description,
          iconEmoji: c.iconEmoji,
          type: c.type,
          frequency: c.frequency,
          status: c.status,
          targetValue: c.targetValue,
          currentValue: c.currentValue,
          pointsReward: c.pointsReward,
          startDate: c.startDate,
          endDate: c.endDate,
          participants: c.participants + 1,
          unit: c.unit,
          color: c.color,
        );
        notifyListeners();
      }
      return true;
    }
    if (res is Failure<void>) {
      _lastError = res.message;
      notifyListeners();
    }
    return false;
  }

  bool redeemReward(Reward reward) {
    if (_currentUser.totalPoints < reward.pointsCost) return false;
    _currentUser = User(
      id: _currentUser.id,
      name: _currentUser.name,
      email: _currentUser.email,
      department: _currentUser.department,
      team: _currentUser.team,
      role: _currentUser.role,
      totalPoints: _currentUser.totalPoints - reward.pointsCost,
      level: _currentUser.level,
      trustScore: _currentUser.trustScore,
      bio: _currentUser.bio,
    );
    _pointsHistory.insert(
      0,
      PointsTransaction(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        actionType: 'REDEMPTION',
        description: 'Redeemed ${reward.title}',
        amount: -reward.pointsCost,
        timestamp: DateTime.now(),
        iconEmoji: reward.iconEmoji,
      ),
    );
    notifyListeners();
    return true;
  }

  void addPost(String content) {
    _posts.insert(
      0,
      SocialPost(
        id: 'p_${DateTime.now().millisecondsSinceEpoch}',
        author: _currentUser,
        content: content,
        type: PostType.general,
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void addIdea(String title, String description, String category) {
    _ideas.insert(
      0,
      Idea(
        id: 'i_${DateTime.now().millisecondsSinceEpoch}',
        author: _currentUser,
        title: title,
        description: description,
        category: category,
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void addDoubt(String title, String content, List<String> tags) {
    _doubts.insert(
      0,
      Doubt(
        id: 'd_${DateTime.now().millisecondsSinceEpoch}',
        author: _currentUser,
        title: title,
        content: content,
        tags: tags,
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void updateGoalProgress(String id, int newValue) {
    final g = _personalGoals.firstWhere((g) => g.id == id);
    g.current = newValue;
    notifyListeners();
  }

  void addGoal(PersonalGoal g) {
    _personalGoals.add(g);
    notifyListeners();
  }
}
