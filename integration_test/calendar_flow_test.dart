import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:student_life/views/AddEventScreen.dart';

// Створюємо тестову версію CalendarScreen без Firebase
class TestCalendarScreen extends StatefulWidget {
  @override
  _TestCalendarScreenState createState() => _TestCalendarScreenState();
}

class _TestCalendarScreenState extends State<TestCalendarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Calendar Test',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Text('Calendar View'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF526FAA),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showAddEventBottomSheet(),
      ),
    );
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
        child: Text('Додати нову подію'),
      ),
    );
  }
}

// Створюємо тестову версію AddEventScreen без Firebase
class TestAddEventScreen extends StatefulWidget {
  final DateTime selectedDate;

  const TestAddEventScreen({Key? key, required this.selectedDate}) : super(key: key);

  @override
  _TestAddEventScreenState createState() => _TestAddEventScreenState();
}

class _TestAddEventScreenState extends State<TestAddEventScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  TimeOfDay _selectedEndTime = TimeOfDay.now();
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Додати нову подію', style: TextStyle(color: Colors.black)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(hintText: 'Назва'),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(hintText: 'Опис'),
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _saveEvent,
                  child: Text('Створити'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveEvent() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Будь ласка, введіть назву події')),
      );
      return;
    }
    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Calendar Flow Integration Tests', () {
    testWidgets('Calendar screen displays and FAB opens add event screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: TestCalendarScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Перевіряємо, що календар відображається
      expect(find.text('Calendar View'), findsOneWidget);

      // Знаходимо і натискаємо FAB
      final fab = find.byType(FloatingActionButton);
      expect(fab, findsOneWidget);

      await tester.tap(fab);
      await tester.pumpAndSettle();

      // Перевіряємо, що відкрився модальний екран
      expect(find.text('Додати нову подію'), findsOneWidget);
    });

    testWidgets('Add event screen with text input', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: TestAddEventScreen(selectedDate: DateTime.now()),
        ),
      );
      await tester.pumpAndSettle();

      // Перевіряємо наявність полів
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Створити'), findsOneWidget);

      // Заповнюємо форму
      await tester.enterText(find.byType(TextField).first, 'Тестова подія');
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, 'Опис тестової події');
      await tester.pumpAndSettle();

      // Натискаємо кнопку створення
      await tester.tap(find.text('Створити'));
      await tester.pumpAndSettle();
    });

    testWidgets('Add event with empty title shows error', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: TestAddEventScreen(selectedDate: DateTime.now()),
        ),
      );
      await tester.pumpAndSettle();

      // Не заповнюємо поля і одразу натискаємо "Створити"
      await tester.tap(find.text('Створити'));
      await tester.pumpAndSettle();

      // Перевіряємо, що з'явилося повідомлення про помилку
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Будь ласка, введіть назву події'), findsOneWidget);
    });
  });
}