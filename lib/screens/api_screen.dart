import 'package:flutter/material.dart';
import 'package:shield_command_center/constants/app_style.dart';
import 'package:shield_command_center/models/cat_fact_model.dart';
import 'package:shield_command_center/services/api_service.dart';

class ApiScreen extends StatefulWidget {
  const ApiScreen({super.key});

  @override
  ApiScreenState createState() => ApiScreenState();
}

class ApiScreenState extends State<ApiScreen> {
  CatFact? _catFact;
  bool _isLoading = false;

  Future<void> _loadCatFact() async {
    setState(() => _isLoading = true);
    try {
      final fact = await fetchCatFact();
      setState(() => _catFact = fact);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppStyles.primaryColor,
        title: Text('Facts about cats', style: AppStyles.appBarTextStyle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_catFact != null)
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  _catFact!.fact,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            if (_isLoading)
              CircularProgressIndicator()
            else
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.withValues(alpha: 0.1),
                  foregroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.blueAccent),
                  ),
                ),
                onPressed: _loadCatFact,
                child: Text('Get Cat Fact'),
              ),
          ],
        ),
      ),
    );
  }
}
