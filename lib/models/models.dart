// Centralized data models for Pulse Engage
import 'package:flutter/material.dart';

enum UserRole { employee, admin, superAdmin }

class User {
  final String id;
  final String name;
  final String email;
  final String department;
  final String team;
  final String avatarUrl;
  final UserRole role;
  final int totalPoints;
  final int level;
  final int trustScore;
  final DateTime joinedAt;
  final String bio;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.department,
    required this.team,
    this.avatarUrl = '',
    this.role = UserRole.employee,
    this.totalPoints = 0,
    this.level = 1,
    this.trustScore = 100,
    DateTime? joinedAt,
    this.bio = '',
  }) : joinedAt = joinedAt ?? DateTime.now();

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts.first.substring(0, 1).toUpperCase();
  }
}

class StepRecord {
  final DateTime date;
  final int steps;
  final double distanceKm;
  final int caloriesBurned;
  final int activeMinutes;
  final int trustScore;

  StepRecord({
    required this.date,
    required this.steps,
    this.distanceKm = 0,
    this.caloriesBurned = 0,
    this.activeMinutes = 0,
    this.trustScore = 100,
  });
}

class WaterLog {
  final DateTime time;
  final int amountMl;

  WaterLog({required this.time, required this.amountMl});
}

enum ChallengeType { individual, team }
enum ChallengeStatus { upcoming, active, completed }
enum ChallengeFrequency { daily, weekly, monthly }

class Challenge {
  final String id;
  final String title;
  final String description;
  final String iconEmoji;
  final ChallengeType type;
  final ChallengeFrequency frequency;
  final ChallengeStatus status;
  final int targetValue;
  final int currentValue;
  final int pointsReward;
  final DateTime startDate;
  final DateTime endDate;
  final int participants;
  final String unit;
  final Color color;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.iconEmoji,
    required this.type,
    required this.frequency,
    required this.status,
    required this.targetValue,
    required this.currentValue,
    required this.pointsReward,
    required this.startDate,
    required this.endDate,
    required this.participants,
    required this.unit,
    required this.color,
  });

  double get progress =>
      targetValue == 0 ? 0 : (currentValue / targetValue).clamp(0.0, 1.0);

  int get daysRemaining => endDate.difference(DateTime.now()).inDays;
}

class LeaderboardEntry {
  final int rank;
  final User user;
  final int score;
  final int delta; // change in rank

  LeaderboardEntry({
    required this.rank,
    required this.user,
    required this.score,
    this.delta = 0,
  });
}

enum RewardCategory { voucher, merchandise, experience, timeOff, food }

class Reward {
  final String id;
  final String title;
  final String description;
  final String iconEmoji;
  final RewardCategory category;
  final int pointsCost;
  final int valueInRupees;
  final int stock;
  final bool isPopular;
  final Color color;

  Reward({
    required this.id,
    required this.title,
    required this.description,
    required this.iconEmoji,
    required this.category,
    required this.pointsCost,
    required this.valueInRupees,
    required this.stock,
    this.isPopular = false,
    required this.color,
  });
}

enum PostType { achievement, recognition, milestone, general, image }

class SocialPost {
  final String id;
  final User author;
  final String content;
  final PostType type;
  final DateTime createdAt;
  int likes;
  int comments;
  bool liked;
  final String? imageUrl;
  final String? badgeEmoji;
  final User? recognizedUser;

  SocialPost({
    required this.id,
    required this.author,
    required this.content,
    required this.type,
    required this.createdAt,
    this.likes = 0,
    this.comments = 0,
    this.liked = false,
    this.imageUrl,
    this.badgeEmoji,
    this.recognizedUser,
  });
}

enum EventStatus { upcoming, live, past }
enum EventCategory { workshop, hackathon, sports, wellness, social, training }

class Event {
  final String id;
  final String title;
  final String description;
  final EventCategory category;
  final EventStatus status;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final int capacity;
  final int registered;
  final int pointsReward;
  final String organizer;
  final String iconEmoji;
  final Color color;
  bool isRegistered;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.capacity,
    required this.registered,
    required this.pointsReward,
    required this.organizer,
    required this.iconEmoji,
    required this.color,
    this.isRegistered = false,
  });
}

class Doubt {
  final String id;
  final User author;
  final String title;
  final String content;
  final List<String> tags;
  final DateTime createdAt;
  int upvotes;
  int answerCount;
  bool hasAcceptedAnswer;
  bool upvoted;

  Doubt({
    required this.id,
    required this.author,
    required this.title,
    required this.content,
    required this.tags,
    required this.createdAt,
    this.upvotes = 0,
    this.answerCount = 0,
    this.hasAcceptedAnswer = false,
    this.upvoted = false,
  });
}

class Answer {
  final String id;
  final User author;
  final String content;
  final DateTime createdAt;
  int upvotes;
  bool isAccepted;

  Answer({
    required this.id,
    required this.author,
    required this.content,
    required this.createdAt,
    this.upvotes = 0,
    this.isAccepted = false,
  });
}

enum IdeaStatus { proposed, underReview, accepted, rejected, implemented }

class Idea {
  final String id;
  final User author;
  final String title;
  final String description;
  final String category;
  final DateTime createdAt;
  int upvotes;
  int comments;
  IdeaStatus status;
  bool upvoted;

  Idea({
    required this.id,
    required this.author,
    required this.title,
    required this.description,
    required this.category,
    required this.createdAt,
    this.upvotes = 0,
    this.comments = 0,
    this.status = IdeaStatus.proposed,
    this.upvoted = false,
  });
}

enum CoffeeStatus { pending, confirmed, met, skipped }

class CoffeeMatch {
  final String id;
  final User partner;
  final DateTime matchedAt;
  CoffeeStatus status;
  final String? meetingNote;

  CoffeeMatch({
    required this.id,
    required this.partner,
    required this.matchedAt,
    this.status = CoffeeStatus.pending,
    this.meetingNote,
  });
}

class PersonalGoal {
  final String id;
  final String title;
  final String iconEmoji;
  final int target;
  int current;
  final String unit;
  final DateTime createdAt;
  final Color color;
  int streakDays;

  PersonalGoal({
    required this.id,
    required this.title,
    required this.iconEmoji,
    required this.target,
    required this.current,
    required this.unit,
    required this.createdAt,
    required this.color,
    this.streakDays = 0,
  });

  double get progress =>
      target == 0 ? 0 : (current / target).clamp(0.0, 1.0);
}

class PointsTransaction {
  final String id;
  final String actionType;
  final String description;
  final int amount; // positive = earned, negative = spent
  final DateTime timestamp;
  final String iconEmoji;

  PointsTransaction({
    required this.id,
    required this.actionType,
    required this.description,
    required this.amount,
    required this.timestamp,
    required this.iconEmoji,
  });
}

class Notification {
  final String id;
  final String title;
  final String body;
  final String iconEmoji;
  final DateTime time;
  final Color color;
  bool read;

  Notification({
    required this.id,
    required this.title,
    required this.body,
    required this.iconEmoji,
    required this.time,
    required this.color,
    this.read = false,
  });
}
