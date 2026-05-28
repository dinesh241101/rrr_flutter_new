class ProfileModel {
  final String id;
  final String? username;
  final String? avatarUrl;
  final String? bio;
  final bool? isVerified;
  final int? mobileNumber;
  final String? email;

  ProfileModel({
    required this.id,
    this.username,
    this.avatarUrl,
    this.bio,
    this.isVerified,
    this.mobileNumber,
    this.email,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      username: json['username'],
      avatarUrl: json['avatar_url'],
      bio: json['bio'],
      isVerified: json['is_verified'],
      mobileNumber: json['mobile_number'],
      email: json['email'],
    );
  }
}