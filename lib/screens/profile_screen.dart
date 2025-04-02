import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shield_command_center/constants/app_style.dart';
import 'package:shield_command_center/models/mission_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _showFuryAlert = false;

  @override
  void initState() {
    super.initState();
    _checkMissionsLimit();
  }

  void _checkMissionsLimit() {
    if (MissionRepository.myMissions.length >= 5 && !_showFuryAlert) {
      setState(() {
        _showFuryAlert = true;
      });
      HapticFeedback.heavyImpact();

      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          setState(() {
            _showFuryAlert = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final fatigueLevel = MissionRepository.myMissions.length / 5;
    final heroName = "Spider-Man";
    final heroImage = "assets/imgs/spiderman2.png";
    final heroCodeName = "Peter Parker";
    final clearanceLevel = "Level 7";
    final joinedDate = "Joined: 2023 05 15";

    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppStyles.primaryColor,
          appBar: AppBar(
            title: const Text(
              'Agent Profile',
              style: AppStyles.appBarTextStyle,
            ),
            backgroundColor: AppStyles.primaryColor,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeroCard(
                  context,
                  heroName,
                  heroCodeName,
                  clearanceLevel,
                  joinedDate,
                  fatigueLevel,
                  heroImage,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'My Missions',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Chip(
                        label: Text(
                          '${MissionRepository.myMissions.length}/5',
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor:
                            fatigueLevel >= 1
                                ? Colors.red
                                : fatigueLevel >= 0.8
                                ? Colors.orange
                                : Colors.green,
                      ),
                    ],
                  ),
                ),

                MissionRepository.myMissions.isEmpty
                    ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'No active missions. Visit Missions screen to accept new assignments.',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    )
                    : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: MissionRepository.myMissions.length,
                      itemBuilder: (context, index) {
                        final mission = MissionRepository.myMissions[index];
                        return _buildMissionCard(mission);
                      },
                    ),
              ],
            ),
          ),
        ),

        if (_showFuryAlert) _buildFuryAlert(context),
      ],
    );
  }

  Widget _buildHeroCard(
    BuildContext context,
    String name,
    String codeName,
    String clearance,
    String joined,
    double fatigue,
    String imagePath,
  ) {
    return Card(
      margin: const EdgeInsets.all(16),
      color: const Color(0xFF2E2E2E),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(imagePath),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        codeName,
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Clearance: $clearance",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(joined, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "SUPERHERO ENERGY METER",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 12,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: fatigue,
                  minHeight: 10,
                  backgroundColor: Colors.grey[800],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    fatigue >= 1
                        ? Colors.red
                        : fatigue >= 0.8
                        ? Colors.orange
                        : Colors.green,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  fatigue >= 1
                      ? "CRITICAL FATIGUE! Need rest"
                      : fatigue >= 0.8
                      ? "High fatigue - consider dropping missions"
                      : "Energy levels stable",
                  style: TextStyle(
                    color:
                        fatigue >= 1
                            ? Colors.red
                            : fatigue >= 0.8
                            ? Colors.orange
                            : Colors.green,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionCard(Mission mission) {
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
                Expanded(
                  child: Text(
                    mission.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.timelapse, size: 16, color: Colors.blueAccent),
                const SizedBox(width: 5),
                Text(
                  'Status: ${mission.status}',
                  style: const TextStyle(color: Colors.blueAccent),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.redAccent),
                  onPressed: () {
                    _dropMission(mission);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFuryAlert(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.9),
          border: const Border(bottom: BorderSide(color: Colors.red, width: 2)),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/imgs/fury.png'),
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'DIRECTOR FURY',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Text(
                    'Agent! You have ${MissionRepository.myMissions.length} active missions. '
                    'Even Avengers have limits. Drop some missions immediately!',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                setState(() {
                  _showFuryAlert = false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _dropMission(Mission mission) {
    setState(() {
      MissionRepository.myMissions.remove(mission);
      MissionRepository.availableMissions.add(
        Mission(
          id: mission.id,
          name: mission.name,
          location: mission.location,
          threatLevel: mission.threatLevel,
          status: 'Available',
          team: 'Not assigned',
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mission "${mission.name}" dropped'),
        backgroundColor: Colors.blue,
      ),
    );

    if (MissionRepository.myMissions.length < 5) {
      setState(() {
        _showFuryAlert = false;
      });
    }
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
