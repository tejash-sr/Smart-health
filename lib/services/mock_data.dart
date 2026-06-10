import 'dart:math';
import '../models/models.dart';
import '../core/theme/app_colors.dart';

class MockData {
  MockData._();

  static final Random _r = Random(42);

  // ===== Users (Office Members) =====
  static final List<User> users = [
    User(
      id: 'u1',
      name: 'Tej Krishna',
      email: 'tej@pulse.io',
      department: 'Engineering',
      team: 'Backend',
      role: UserRole.employee,
      totalPoints: 4820,
      level: 12,
      trustScore: 98,
      bio: 'Building things. Walking more.',
    ),
    User(
      id: 'u2',
      name: 'Priya Sharma',
      email: 'priya@pulse.io',
      department: 'Design',
      team: 'Product Design',
      totalPoints: 5340,
      level: 13,
      trustScore: 99,
    ),
    User(
      id: 'u3',
      name: 'Rahul Verma',
      email: 'rahul@pulse.io',
      department: 'Engineering',
      team: 'Frontend',
      totalPoints: 6210,
      level: 15,
      trustScore: 95,
    ),
    User(
      id: 'u4',
      name: 'Ananya Reddy',
      email: 'ananya@pulse.io',
      department: 'Marketing',
      team: 'Content',
      totalPoints: 3890,
      level: 10,
      trustScore: 96,
    ),
    User(
      id: 'u5',
      name: 'Vikram Singh',
      email: 'vikram@pulse.io',
      department: 'Sales',
      team: 'Enterprise',
      totalPoints: 5780,
      level: 14,
      trustScore: 92,
    ),
    User(
      id: 'u6',
      name: 'Meera Iyer',
      email: 'meera@pulse.io',
      department: 'HR',
      team: 'People Ops',
      role: UserRole.admin,
      totalPoints: 4120,
      level: 11,
      trustScore: 100,
    ),
    User(
      id: 'u7',
      name: 'Arjun Patel',
      email: 'arjun@pulse.io',
      department: 'Engineering',
      team: 'DevOps',
      totalPoints: 7250,
      level: 17,
      trustScore: 99,
    ),
    User(
      id: 'u8',
      name: 'Kavya Nair',
      email: 'kavya@pulse.io',
      department: 'Design',
      team: 'Brand',
      totalPoints: 3520,
      level: 9,
      trustScore: 97,
    ),
    User(
      id: 'u9',
      name: 'Rohan Joshi',
      email: 'rohan@pulse.io',
      department: 'Engineering',
      team: 'Backend',
      totalPoints: 4980,
      level: 12,
      trustScore: 94,
    ),
    User(
      id: 'u10',
      name: 'Sneha Gupta',
      email: 'sneha@pulse.io',
      department: 'Marketing',
      team: 'Growth',
      totalPoints: 6420,
      level: 15,
      trustScore: 98,
    ),
    User(
      id: 'u11',
      name: 'Aditya Rao',
      email: 'aditya@pulse.io',
      department: 'Sales',
      team: 'SMB',
      totalPoints: 4560,
      level: 11,
      trustScore: 93,
    ),
    User(
      id: 'u12',
      name: 'Divya Menon',
      email: 'divya@pulse.io',
      department: 'Finance',
      team: 'Operations',
      totalPoints: 3290,
      level: 8,
      trustScore: 99,
    ),
  ];

  // Current logged-in user
  static User get currentUser => users[0];

  // ===== Step Records =====
  static List<StepRecord> getStepHistory({int days = 7}) {
    final now = DateTime.now();
    return List.generate(days, (i) {
      final date = now.subtract(Duration(days: days - 1 - i));
      final base = 6000 + _r.nextInt(6000);
      return StepRecord(
        date: date,
        steps: base,
        distanceKm: base * 0.0007,
        caloriesBurned: (base * 0.04).round(),
        activeMinutes: (base / 100).round(),
        trustScore: 90 + _r.nextInt(11),
      );
    });
  }

  static StepRecord get todaySteps => StepRecord(
        date: DateTime.now(),
        steps: 7842,
        distanceKm: 5.48,
        caloriesBurned: 314,
        activeMinutes: 78,
        trustScore: 98,
      );

