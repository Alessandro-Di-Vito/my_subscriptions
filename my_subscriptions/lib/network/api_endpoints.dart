abstract final class ApiEndpoints {
  // Auth
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const logout = '/auth/logout';
  static const refreshToken = '/auth/refresh';
  static const me = '/auth/me';
  static const forgotPassword = '/auth/forgot-password';
  static const resetPassword = '/auth/reset-password';

  // User
  static const userMe = '/users/me';
  static const userPreferences = '/users/me/preferences';
  static const completeOnboarding = '/users/me/complete-onboarding';
  static const userExport = '/users/me/export';

  // Categories
  static const categories = '/categories';

  // Subscriptions
  static const subscriptions = '/subscriptions';
  static String subscription(String id) => '/subscriptions/$id';
  static const subscriptionsUpcoming = '/subscriptions/upcoming';
  static const subscriptionsSummary = '/subscriptions/summary';
  static String subscriptionRenewals(String id) => '/subscriptions/$id/renewals';
  static String subscriptionCancel(String id) => '/subscriptions/$id/cancel';

  // Analytics
  static const analyticsByCategory = '/analytics/by-category';
  static const analyticsTop = '/analytics/top';
  static const analyticsMonthComparison = '/analytics/month-comparison';
  static const analyticsTrend = '/analytics/trend';
  static const analyticsCalendar = '/analytics/calendar';
}
