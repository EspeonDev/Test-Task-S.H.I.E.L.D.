import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shield_command_center/models/mission_model.dart';

class MissionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Mission> _availableMissions = [];

  // тут вообще повинні бути функції роботи з місіями з фаербейсу але я залишив їх там можливо вам так буде зручніше.
}
