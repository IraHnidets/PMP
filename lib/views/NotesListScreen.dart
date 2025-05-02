import 'package:flutter/material.dart';

class NotesListScreen extends StatefulWidget {
  final String category;

  const NotesListScreen({required this.category});

  @override
  _NotesListScreenState createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  int _currentNavIndex = 0;

  final List<Map<String, String>> notes = [
    {'title': 'The beginning...', 'text': 'This is where your note will be.', 'date': '22.09.2025'},
    {'title': 'The job hard...', 'text': 'For athletes, high altitude...', 'date': '22.09.2025'},
    {'title': 'Dear design...', 'text': 'First published 11th June...', 'date': '22.09.2022'},
    {'title': 'Note.d', 'text': 'I’m a research-focused UX...', 'date': '22.09.2022'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNavBar(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back, size: 30),
                  ),
                  Text(
                    'Нотатки/${widget.category}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: Column(
                  children: [
                    Icon(Icons.add, size: 30, color: Color(0xFF526FAA)),
                    Text('Додати нотатку', style: TextStyle(color: Color(0xFF526FAA))),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 6)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(note['title']!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        SizedBox(height: 8),
                        Text(note['text']!, maxLines: 2, overflow: TextOverflow.ellipsis),
                        SizedBox(height: 8),
                        Text(note['date']!, style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentNavIndex,
      onTap: (index) {
        setState(() {
          _currentNavIndex = index;

          if (index == 0) {
            Navigator.pushNamed(context, '/NotesCategoriesScreen');
          }else if (index == 1) {
            Navigator.pushNamed(context, '/RemindersScreen');
          }else if (index == 4) {
            Navigator.pushNamed(context, '/MapScreen');
          }
        });
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
