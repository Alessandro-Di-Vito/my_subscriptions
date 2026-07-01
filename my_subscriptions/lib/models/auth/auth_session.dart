class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    this.displayName,
    required this.role,
  });

  final String id;
  final String email;
  final String? displayName;
  final String role;

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      role: json['role'] as String? ?? 'USER',
    );
  }
}

class AuthSession {
  const AuthSession({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.tokenId,
  });

  final AuthUser user;
  final String accessToken;
  final String refreshToken;
  final String tokenId;

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      user: AuthUser.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      tokenId: json['tokenId'] as String,
    );
  }
}
