import 'package:drinklion/core/utils/logger.dart';

/// Service to manage current user context
class UserContextService {
  static final UserContextService _instance = UserContextService._internal();

  String? _currentUserId;

  UserContextService._internal();

  factory UserContextService() {
    return _instance;
  }

  /// Get current user ID
  String? getCurrentUserId() => _currentUserId;

  /// Set current user ID (called after login/signup)
  void setCurrentUserId(String userId) {
    _currentUserId = userId;
    logger.t('Current user set: $userId');
  }

  /// Clear current user ID (called on logout)
  void clearCurrentUser() {
    _currentUserId = null;
    logger.t('Current user cleared');
  }

  /// Check if user is logged in
  bool isUserLoggedIn() => _currentUserId != null;
}
