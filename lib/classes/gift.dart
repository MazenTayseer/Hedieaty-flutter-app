class Gift {
  final String name;
  final String description;
  final String category;
  final double price;
  final String status;
  final String eventId;

  Gift({
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.status,
    required this.eventId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'status': status,
      'event_id': eventId,
    };
  }
}