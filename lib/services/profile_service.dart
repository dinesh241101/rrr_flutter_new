import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';

class ProfileService {
  final supabase = Supabase.instance.client;

  /// FETCH PROFILE
  Future<ProfileModel?> fetchProfile() async {
    final user = supabase.auth.currentUser;

    if (user == null) return null;

    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (response == null) return null;

    return ProfileModel.fromJson(response);
  }

  /// CREATE PROFILE
  Future<void> createProfile({
    required String username,
    required String email,
    required int mobile,
  }) async {
    final user = supabase.auth.currentUser;

    if (user == null) return;

    await supabase.from('profiles').insert({
      'id': user.id,
      'username': username,
      'email': email,
      'mobile_number': mobile,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
      'is_verified': false,
    });
  }

  /// UPDATE PROFILE
  Future<void> updateProfile({
    String? username,
    String? bio,
    String? avatarUrl,
  }) async {
    final user = supabase.auth.currentUser;

    if (user == null) return;

    await supabase.from('profiles').update({
      'username': username,
      'bio': bio,
      'avatar_url': avatarUrl,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', user.id);
  }

  /// LOGOUT
  Future<void> logout() async {
    await supabase.auth.signOut();
  }
}