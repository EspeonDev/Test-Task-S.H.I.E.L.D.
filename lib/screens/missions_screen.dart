import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shield_command_center/constants/app_style.dart';
import 'package:shield_command_center/models/mission_model.dart';

class MissionsScreen extends StatefulWidget {
  const MissionsScreen({super.key});

  @override
  State<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends State<MissionsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Mission> _availableMissions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMissions();
  }

  // Потім перенесу в mission_service але для вашого ревью залишу тут
  Future<void> _loadMissions() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore
              .collection('missions')
              .where('status', isEqualTo: 'Available')
              .get();

      setState(() {
        _availableMissions =
            querySnapshot.docs
                .map((doc) => Mission.fromFirestore(doc))
                .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading missions: $e')));
    }
  }

  // Потім перенесу в mission_service але для вашого ревью залишу тут
  Future<void> _takeMission(Mission mission) async {
    try {
      await _firestore.collection('missions').doc(mission.id).update({
        'status': 'In Progress',
        'team': 'My Team',
      });

      setState(() {
        _availableMissions.remove(mission);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mission "${mission.name}" accepted!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error accepting mission: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.primaryColor,
      appBar: AppBar(
        title: const Text(
          'Available Missions',
          style: AppStyles.appBarTextStyle,
        ),
        backgroundColor: AppStyles.primaryColor,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _availableMissions.length,
                itemBuilder: (context, index) {
                  final mission = _availableMissions[index];
                  return _buildMissionCard(
                    mission,
                    onTake: () => _takeMission(mission),
                  );
                },
              ),
    );
  }

  Widget _buildMissionCard(Mission mission, {required VoidCallback onTake}) {
    Color threatColor = _getThreatColor(mission.threatLevel);

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      color: const Color(0xFF2E2E2E),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  mission.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: threatColor.withValues(alpha: 0.2),
                    border: Border.all(color: threatColor),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    mission.threatLevel,
                    style: TextStyle(
                      color: threatColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 16,
                  color: Colors.blueAccent,
                ),
                const SizedBox(width: 5),
                Text(
                  mission.location,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: onTake,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.withValues(alpha: 0.1),
                foregroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Colors.blueAccent),
                ),
              ),
              child: const Text('ACCEPT MISSION'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getThreatColor(String threatLevel) {
    switch (threatLevel) {
      case 'Medium':
        return Colors.orange;
      case 'High':
        return Colors.red;
      case 'World-Ending':
        return Colors.purple;
      default:
        return Colors.green;
    }
  }
}
