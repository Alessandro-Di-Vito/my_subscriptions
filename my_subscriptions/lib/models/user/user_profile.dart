class UserPreferences {
  const UserPreferences({
    required this.defaultCurrency,
    this.reminderDaysDefault = 3,
    this.theme = 'SYSTEM',
    this.notificationsRenewal = true,
    this.notificationsTrial = true,
    this.notificationsSummary = false,
    this.summaryTime,
    this.onboardingCompletedAt,
  });

  final String defaultCurrency;
  final int reminderDaysDefault;
  final String theme;
  final bool notificationsRenewal;
  final bool notificationsTrial;
  final bool notificationsSummary;
  final String? summaryTime;
  final DateTime? onboardingCompletedAt;

  bool get isOnboardingCompleted => onboardingCompletedAt != null;

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      defaultCurrency: json['defaultCurrency'] as String? ?? 'EUR',
      reminderDaysDefault: json['reminderDaysDefault'] as int? ?? 3,
      theme: json['theme'] as String? ?? 'SYSTEM',
      notificationsRenewal: json['notificationsRenewal'] as bool? ?? true,
      notificationsTrial: json['notificationsTrial'] as bool? ?? true,
      notificationsSummary: json['notificationsSummary'] as bool? ?? false,
      summaryTime: json['summaryTime'] as String?,
      onboardingCompletedAt: json['onboardingCompletedAt'] != null
          ? DateTime.tryParse(json['onboardingCompletedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'defaultCurrency': defaultCurrency,
      'reminderDaysDefault': reminderDaysDefault,
      'theme': theme,
      'notificationsRenewal': notificationsRenewal,
      'notificationsTrial': notificationsTrial,
      'notificationsSummary': notificationsSummary,
      if (summaryTime != null) 'summaryTime': summaryTime,
    };
  }

  UserPreferences copyWith({
    String? defaultCurrency,
    int? reminderDaysDefault,
    String? theme,
    bool? notificationsRenewal,
    bool? notificationsTrial,
    bool? notificationsSummary,
    String? summaryTime,
    DateTime? onboardingCompletedAt,
  }) {
    return UserPreferences(
      defaultCurrency: defaultCurrency ?? this.defaultCurrency,
      reminderDaysDefault: reminderDaysDefault ?? this.reminderDaysDefault,
      theme: theme ?? this.theme,
      notificationsRenewal: notificationsRenewal ?? this.notificationsRenewal,
      notificationsTrial: notificationsTrial ?? this.notificationsTrial,
      notificationsSummary: notificationsSummary ?? this.notificationsSummary,
      summaryTime: summaryTime ?? this.summaryTime,
      onboardingCompletedAt:
          onboardingCompletedAt ?? this.onboardingCompletedAt,
    );
  }
}

class UserProfile {
  const UserProfile({
    required this.id,
    required this.email,
    this.displayName,
    required this.role,
    this.preferences,
  });

  final String id;
  final String email;
  final String? displayName;
  final String role;
  final UserPreferences? preferences;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      role: json['role'] as String? ?? 'USER',
      preferences: json['preferences'] != null
          ? UserPreferences.fromJson(
              json['preferences'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}
