class Event {
  final String name;
  final String location;
  final String description;
  final DateTime date;
  final String userId;

  Event({
    required this.name,
    required this.location,
    required this.description,
    required this.date,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'description': description,
      'date': date.toString(),
      'user_id': userId,
    };
  }
}