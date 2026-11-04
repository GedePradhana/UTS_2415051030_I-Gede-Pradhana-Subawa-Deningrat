class Tenant {
  final int id;
  final String name; // nama panggilan, tampil di dashboard
  final String fullName;
  final int room;

  const Tenant({
    required this.id,
    required this.name,
    required this.fullName,
    required this.room,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) {
    return Tenant(
      id: json['id'] as int,
      name: json['name'] as String,
      fullName: json['full_name'] as String,
      room: json['room'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'full_name': fullName,
        'room': room,
      };
}