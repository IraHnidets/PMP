import 'package:flutter/material.dart';
import 'package:student_life/views/GroupScheduleScreen.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class StudentSchedule extends StatefulWidget {
  const StudentSchedule({Key? key}) : super(key: key);

  @override
  _StudentScheduleState createState() => _StudentScheduleState();
}

class _StudentScheduleState extends State<StudentSchedule> {
  List<String> groups = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/database.json');
      final jsonData = json.decode(jsonString);

      setState(() {
        groups = jsonData['groups'].keys.cast<String>().toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Помилка завантаження груп: $e');
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Помилка завантаження списку груп: $e')),
      );
    }
  }

  List<String> get _filteredGroups {
    if (_searchQuery.isEmpty) return groups;
    return groups.where((group) => group.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.grey[200],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Розклад занять для студентів',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  shadows: [
                    Shadow(
                      offset: Offset(4.0, 4.0),
                      blurRadius: 10.0,
                      color: Color(0x80526FAA),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Color(0xFF526FAA), size: 30),
                hintText: 'Введіть назву групи...',
                hintStyle: const TextStyle(fontSize: 20),
                filled: true,
                fillColor: const Color(0xFFD1E7FF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredGroups.isEmpty
                  ? const Center(child: Text('Групи не знайдено', style: TextStyle(fontSize: 18)))
                  : ListView.builder(
                itemCount: _filteredGroups.length,
                itemBuilder: (context, index) => _buildGroupCard(context, groupName: _filteredGroups[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupCard(BuildContext context, {required String groupName}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        title: Text(
          groupName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF526FAA),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF526FAA)),
        onTap: () => _navigateToGroupSchedule(context, groupName),
      ),
    );
  }

  void _navigateToGroupSchedule(BuildContext context, String groupName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupScheduleScreen(groupName: groupName),
      ),
    );
  }
}