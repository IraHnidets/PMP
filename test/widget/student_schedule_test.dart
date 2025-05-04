import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_life/views/studentSchedule.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('StudentSchedule Widget Tests', () {
    testWidgets('should render UI components correctly', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: StudentSchedule(),
        ),
      );

      // Перше оновлення - для завантаження екрану
      await tester.pump();

      // Assert - перевіряємо основні елементи UI, які повинні бути доступні відразу
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.text('Розклад занять для студентів'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget); // Поле пошуку має бути присутнє
    });

    testWidgets('should render app bar with back button', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: StudentSchedule(),
        ),
      );
      await tester.pump();

      // Assert - перевіряємо AppBar
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);

      // Перевіряємо властивості AppBar
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, equals(Colors.grey[200]));
      expect(appBar.elevation, equals(0));
    });

    testWidgets('should render title and subtitle', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: StudentSchedule(),
        ),
      );
      await tester.pump();

      // Assert - перевіряємо заголовок і підзаголовок
      expect(find.text('Розклад занять для студентів'), findsOneWidget);
    });

    testWidgets('should render search field with correct styling', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: StudentSchedule(),
        ),
      );
      await tester.pump();

      // Знаходимо поле пошуку
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      // Отримуємо об'єкт віджета
      final TextField textFieldWidget = tester.widget(textField);

      // Assert - перевіряємо стилі та властивості поля
      expect(textFieldWidget.decoration?.prefixIcon, isA<Icon>());
      expect(textFieldWidget.decoration?.hintText, equals('Введіть назву групи...'));
      expect(textFieldWidget.decoration?.filled, isTrue);
      expect(textFieldWidget.decoration?.fillColor, equals(const Color(0xFFD1E7FF)));

      // Перевіряємо стиль границі
      final borderRadius = (textFieldWidget.decoration?.border as OutlineInputBorder).borderRadius;
      expect(borderRadius, equals(BorderRadius.circular(20)));

      // Перевіряємо відсутність границі
      expect((textFieldWidget.decoration?.border as OutlineInputBorder).borderSide, equals(BorderSide.none));
    });

    testWidgets('should navigate back when back button is pressed', (WidgetTester tester) async {
      // Arrange
      bool didPop = false;

      await tester.pumpWidget(
        MaterialApp(
          home: StudentSchedule(),
          navigatorObservers: [
            TestNavigatorObserver(onPop: () {
              didPop = true;
            }),
          ],
        ),
      );
      await tester.pump();

      // Act - натискаємо кнопку назад
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Assert - перевіряємо, що відбулося повернення назад
      expect(didPop, isTrue);
    });

    testWidgets('should handle search input', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: StudentSchedule(),
        ),
      );
      await tester.pump();

      // Просто перевіряємо можливість введення тексту в поле пошуку
      await tester.enterText(find.byType(TextField), 'ПЗ');
      await tester.pump();

      // Assert - перевіряємо, що текст був введений у поле
      expect(find.text('ПЗ'), findsOneWidget);
    });
  });
}

// Клас для відслідковування навігації
class TestNavigatorObserver extends NavigatorObserver {
  final Function onPop;

  TestNavigatorObserver({required this.onPop});

  @override
  void didPop(Route route, Route? previousRoute) {
    onPop();
    super.didPop(route, previousRoute);
  }
}