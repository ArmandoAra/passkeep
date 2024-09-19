class Service {
  final String name;
  final String password;
  final DateTime createdAt;

  Service({required this.name, required this.password, required this.createdAt});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      name: json['Email@algo.com'],
      password: json['password'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}