class Profile {
  final String name;
  final int age;
  final String email;

  Profile({required this.name, required this.age, required this.email});

  // Factory method to create a Profile from JSON
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'],
      age: json['age'],
      email: json['email'],
    );
  }

  // Method to convert Profile to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'email': email,
    };
  }
}