  // ===== Water Logs =====
  static List<WaterLog> getTodayWaterLogs() {
    final now = DateTime.now();
    return [
      WaterLog(time: now.subtract(const Duration(hours: 8)), amountMl: 250),
      WaterLog(time: now.subtract(const Duration(hours: 6)), amountMl: 500),
      WaterLog(time: now.subtract(const Duration(hours: 4)), amountMl: 250),
      WaterLog(time: now.subtract(const Duration(hours: 2)), amountMl: 500),
    ];
  }

  // ===== Challenges =====
  static List<Challenge> getChallenges() {
    final now = DateTime.now();
    return [
      Challenge(
        id: 'c1',
        title: '50K Step Sprint',
        description: 'Walk 50,000 steps this week to win.',
        iconEmoji: '🏃',
        type: ChallengeType.individual,
        frequency: ChallengeFrequency.weekly,
        status: ChallengeStatus.active,
        targetValue: 50000,
        currentValue: 32418,
        pointsReward: 500,
        startDate: now.subtract(const Duration(days: 3)),
        endDate: now.add(const Duration(days: 4)),
        participants: 87,
        unit: 'steps',
        color: AppColors.steps,
      ),
      Challenge(
        id: 'c2',
        title: 'Hydration Hero',
        description: 'Drink 3L of water every day this week.',
        iconEmoji: '💧',
        type: ChallengeType.individual,
        frequency: ChallengeFrequency.weekly,
        status: ChallengeStatus.active,
        targetValue: 7,
        currentValue: 4,
        pointsReward: 300,
        startDate: now.subtract(const Duration(days: 3)),
        endDate: now.add(const Duration(days: 4)),
        participants: 64,
        unit: 'days',
        color: AppColors.water,
      ),
      Challenge(
        id: 'c3',
        title: 'Engineering vs Design',
        description: 'Team challenge: total steps this month.',
        iconEmoji: '⚔️',
        type: ChallengeType.team,
        frequency: ChallengeFrequency.monthly,
        status: ChallengeStatus.active,
        targetValue: 2000000,
        currentValue: 1240000,
        pointsReward: 1000,
        startDate: now.subtract(const Duration(days: 12)),
        endDate: now.add(const Duration(days: 18)),
        participants: 42,
        unit: 'steps',
        color: AppColors.challenges,
      ),
      Challenge(
        id: 'c4',
        title: 'Marathon Month',
        description: 'Walk 250,000 steps this month.',
        iconEmoji: '🏆',
        type: ChallengeType.individual,
        frequency: ChallengeFrequency.monthly,
        status: ChallengeStatus.active,
        targetValue: 250000,
        currentValue: 142800,
        pointsReward: 1500,
        startDate: now.subtract(const Duration(days: 12)),
        endDate: now.add(const Duration(days: 18)),
        participants: 92,
        unit: 'steps',
        color: AppColors.accent,
      ),
      Challenge(
        id: 'c5',
        title: 'Weekend Warrior',
        description: '15K steps on Saturday & Sunday.',
        iconEmoji: '⚡',
        type: ChallengeType.individual,
        frequency: ChallengeFrequency.weekly,
        status: ChallengeStatus.upcoming,
        targetValue: 30000,
        currentValue: 0,
        pointsReward: 400,
        startDate: now.add(const Duration(days: 3)),
        endDate: now.add(const Duration(days: 5)),
        participants: 23,
        unit: 'steps',
        color: AppColors.secondary,
      ),
    ];
  }

  // ===== Leaderboard =====
  static List<LeaderboardEntry> getLeaderboard() {
    final sorted = [...users]
      ..sort((a, b) => b.totalPoints.compareTo(a.totalPoints));
    return List.generate(
      sorted.length,
      (i) => LeaderboardEntry(
        rank: i + 1,
        user: sorted[i],
        score: sorted[i].totalPoints,
        delta: _r.nextInt(5) - 2,
      ),
    );
  }

