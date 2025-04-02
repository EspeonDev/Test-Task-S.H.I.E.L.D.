import 'package:cloud_firestore/cloud_firestore.dart';

class Mission {
  final String id;
  final String name;
  final String location;
  final String threatLevel;
  String status;
  String team;

  Mission({
    required this.id,
    required this.name,
    required this.location,
    required this.threatLevel,
    required this.status,
    required this.team,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'threatLevel': threatLevel,
      'status': status,
      'team': team,
    };
  }

  factory Mission.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Mission(
      id: doc.id,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      threatLevel: data['threatLevel'] ?? '',
      status: data['status'] ?? 'Available',
      team: data['team'] ?? 'Not assigned',
    );
  }
}

// Заглушка
class MissionRepository {
  static List<Mission> availableMissions = [
    Mission(
      id: '1',
      name: 'Recover 0-8-4 Artifact',
      location: 'Peru',
      threatLevel: 'High',
      status: 'Available',
      team: 'Not assigned',
    ),
    Mission(
      id: '2',
      name: 'Monitor Inhuman Activity',
      location: 'New York',
      threatLevel: 'Medium',
      status: 'Available',
      team: 'Not assigned',
    ),
    Mission(
      id: '3',
      name: 'Intercept Hydra Operatives',
      location: 'Berlin',
      threatLevel: 'High',
      status: 'Available',
      team: 'Not assigned',
    ),
    Mission(
      id: '4',
      name: 'Secure Alien Technology',
      location: 'Siberia',
      threatLevel: 'Critical',
      status: 'Available',
      team: 'Not assigned',
    ),
    Mission(
      id: '5',
      name: 'Protect VIP Scientist',
      location: 'Washington, D.C.',
      threatLevel: 'Medium',
      status: 'Available',
      team: 'Not assigned',
    ),
    Mission(
      id: '6',
      name: 'Investigate Energy Surge',
      location: 'Tokyo',
      threatLevel: 'High',
      status: 'Available',
      team: 'Not assigned',
    ),
    Mission(
      id: '7',
      name: 'Operation: AIM Facility',
      location: 'London',
      threatLevel: 'Medium',
      status: 'Available',
      team: 'Not assigned',
    ),
    Mission(
      id: '8',
      name: 'Neutralize Rogue LMDs',
      location: 'San Francisco',
      threatLevel: 'High',
      status: 'Available',
      team: 'Not assigned',
    ),
    Mission(
      id: '9',
      name: 'Retrieve Stolen Data',
      location: 'Paris',
      threatLevel: 'Medium',
      status: 'Available',
      team: 'Not assigned',
    ),
    Mission(
      id: '10',
      name: 'Radiation Anomaly',
      location: 'Chernobyl',
      threatLevel: 'Critical',
      status: 'Available',
      team: 'Not assigned',
    ),
  ];

  static List<Mission> myMissions = [];
}
