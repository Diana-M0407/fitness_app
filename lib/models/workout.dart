class Workout {
  final String title;
  final String description;
  final int duration; // in minutes

  Workout({required this.title, required this.description, required this.duration});

  // Factory method to create a Workout from JSON
  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      title: json['title'],
      description: json['description'],
      duration: json['duration'],
    );
  }

  // Method to convert Workout to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'duration': duration,
    };
  }
}
