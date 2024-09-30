class Service {
  final String? id;
  final String name;
  final String password;
  final String createdAt;

  Service(
      {required this.id,
      required this.name,
      required this.password,
      required this.createdAt,
      });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service': name,
      'password': password,
      'createdAt': createdAt,
    };
  }

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['service'],
      password: json['password'],
      createdAt: json['createdAt'],
    );
  }

}
