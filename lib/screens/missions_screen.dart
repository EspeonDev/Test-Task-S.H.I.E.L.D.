import 'package:flutter/material.dart';
import 'package:shield_command_center/constants/app_style.dart';
import 'package:shield_command_center/models/mission_model.dart';

class MissionsScreen extends StatefulWidget {
  const MissionsScreen({super.key});

  @override
  State<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends State<MissionsScreen> {
  void _takeMission(Mission mission) {
    setState(() {
      MissionRepository.availableMissions.remove(mission);
      MissionRepository.myMissions.add(
        Mission(
          id: mission.id,
          name: mission.name,
          location: mission.location,
          threatLevel: mission.threatLevel,
          status: 'In Progress',
          team: 'My Team',
        ),
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mission "${mission.name}" accepted!')),
    );
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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: MissionRepository.availableMissions.length,
        itemBuilder: (context, index) {
          final mission = MissionRepository.availableMissions[index];
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