  // ===== Rewards =====
  static List<Reward> getRewards() {
    return [
      Reward(
        id: 'r1',
        title: 'Amazon ₹500 Voucher',
        description: 'Shop anything on Amazon India.',
        iconEmoji: '🎁',
        category: RewardCategory.voucher,
        pointsCost: 5000,
        valueInRupees: 500,
        stock: 25,
        isPopular: true,
        color: AppColors.accent,
      ),
      Reward(
        id: 'r2',
        title: 'Half-day Off',
        description: 'Take a half day off, no questions asked.',
        iconEmoji: '🏖️',
        category: RewardCategory.timeOff,
        pointsCost: 8000,
        valueInRupees: 2000,
        stock: 100,
        isPopular: true,
        color: AppColors.success,
      ),
      Reward(
        id: 'r3',
        title: 'Lunch on Us',
        description: '₹400 lunch voucher for any restaurant.',
        iconEmoji: '🍕',
        category: RewardCategory.food,
        pointsCost: 4000,
        valueInRupees: 400,
        stock: 50,
        color: AppColors.warning,
      ),
      Reward(
        id: 'r4',
        title: 'Pulse Hoodie',
        description: 'Premium branded company hoodie.',
        iconEmoji: '👕',
        category: RewardCategory.merchandise,
        pointsCost: 6500,
        valueInRupees: 1500,
        stock: 15,
        color: AppColors.primary,
      ),
      Reward(
        id: 'r5',
        title: 'Spa Day',
        description: 'Relax with a premium spa experience.',
        iconEmoji: '💆',
        category: RewardCategory.experience,
        pointsCost: 12000,
        valueInRupees: 3000,
        stock: 8,
        color: AppColors.secondary,
      ),
      Reward(
        id: 'r6',
        title: 'Coffee for a Month',
        description: '30 days of unlimited coffee.',
        iconEmoji: '☕',
        category: RewardCategory.food,
        pointsCost: 3000,
        valueInRupees: 800,
        stock: 30,
        isPopular: true,
        color: AppColors.coffee,
      ),
      Reward(
        id: 'r7',
        title: 'Wireless Earbuds',
        description: 'Premium noise-cancelling earbuds.',
        iconEmoji: '🎧',
        category: RewardCategory.merchandise,
        pointsCost: 15000,
        valueInRupees: 3500,
        stock: 5,
        color: AppColors.steps,
      ),
      Reward(
        id: 'r8',
        title: 'Movie Tickets ×2',
        description: 'BookMyShow voucher for two tickets.',
        iconEmoji: '🎬',
        category: RewardCategory.experience,
        pointsCost: 2500,
        valueInRupees: 600,
        stock: 40,
        color: AppColors.rewards,
      ),
    ];
  }

  // ===== Social Wall =====
  static List<SocialPost> getSocialPosts() {
    final now = DateTime.now();
    return [
      SocialPost(
        id: 'p1',
        author: users[6],
        content:
            'Just hit 10,000 steps before lunch today! 🚀 Anyone want to join me for an evening walk?',
        type: PostType.achievement,
        createdAt: now.subtract(const Duration(minutes: 23)),
        likes: 24,
        comments: 7,
        badgeEmoji: '🏆',
      ),
      SocialPost(
        id: 'p2',
        author: users[3],
        content:
            'Huge shoutout for helping me debug that gnarly auth bug yesterday. You are a lifesaver! 🙌',
        type: PostType.recognition,
        createdAt: now.subtract(const Duration(hours: 2)),
        likes: 42,
        comments: 12,
        recognizedUser: users[2],
      ),
      SocialPost(
        id: 'p3',
        author: users[5],
        content:
            'Reminder: This Friday is the company hackathon. Sign up in Events! Last year was incredible.',
        type: PostType.general,
        createdAt: now.subtract(const Duration(hours: 4)),
        likes: 18,
        comments: 3,
      ),
      SocialPost(
        id: 'p4',
        author: users[1],
        content: 'Completed my 30-day hydration streak! 💧 Feeling amazing.',
        type: PostType.milestone,
        createdAt: now.subtract(const Duration(hours: 6)),
        likes: 56,
        comments: 14,
        badgeEmoji: '💧',
      ),
      SocialPost(
        id: 'p5',
        author: users[9],
        content:
            'Engineering vs Design challenge is heating up. Let\'s go team! 💪',
        type: PostType.general,
        createdAt: now.subtract(const Duration(hours: 8)),
        likes: 33,
        comments: 9,
      ),
      SocialPost(
        id: 'p6',
        author: users[4],
        content: 'Just unlocked Level 14! Thanks to everyone keeping me motivated.',
        type: PostType.milestone,
        createdAt: now.subtract(const Duration(days: 1)),
        likes: 28,
        comments: 5,
        badgeEmoji: '⭐',
      ),
    ];
  }

