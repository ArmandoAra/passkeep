class Service {
  final String? id;
  final String name;
  final String password;
  bool passVisible = false;
  final String createdAt;

  Service(
      {required this.id,
      required this.name,
      required this.password,
      required this.createdAt,
      this.passVisible = false});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['Email@algo.com'],
      password: json['password'],
      createdAt: '2021-09-01',
    );
  }
}
