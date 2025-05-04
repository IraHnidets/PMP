import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:student_life/views/NotesCategoriesScreen.dart';
import 'package:student_life/views/NotesListScreen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Notes Flow Integration Tests', () {
    testWidgets('Navigate to notes category', (WidgetTester tester) async {
      // Створюємо тестовий додаток
      await tester.pumpWidget(
        MaterialApp(
          home: NotesCategoriesScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Перевіряємо, що відображаються категорії
      expect(find.text('Особисті'), findsOneWidget);
      expect(find.text('Навчання'), findsOneWidget);

      // Натискаємо на категорію "Особисті"
      await tester.tap(find.text('Особисті'));
      await tester.pumpAndSettle();

      // Перевіряємо, що ми перейшли до списку нотаток
      expect(find.text('Нотатки/Особисті'), findsOneWidget);

      // Повертаємось назад
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Перевіряємо, що повернулись
      expect(find.text('Особисті'), findsOneWidget);
    });

    testWidgets('Open add note dialog', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: NotesCategoriesScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Натискаємо FAB
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Перевіряємо, що діалог відкрився
      expect(find.text('Додати нову нотатку'), findsOneWidget);
      expect(find.text('Скасувати'), findsOneWidget);
      expect(find.text('Зберегти'), findsOneWidget);

      // Закриваємо діалог
      await tester.tap(find.text('Скасувати'));
      await tester.pumpAndSettle();
    });
  });
}