  // ===== Events =====
  static List<Event> getEvents() {
    final now = DateTime.now();
    return [
      Event(
        id: 'e1',
        title: 'Friday Hackathon',
        description:
            '24-hour innovation sprint. Form teams, build prototypes, win prizes.',
        category: EventCategory.hackathon,
        status: EventStatus.upcoming,
        startTime: now.add(const Duration(days: 3)),
        endTime: now.add(const Duration(days: 4)),
        location: 'Innovation Lab, Floor 5',
        capacity: 60,
        registered: 47,
        pointsReward: 1000,
        organizer: 'Meera Iyer',
        iconEmoji: '💡',
        color: AppColors.ideas,
      ),
      Event(
        id: 'e2',
        title: 'Morning Yoga Session',
        description: 'Start your day with calm. Mats provided.',
        category: EventCategory.wellness,
        status: EventStatus.upcoming,
        startTime: now.add(const Duration(days: 1)),
        endTime: now.add(const Duration(days: 1, hours: 1)),
        location: 'Rooftop Garden',
        capacity: 30,
        registered: 21,
        pointsReward: 100,
        organizer: 'Priya Sharma',
        iconEmoji: '🧘',
        color: AppColors.success,
      ),
      Event(
        id: 'e3',
        title: 'Cricket Match - Eng vs Sales',
        description: 'Annual cricket showdown. Spectators welcome.',
        category: EventCategory.sports,
        status: EventStatus.upcoming,
        startTime: now.add(const Duration(days: 7)),
        endTime: now.add(const Duration(days: 7, hours: 4)),
        location: 'Office Grounds',
        capacity: 100,
        registered: 73,
        pointsReward: 200,
        organizer: 'Vikram Singh',
        iconEmoji: '🏏',
        color: AppColors.warning,
        isRegistered: true,
      ),
      Event(
        id: 'e4',
        title: 'Flutter Workshop',
        description: 'Learn to build mobile apps. Beginner friendly.',
        category: EventCategory.workshop,
        status: EventStatus.upcoming,
        startTime: now.add(const Duration(days: 5)),
        endTime: now.add(const Duration(days: 5, hours: 3)),
        location: 'Training Room A',
        capacity: 25,
        registered: 18,
        pointsReward: 300,
        organizer: 'Arjun Patel',
        iconEmoji: '📱',
        color: AppColors.primary,
      ),
      Event(
        id: 'e5',
        title: 'Team Lunch - All Hands',
        description: 'Monthly all-hands lunch. Food and drinks on the house.',
        category: EventCategory.social,
        status: EventStatus.upcoming,
        startTime: now.add(const Duration(days: 10)),
        endTime: now.add(const Duration(days: 10, hours: 2)),
        location: 'Cafeteria',
        capacity: 200,
        registered: 156,
        pointsReward: 50,
        organizer: 'HR Team',
        iconEmoji: '🍽️',
        color: AppColors.rewards,
      ),
    ];
  }

