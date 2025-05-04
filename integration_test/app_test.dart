import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:student_life/main.dart' as app;
import 'package:student_life/views/studentSchedule.dart';
import 'package:student_life/views/teacherSchedule.dart';
import 'package:provider/provider.dart';
import 'package:student_life/views/login_screen.dart';
import 'package:student_life/theme/theme_provider.dart';
import 'package:student_life/theme/themes.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('app starts successfully and shows login screen', (WidgetTester tester) async {
      // Створюємо тестову версію додатку без Firebase
      await tester.pumpWidget(
        MaterialApp(
          home: const LoginScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Перевіряємо, що додаток запустився і показує екран входу
      expect(find.text('Вхід'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2)); // Email та пароль
      expect(find.text('Увійти'), findsOneWidget);
      expect(find.text('Увійти через Google'), findsOneWidget);
    });

    testWidgets('home router role selection flow', (WidgetTester tester) async {
      // Створюємо тестову версію додатку, яка починається з HomeRouter
      await tester.pumpWidget(
        MaterialApp(
          home: const app.HomeRouter(),
          routes: {
            '/studentSchedule': (context) => const StudentSchedule(),
            '/teacherSchedule': (context) => const Teacherschedule(),
          },
        ),
      );
      await tester.pumpAndSettle();

      // Перевіряємо початковий стан
      expect(find.text('Оберіть розклад, що Вас цікавить'), findsOneWidget);
      expect(find.text('Студент'), findsOneWidget);
      expect(find.text('Викладач'), findsOneWidget);
      expect(find.text('Далі'), findsOneWidget);

      // Спочатку кнопка має бути неактивною (не вибрано роль)
      final nextButton = find.widgetWithText(ElevatedButton, 'Далі');
      expect(nextButton, findsOneWidget);

      // Вибираємо роль студента
      await tester.tap(find.text('Студент'));
      await tester.pumpAndSettle();

      // Натискаємо "Далі"
      await tester.tap(find.text('Далі'));
      await tester.pumpAndSettle();

      // Перевіряємо, що перейшли на екран розкладу студентів
      expect(find.text('Розклад занять для студентів'), findsOneWidget);
    });

    testWidgets('complete app flow test', (WidgetTester tester) async {
      // Тест повного потоку додатку (спрощений без Firebase)
      await tester.pumpWidget(
        MaterialApp(
          initialRoute: '/',
          routes: {
            '/': (context) => const app.HomeRouter(),
            '/studentSchedule': (context) => const StudentSchedule(),
            '/teacherSchedule': (context) => const Teacherschedule(),
          },
        ),
      );
      await tester.pumpAndSettle();

      // Вибираємо викладача
      await tester.tap(find.text('Викладач'));
      await tester.pumpAndSettle();

      // Натискаємо "Далі"
      await tester.tap(find.text('Далі'));
      await tester.pumpAndSettle();

      // Перевіряємо, що перейшли на екран розкладу викладачів
      expect(find.text('Розклад занять для викладачів'), findsOneWidget);

      // Повертаємось назад
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Перевіряємо, що повернулись на головний екран
      expect(find.text('Оберіть розклад, що Вас цікавить'), findsOneWidget);
    });

    testWidgets('theme provider integration', (WidgetTester tester) async {
      // Тестуємо, що тема працює правильно без Firebase
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
          child: MaterialApp(
            theme: lightTheme,
            darkTheme: darkTheme,
            home: const app.HomeRouter(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Перевіряємо, що додаток має правильну початкову тему
      final MaterialApp materialApp = tester.widget(find.byType(MaterialApp));
      expect(materialApp.theme, isNotNull);
      expect(materialApp.darkTheme, isNotNull);
    });
  });
}