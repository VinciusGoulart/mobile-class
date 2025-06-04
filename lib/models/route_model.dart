class RouteModel {
  final String id;
  final String userId;
  final String name;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final double distance;
  final String origin;
  final String destination;

  RouteModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.distance,
    required this.origin,
    required this.destination,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      distance: json['distance'].toDouble(),
      origin: json['origin'] ?? '',
      destination: json['destination'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'status': status,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'distance': distance,
      'origin': origin,
      'destination': destination,
    };
  }

  RouteModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    double? distance,
    String? origin,
    String? destination,
  }) {
    return RouteModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      distance: distance ?? this.distance,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
    );
  }
}