  // ===== Doubts (Q&A) =====
  static List<Doubt> getDoubts() {
    final now = DateTime.now();
    return [
      Doubt(
        id: 'd1',
        author: users[3],
        title: 'How do I access the VPN from a Mac?',
        content:
            'Tried installing the GlobalProtect client but it keeps disconnecting. Anyone faced this?',
        tags: ['IT', 'VPN', 'macOS'],
        createdAt: now.subtract(const Duration(hours: 1)),
        upvotes: 8,
        answerCount: 3,
        hasAcceptedAnswer: true,
      ),
      Doubt(
        id: 'd2',
        author: users[7],
        title: 'Best practices for Keycloak role mapping?',
        content:
            'Setting up new project. Should I use realm roles or client roles for fine-grained access?',
        tags: ['Keycloak', 'Security', 'Backend'],
        createdAt: now.subtract(const Duration(hours: 4)),
        upvotes: 15,
        answerCount: 5,
        hasAcceptedAnswer: false,
      ),
      Doubt(
        id: 'd3',
        author: users[4],
        title: 'How to apply for paternity leave?',
        content: 'New dad here! What\'s the process and how many days are allotted?',
        tags: ['HR', 'Leave', 'Policy'],
        createdAt: now.subtract(const Duration(hours: 8)),
        upvotes: 22,
        answerCount: 4,
        hasAcceptedAnswer: true,
      ),
      Doubt(
        id: 'd4',
        author: users[9],
        title: 'Anyone familiar with Kafka consumer groups?',
        content: 'I\'m seeing rebalancing issues when scaling consumers. Tips?',
        tags: ['Kafka', 'Backend', 'DevOps'],
        createdAt: now.subtract(const Duration(days: 1)),
        upvotes: 12,
        answerCount: 6,
        hasAcceptedAnswer: true,
      ),
      Doubt(
        id: 'd5',
        author: users[1],
        title: 'Recommended design system tools?',
        content: 'Looking for alternatives to Figma tokens. What does the team use?',
        tags: ['Design', 'Tools'],
        createdAt: now.subtract(const Duration(days: 2)),
        upvotes: 9,
        answerCount: 7,
        hasAcceptedAnswer: false,
      ),
    ];
  }

  // ===== Ideas =====
  static List<Idea> getIdeas() {
    final now = DateTime.now();
    return [
      Idea(
        id: 'i1',
        author: users[2],
        title: 'Standing desks for everyone',
        description:
            'Health benefits are real. Let\'s have adjustable standing desks across all teams.',
        category: 'Workplace',
        createdAt: now.subtract(const Duration(days: 1)),
        upvotes: 87,
        comments: 23,
        status: IdeaStatus.underReview,
      ),
      Idea(
        id: 'i2',
        author: users[5],
        title: 'Quiet rooms for deep work',
        description:
            'Open office is great but we need 2-3 quiet rooms for focused work. Phone booth style.',
        category: 'Workplace',
        createdAt: now.subtract(const Duration(days: 3)),
        upvotes: 124,
        comments: 41,
        status: IdeaStatus.accepted,
      ),
      Idea(
        id: 'i3',
        author: users[7],
        title: 'Internal mentorship program',
        description: 'Pair seniors with juniors. 1 hour a month. Big career impact.',
        category: 'Culture',
        createdAt: now.subtract(const Duration(days: 5)),
        upvotes: 156,
        comments: 38,
        status: IdeaStatus.implemented,
      ),
      Idea(
        id: 'i4',
        author: users[10],
        title: 'Quarterly hackdays',
        description:
            'Half-day, every quarter. Anyone can build anything. Demo at the end.',
        category: 'Innovation',
        createdAt: now.subtract(const Duration(days: 7)),
        upvotes: 92,
        comments: 28,
        status: IdeaStatus.proposed,
      ),
      Idea(
        id: 'i5',
        author: users[3],
        title: 'Pet-friendly Fridays',
        description: 'Bring your pet once a month. Boosts mood, builds community.',
        category: 'Culture',
        createdAt: now.subtract(const Duration(days: 10)),
        upvotes: 213,
        comments: 67,
        status: IdeaStatus.underReview,
      ),
    ];
  }

  // ===== Coffee Roulette =====
  static List<CoffeeMatch> getCoffeeMatches() {
    final now = DateTime.now();
    return [
      CoffeeMatch(
        id: 'cm1',
        partner: users[5],
        matchedAt: now.subtract(const Duration(days: 0)),
        status: CoffeeStatus.confirmed,
      ),
      CoffeeMatch(
        id: 'cm2',
        partner: users[9],
        matchedAt: now.subtract(const Duration(days: 7)),
        status: CoffeeStatus.met,
        meetingNote: 'Great chat about product strategy!',
      ),
      CoffeeMatch(
        id: 'cm3',
        partner: users[11],
        matchedAt: now.subtract(const Duration(days: 14)),
        status: CoffeeStatus.met,
        meetingNote: 'Learned about finance ops.',
      ),
    ];
  }

