import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:student_life/views/teacherSchedule.dart';
import 'package:student_life/views/GroupScheduleScreen.dart';
import 'package:student_life/views/CalendarScreen.dart';
import 'views/studentSchedule.dart';
import 'package:student_life/views/NotesCategoriesScreen.dart';
import 'views/RemindersScreen.dart';
import 'views/MapScreen.dart';
import 'views/login_screen.dart';
import 'views/register_screen.dart';
import 'views/reset_password_screen.dart';
import 'theme/themes.dart';
import 'theme/theme_provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'views/AddEventScreen.dart';



// Оновлена функція main для коректної роботи з тестами
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  await Firebase.initializeApp();


  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/resetPasswordScreen': (context) => const ResetPasswordScreen(),
        '/': (context) => const HomeRouter(),
        '/studentSchedule': (context) => const StudentSchedule(),
        '/teacherSchedule': (context) => const Teacherschedule(),
        '/CalendarScreen': (context) => CalendarScreen(),
        '/NotesCategoriesScreen': (context) => NotesCategoriesScreen(),
        '/RemindersScreen': (context) => RemindersScreen(),
        '/MapScreen': (context) => MapScreen(),
        '/addEvent': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as DateTime;
          return AddEventScreen(selectedDate: args);
        },
        '/GroupScheduleScreen': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          return GroupScheduleScreen(groupName: args['groupName']!);
        },
      },
    );
  }
}

class HomeRouter extends StatefulWidget {
  const HomeRouter({Key? key}) : super(key: key);

  @override
  _HomeRouterState createState() => _HomeRouterState();
}

class _HomeRouterState extends State<HomeRouter> {
  String? _selectedRole;

  void _selectRole(String role) {
    setState(() {
      _selectedRole = role;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(80.0),
                  child: Text(
                    'Оберіть розклад, що Вас цікавить',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 25.0,
                        fontFamily: 'family_name',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(5.0, 5.0),
                            blurRadius: 10.0,
                            color: Color(0x80526FAA),
                          )
                        ]
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => _selectRole('student'),
                      child: _buildOptionCard(
                        'assets/images/Student.png',
                        'Студент',
                        isSelect: _selectedRole == 'student',
                      ),
                    ),
                    const SizedBox(width: 30),
                    GestureDetector(
                      onTap: () => _selectRole('teacher'),
                      child: _buildOptionCard(
                        'assets/images/Teacher.png',
                        'Викладач',
                        isSelect: _selectedRole == 'teacher',
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 100),  // Зменшено відступ з 200 до 100
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF526FAA),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    elevation: 10,
                    shadowColor: const Color(0x80526FAA),
                  ),
                  onPressed: _selectedRole == null ? null : () {
                    if(_selectedRole == 'student'){
                      Navigator.pushNamed(context, '/studentSchedule');
                    } else if(_selectedRole == 'teacher'){
                      Navigator.pushNamed(context, '/teacherSchedule');
                    }
                  },
                  child: const Text(
                    'Далі',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),  // Додано Spacer для розподілу простору
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(String img, String label, {bool isSelect = false}) {
    return Container(
      height: 120,
      width: 140,
      decoration: BoxDecoration(
        color: isSelect ? Colors.blue[300] : Colors.lightBlue[100],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
            color: isSelect ? Colors.blue : const Color(0xFF526FAA),
            width: 2
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x80526FAA),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(4,4),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            img,
            width: 50,  // Зменшено розмір
            height: 50, // Зменшено розмір
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.image,
                size: 40,
                color: isSelect ? Colors.white : const Color(0xFF526FAA),
              );
            },
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 18, // Зменшено розмір шрифту
              fontWeight: FontWeight.bold,
              color: isSelect ? Colors.white : const Color(0xFF526FAA),
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}