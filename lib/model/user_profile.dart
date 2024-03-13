class UserProfile {
  String? userId;
  final String phoneNumber;
  final String userEmail;
  String? profileName;

  UserProfile(
      {required this.phoneNumber,
      required this.userEmail,
      this.profileName,
      this.userId});
}
