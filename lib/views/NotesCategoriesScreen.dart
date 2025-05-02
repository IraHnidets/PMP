import 'package:flutter/material.dart';
import 'NotesListScreen.dart';
import 'GroupScheduleScreen.dart';
class NotesCategoriesScreen extends StatefulWidget {
  @override
  State<NotesCategoriesScreen> createState() => _NotesCategoriesScreenState();
}

class _NotesCategoriesScreenState extends State<NotesCategoriesScreen> {
  int _currentNavIndex = 0;

  final List<Map<String, dynamic>> categories = [
    {'title': 'Особисті', 'count': 30, 'size': '56.1 MB'},
    {'title': 'Навчання', 'count': 102, 'size': '2.48 GB'},
    {'title': 'Робота', 'count': 300, 'size': '1.02 GB'},
    {'title': 'Інше', 'count': 201, 'size': '10.56 GB'},
  ];

  void _showAddNoteDialog(BuildContext context) {
    String category = 'Особисті';
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Додати нову нотатку'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: category,
                      items: categories.map<DropdownMenuItem<String>>((cat) {
                        return DropdownMenuItem<String>(
                          value: cat['title'] as String,
                          child: Text(cat['title'] as String),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          category = newValue!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Категорія',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Заголовок',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _contentController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'Вміст',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Скасувати'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final newNote = {
                      'title': _titleController.text,
                      'content': _contentController.text,
                      'category': category,
                      'date': DateTime.now().toString(),
                    };

                    final categoryIndex = categories.indexWhere((cat) => cat['title'] == category);
                    if (categoryIndex != -1) {
                      setState(() {
                        categories[categoryIndex]['count'] += 1;
                      });
                    }

                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Нотатку додано!')),
                    );
                  },
                  child: Text('Зберегти'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddNoteDialog(context),
        backgroundColor: Color(0xFF526FAA),
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Text('Нотатки', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  Spacer(),
                  Icon(Icons.person),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: categories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final item = categories[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NotesListScreen(category: item['title'] as String),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(blurRadius: 6, color: Colors.grey.shade300)],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.folder_open, color: Color(0xFF526FAA), size: 30),
                          Spacer(),
                          Text(
                            item['title'] as String,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text('${item['count']} файлів'),
                          SizedBox(height: 4),
                          Text(
                            'Розмір: ${item['size']}',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
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
          } else if (index == 3) {
            Navigator.pushNamed(context, '/CalendarScreen');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/RemindersScreen');
          } else if (index == 4) {
            Navigator.pushNamed(context, '/MapScreen');
          } else if (index == 2) {
          _navigateToGroupSchedule(context, "ПЗ-31");
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
  void _navigateToGroupSchedule(BuildContext context, String groupName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupScheduleScreen(groupName: groupName),
      ),
    );
  }

}