import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:student_life/theme/theme_provider.dart';

class BlinkingNotificationIcon extends StatefulWidget {
  @override
  _BlinkingNotificationIconState createState() => _BlinkingNotificationIconState();
}

class _BlinkingNotificationIconState extends State<BlinkingNotificationIcon> {
  bool _showIndicator = true;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _showIndicator = !_showIndicator;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.black, size: 28),
          onPressed: () {
            Navigator.pushNamed(context, '/RemindersScreen');
          },
        ),
        if (_showIndicator)
          Positioned(
            right: 10,
            top: 10,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}

class GroupScheduleScreen extends StatefulWidget {
  final String groupName;
  const GroupScheduleScreen({Key? key, required this.groupName}) : super(key: key);

  @override
  _GroupScheduleScreenState createState() => _GroupScheduleScreenState();
}

class _GroupScheduleScreenState extends State<GroupScheduleScreen> {
  int _selectedDayIndex = 1;
  int _currentNavIndex = 2;
  bool _isLoading = true;
  Map<String, dynamic>? _scheduleData;
  final List<String> _weekdays = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday'];

  @override
  void initState() {
    super.initState();
    _loadScheduleData();
  }

  Future<void> _loadScheduleData() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/database.json');
      final jsonData = json.decode(jsonString);

      setState(() {
        _scheduleData = jsonData['groups'][widget.groupName];
        _isLoading = false;
      });
    } catch (e) {
      print('Помилка завантаження даних: $e');
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Помилка завантаження розкладу: $e')),
      );
    }
  }

  void _onDaySelected(int index) {
    setState(() {
      _selectedDayIndex = index;
    });
  }

  List<Map<String, String>> _getLessonsForSelectedDay() {
    if (_scheduleData == null) return [];

    final dayKey = _weekdays[_selectedDayIndex];
    final daySchedule = _scheduleData!['schedule'][dayKey] ?? [];

    if (daySchedule is List) {
      return daySchedule.map<Map<String, String>>((lesson) {
        return {
          'timeStart': lesson['timeStart'] ?? '',
          'subject': lesson['subject'] ?? '',
          'teacher': lesson['teacher'] ?? '',
          'location': lesson['location'] ?? '',
          'timeEnd': lesson['timeEnd'] ?? '',
          'type': lesson['type'] ?? '',
        };
      }).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.groupName,
          style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          BlinkingNotificationIcon(),
        ],
        leading: IconButton(
          icon: Icon(
            context.watch<ThemeProvider>().isDarkMode ? Icons.dark_mode : Icons.light_mode,
            color: Theme.of(context).iconTheme.color,
            size: 30,
          ),
          onPressed: () {
            context.read<ThemeProvider>().toggleTheme();
          },
        ),

      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _scheduleData == null || _scheduleData!.isEmpty
          ? const Center(child: Text('Не вдалося завантажити розклад'))
          : Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            _buildWeekdaySelector(),
            const SizedBox(height: 15),
            Expanded(
              child: _getLessonsForSelectedDay().isEmpty
                  ? const Center(child: Text('Немає занять у цей день'))
                  : ListView(children: _buildScheduleCards()),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildWeekdaySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDayButton("ПН", 0),
        _buildDayButton("ВТ", 1),
        _buildDayButton("СР", 2),
        _buildDayButton("ЧТ", 3),
        _buildDayButton("ПТ", 4),
      ],
    );
  }

  Widget _buildDayButton(String label, int dayIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedDayIndex == dayIndex ? Colors.purple[300] : Colors.lightBlue[100],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
          minimumSize: const Size(40, 70),
          elevation: 7,
          shadowColor: Colors.grey,
        ),
        onPressed: () => _onDaySelected(dayIndex),
        child: Text(label, style: const TextStyle(color: Colors.black, fontSize: 16)),
      ),
    );
  }

  List<Widget> _buildScheduleCards() {
    final lessons = _getLessonsForSelectedDay();
    return lessons.map((lesson) {
      return _buildScheduleCard(
        lesson['timeStart']!,
        lesson['subject']!,
        lesson['teacher']!,
        '${lesson['location']} ${lesson['type']}',
        _getSubjectColor(lesson['subject']!),
        lesson['timeEnd']!,
      );
    }).toList();
  }

  Widget _buildScheduleCard(String timeStart, String subject, String teacher, String location, Color color, String timeEnd) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Text(timeStart, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(width: 2, height: 40, color: Colors.grey[600]),
                const SizedBox(height: 8),
                Text(timeEnd, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(subject, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.school, size: 18),
                      const SizedBox(width: 6),
                      Text(teacher, style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16),
                      const SizedBox(width: 6),
                      Text(location, style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.notifications, color: Colors.black),
          ],
        ),
      ),
    );
  }

  Color _getSubjectColor(String subjectName) {
    final colors = [
      const Color(0xFFbbd0ff),
      const Color(0xFFcce3de),
      const Color(0xFFb8c0ff),
      const Color(0xFFe7c6ff),
      const Color(0xFFc8b6ff),
    ];
    int hash = subjectName.runes.fold(0, (prev, char) => prev + char) * 31;
    return colors[hash.abs() % colors.length];
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentNavIndex,
      onTap: (index) {
        setState(() => _currentNavIndex = index);
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/NotesCategoriesScreen');
            break;
          case 1:
            Navigator.pushNamed(context, '/RemindersScreen');
            break;
          case 3:
            Navigator.pushNamed(context, '/CalendarScreen');
            break;
          case 4:
            Navigator.pushNamed(context, '/MapScreen');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.note), label: "Нотатки"),
        BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Нагадування"),
        BottomNavigationBarItem(icon: Icon(Icons.schedule), label: "Розклад"),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Календар"),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: "Карта"),
      ],
      selectedItemColor: Colors.purple,
      unselectedItemColor: Colors.black,
      type: BottomNavigationBarType.fixed,
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final IconData icon;
  final String title;

  const PlaceholderWidget({Key? key, required this.icon, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: Colors.grey),
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}