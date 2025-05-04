import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_life/views/teacherSchedule.dart';

void main() {
  group('TeacherSchedule Widget Tests', () {
    testWidgets('should render all UI components correctly', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Teacherschedule(),
        ),
      );
      await tester.pump();

      // Assert - перевіряємо основні елементи UI
      expect(find.text('Розклад занять для викладачів'), findsOneWidget);
      expect(
        find.text('Для перегляду результатів введіть у поле "Розклад" значення ПІБ повністю'),
        findsOneWidget,
      );
      expect(find.byType(TextField), findsOneWidget); // Поле пошуку
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.text('Розклад...'), findsOneWidget);
    });

    testWidgets('should have back button that navigates back', (WidgetTester tester) async {
      // Arrange
      bool didPop = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Teacherschedule(),
          navigatorObservers: [
            TestNavigatorObserver(onPop: () {
              didPop = true;
            }),
          ],
        ),
      );
      await tester.pump();

      // Act - натискаємо кнопку "Назад"
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Assert - перевіряємо, що відбулося повернення назад
      expect(didPop, isTrue);
    });

    testWidgets('search field should accept input', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Teacherschedule(),
        ),
      );
      await tester.pump();

      // Act - вводимо текст у поле пошуку
      const testInput = 'Петренко Іван Миколайович';
      await tester.enterText(find.byType(TextField), testInput);
      await tester.pump();

      // Assert - перевіряємо, що текст був введений у поле
      expect(find.text(testInput), findsOneWidget);
    });

    testWidgets('should have correct styling for search field', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Teacherschedule(),
        ),
      );
      await tester.pump();

      // Знаходимо поле вводу
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      // Отримуємо об'єкт віджета
      final TextField textFieldWidget = tester.widget(textField);

      // Assert - перевіряємо стилі та властивості поля
      expect(textFieldWidget.decoration?.prefixIcon, isA<Icon>());
      expect(textFieldWidget.decoration?.hintText, equals('Розклад...'));
      expect(textFieldWidget.decoration?.filled, isTrue);
      expect(textFieldWidget.decoration?.fillColor, equals(Color(0xFFD1E7FF)));

      // Перевіряємо тип клавіатури
      expect(textFieldWidget.keyboardType, equals(TextInputType.text));

      // Перевіряємо стиль границі
      final borderRadius = (textFieldWidget.decoration?.border as OutlineInputBorder).borderRadius;
      expect(borderRadius, equals(BorderRadius.circular(20)));

      // Перевіряємо відсутність границі
      expect((textFieldWidget.decoration?.border as OutlineInputBorder).borderSide, equals(BorderSide.none));
    });

    testWidgets('should have background color set to light gray', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Teacherschedule(),
        ),
      );
      await tester.pump();

      // Знаходимо Scaffold
      final scaffold = find.byType(Scaffold);
      expect(scaffold, findsOneWidget);

      // Отримуємо об'єкт віджета
      final Scaffold scaffoldWidget = tester.widget(scaffold);

      // Assert - перевіряємо колір фону
      expect(scaffoldWidget.backgroundColor, equals(Colors.grey[200]));
    });

    testWidgets('should have correct app bar styling', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Teacherschedule(),
        ),
      );
      await tester.pump();

      // Знаходимо AppBar
      final appBar = find.byType(AppBar);
      expect(appBar, findsOneWidget);

      // Отримуємо об'єкт віджета
      final AppBar appBarWidget = tester.widget(appBar);

      // Assert - перевіряємо стилі AppBar
      expect(appBarWidget.backgroundColor, equals(Colors.grey[200]));
      expect(appBarWidget.elevation, equals(0));
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
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