  // ===== Personal Goals =====
  static List<PersonalGoal> getPersonalGoals() {
    return [
      PersonalGoal(
        id: 'g1',
        title: 'Daily Steps',
        iconEmoji: '👟',
        target: 8000,
        current: 7842,
        unit: 'steps',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        color: AppColors.steps,
        streakDays: 12,
      ),
      PersonalGoal(
        id: 'g2',
        title: 'Hydration',
        iconEmoji: '💧',
        target: 3000,
        current: 1500,
        unit: 'ml',
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        color: AppColors.water,
        streakDays: 8,
      ),
      PersonalGoal(
        id: 'g3',
        title: 'Read Daily',
        iconEmoji: '📚',
        target: 10,
        current: 6,
        unit: 'pages',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        color: AppColors.ideas,
        streakDays: 5,
      ),
      PersonalGoal(
        id: 'g4',
        title: 'Exercise',
        iconEmoji: '💪',
        target: 4,
        current: 3,
        unit: 'times/wk',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        color: AppColors.error,
        streakDays: 3,
      ),
    ];
  }

  // ===== Points Transactions =====
  static List<PointsTransaction> getPointsHistory() {
    final now = DateTime.now();
    return [
      PointsTransaction(
        id: 't1',
        actionType: 'STEPS_DAILY',
        description: '7,842 steps today',
        amount: 78,
        timestamp: now.subtract(const Duration(minutes: 30)),
        iconEmoji: '👟',
      ),
      PointsTransaction(
        id: 't2',
        actionType: 'WATER_GOAL',
        description: 'Water goal met',
        amount: 20,
        timestamp: now.subtract(const Duration(hours: 2)),
        iconEmoji: '💧',
      ),
      PointsTransaction(
        id: 't3',
        actionType: 'CHALLENGE_PROGRESS',
        description: 'Marathon Month progress',
        amount: 50,
        timestamp: now.subtract(const Duration(hours: 5)),
        iconEmoji: '🏆',
      ),
      PointsTransaction(
        id: 't4',
        actionType: 'ANSWER_HELPFUL',
        description: 'Your answer was accepted',
        amount: 100,
        timestamp: now.subtract(const Duration(days: 1)),
        iconEmoji: '✅',
      ),
      PointsTransaction(
        id: 't5',
        actionType: 'EVENT_ATTENDED',
        description: 'Attended Yoga Session',
        amount: 100,
        timestamp: now.subtract(const Duration(days: 2)),
        iconEmoji: '🧘',
      ),
      PointsTransaction(
        id: 't6',
        actionType: 'REDEMPTION',
        description: 'Redeemed Lunch Voucher',
        amount: -4000,
        timestamp: now.subtract(const Duration(days: 3)),
        iconEmoji: '🍕',
      ),
    ];
  }

  // ===== Notifications =====
  static List<AppNotification> getNotifications() {
    final now = DateTime.now();
    return [
      AppNotification(
        id: 'n1',
        title: 'New Challenge!',
        body: 'Weekend Warrior starts in 3 days. Be ready.',
        iconEmoji: '⚡',
        time: now.subtract(const Duration(minutes: 15)),
        color: AppColors.secondary,
      ),
      AppNotification(
        id: 'n2',
        title: 'Coffee match found',
        body: 'You\'re paired with Vikram Singh this week.',
        iconEmoji: '☕',
        time: now.subtract(const Duration(hours: 2)),
        color: AppColors.coffee,
      ),
      AppNotification(
        id: 'n3',
        title: 'Points earned',
        body: '+78 points for today\'s steps.',
        iconEmoji: '⭐',
        time: now.subtract(const Duration(hours: 4)),
        color: AppColors.accent,
        read: true,
      ),
      AppNotification(
        id: 'n4',
        title: 'Your idea got 50 upvotes!',
        body: 'Quiet rooms for deep work is trending.',
        iconEmoji: '💡',
        time: now.subtract(const Duration(days: 1)),
        color: AppColors.ideas,
        read: true,
      ),
    ];
  }
}
