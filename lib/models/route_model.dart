

class RouteModel {
  final String id;
  final String name;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final int distance;
  final String origin;
  final String destination;

  RouteModel({
    required this.id,
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
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      distance: int.parse(json['distance'].toString().replaceAll(' km', '')),
      origin: json['origin'] ?? '',
      destination: json['destination'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'distance': '$distance km',
      'origin': origin,
      'destination': destination,
    };
  }
} 