import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:student_life/views/GroupScheduleScreen.dart';
import 'package:student_life/views/NotesCategoriesScreen.dart';
import 'package:student_life/views/AddEventScreen.dart';
import '../services/reminder_service.dart';
import '../models/reminder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  int _currentNavIndex = 3;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, List<Reminder>> _events = {};
  List<Reminder> _reminders = [];

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final loadedReminders = await ReminderService.fetchReminders(userId);

      setState(() {
        _reminders = loadedReminders;
        _events = {};

        // Групуємо нагадування за датами
        for (var reminder in _reminders) {
          DateTime dateOnly = DateTime(
            reminder.dateTime.year,
            reminder.dateTime.month,
            reminder.dateTime.day,
          );

          if (_events[dateOnly] == null) {
            _events[dateOnly] = [];
          }
          _events[dateOnly]!.add(reminder);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        // title: Text(
        //   'ПЗ-32',
        //   style: TextStyle(
        //     fontSize: 24,
        //     fontWeight: FontWeight.bold,
        //     color: Colors.black,
        //   ),
        // ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications_outlined, color: Colors.black),
                onPressed: () {
                  Navigator.pushNamed(context, '/RemindersScreen');
                },
              ),
              // Індикатор нових повідомлень
              if (_reminders.any((reminder) => !reminder.isDone))
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16),
            child: _buildCalendar(),
          ),
          // Вкладка для відображення подій
          Expanded(
            child: _buildEventList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF526FAA),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showAddEventBottomSheet(),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      eventLoader: (day) {
        return _events[day] ?? [];
      },
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Color(0xFF526FAA).withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Color(0xFF526FAA),
          shape: BoxShape.circle,
        ),
        markerDecoration: BoxDecoration(
          color: Color(0xFF526FAA),
          shape: BoxShape.circle,
        ),
        markerSize: 7,
        markersMaxCount: 1,
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
        rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: Colors.black),
        weekendStyle: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildEventList() {
    List<Reminder> selectedDayReminders = _events[_selectedDay] ?? [];

    if (selectedDayReminders.isEmpty) {
      return Center(
        child: Text(
          'Немає подій у цей день',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: selectedDayReminders.length,
      itemBuilder: (context, index) {
        final reminder = selectedDayReminders[index];
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _getEventColor(reminder.title),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminder.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (reminder.subtitle.isNotEmpty) ...[
                      SizedBox(height: 4),
                      Text(
                        reminder.subtitle,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Text(
                DateFormat('HH:mm').format(reminder.dateTime),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getEventColor(String title) {
    if (title.toLowerCase().contains('зустріч')) {
      return Colors.orange[100]!;
    } else if (title.toLowerCase().contains('завдання')) {
      return Colors.green[100]!;
    } else {
      return Colors.blue[100]!;
    }
  }

  void _showAddEventBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: AddEventScreen(selectedDate: _selectedDay),
      ),
    ).then((value) {
      // Якщо подію було створено, оновлюємо список
      if (value == true) {
        _loadReminders();
      }
    });
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentNavIndex,
      selectedItemColor: Colors.purple,
      unselectedItemColor: Colors.black,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        setState(() {
          _currentNavIndex = index;
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/NotesCategoriesScreen');
              break;
            case 1:
              Navigator.pushNamed(context, '/RemindersScreen');
              break;
            case 2:
              _navigateToGroupSchedule(context, "ПЗ-31");
              break;
            case 3:
              break;
            case 4:
              Navigator.pushNamed(context, '/MapScreen');
              break;
          }
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.note_outlined),
          activeIcon: Icon(Icons.note),
          label: "Нотатки",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_outlined),
          activeIcon: Icon(Icons.notifications),
          label: "Нагадування",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.schedule_outlined),
          activeIcon: Icon(Icons.schedule),
          label: "Розклад",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today_outlined),
          activeIcon: Icon(Icons.calendar_today),
          label: "Календар",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map_outlined),
          activeIcon: Icon(Icons.map),
          label: "Карта",
        ),
      ],
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