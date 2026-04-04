import 'package:flutter/material.dart';

class UserProfile {
  final String id;
  final String? username;
  final String? email;
  final String? avatarUrl;
  final String? bio;
  final String? mobileNumber;
  final bool isVerified;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    this.username,
    this.email,
    this.avatarUrl,
    this.bio,
    this.mobileNumber,
    this.isVerified = false,
    required this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      username: json['username'] as String?,
      email: json['email'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      bio: json['bio'] as String?,
      mobileNumber: json['mobile_number'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'avatar_url': avatarUrl,
    'bio': bio,
    'mobile_number': mobileNumber,
    'is_verified': isVerified,
    'created_at': createdAt.toIso8601String(),
  };
}

class ProfileProvider extends ChangeNotifier {
  UserProfile? _profile;
  bool _isLoading = false;
  String? _error;

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _profile != null;

  Future<void> setProfile(UserProfile profile) async {
    _profile = profile;
    _error = null;
    notifyListeners();
  }

  Future<void> updateProfile({
    String? username,
    String? email,
    String? avatarUrl,
    String? bio,
    String? mobileNumber,
  }) async {
    if (_profile == null) return;

    _profile = UserProfile(
      id: _profile!.id,
      username: username ?? _profile!.username,
      email: email ?? _profile!.email,
      avatarUrl: avatarUrl ?? _profile!.avatarUrl,
      bio: bio ?? _profile!.bio,
      mobileNumber: mobileNumber ?? _profile!.mobileNumber,
      isVerified: _profile!.isVerified,
      createdAt: _profile!.createdAt,
    );
    notifyListeners();
  }

  void clearProfile() {
    _profile = null;
    _error = null;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }
}
