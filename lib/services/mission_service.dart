import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shield_command_center/models/mission_model.dart';

class MissionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Mission>> getAvailableMissions() {
    return _firestore
        .collection('missions')
        .where('status', isEqualTo: 'Available')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Mission.fromFirestore(doc)).toList(),
        );
  }

  Stream<List<Mission>> getMyMissions(String teamId) {
    return _firestore
        .collection('missions')
        .where('team', isEqualTo: teamId)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Mission.fromFirestore(doc)).toList(),
        );
  }

  Future<void> updateMission(Mission mission) async {
    await _firestore
        .collection('missions')
        .doc(mission.id)
        .update(mission.toMap());
  }

  Future<void> addMission(Mission mission) async {
    await _firestore.collection('missions').add(mission.toMap());
  }
}
