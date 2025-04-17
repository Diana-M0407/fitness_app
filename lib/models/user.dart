class User {
  final String id;
  final String username;
  final String email;
  final String password;
  final Profile profile;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.profile,
  });
}


class Profile {
  final String fullName;
  final double height;
  final double weight;
  final String phone;
  final bool disability;

  Profile({
    required this.fullName,
    required this.height,
    required this.weight,
    required this.phone,
    required this.disability,
  });
}