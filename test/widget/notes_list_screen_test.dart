import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_life/views/NotesListScreen.dart';

void main() {
  group('NotesListScreen Widget Tests', () {
    testWidgets('should render all UI components correctly', (WidgetTester tester) async {
      // Arrange
      const testCategory = 'Особисті';

      await tester.pumpWidget(
        MaterialApp(
          home: NotesListScreen(category: testCategory),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - перевіряємо наявність всіх елементів UI
      expect(find.text('Нотатки/$testCategory'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.text('Додати нотатку'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('should display some notes in the list', (WidgetTester tester) async {
      // Arrange
      const testCategory = 'Особисті';

      await tester.pumpWidget(
        MaterialApp(
          home: NotesListScreen(category: testCategory),
        ),
      );
      await tester.pumpAndSettle();

      // Перевіряємо, що в списку відображаються нотатки
      // Знаходимо контейнери нотаток
      final containers = find.descendant(
        of: find.byType(ListView),
        matching: find.byType(Container),
      );

      // Перевіряємо, що є нотатки в списку
      expect(containers, findsWidgets);

      // Перевіряємо, що є нотатка з заголовком "The beginning..."
      // Ця нотатка має бути присутня у мок-даних
      expect(find.text('The beginning...'), findsOneWidget);
    });

    testWidgets('should navigate back when back button is pressed', (WidgetTester tester) async {
      // Arrange
      const testCategory = 'Особисті';
      bool didPop = false;

      await tester.pumpWidget(
        MaterialApp(
          home: NotesListScreen(category: testCategory),
          navigatorObservers: [
            TestNavigatorObserver(onPop: () {
              didPop = true;
            }),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Act - натискаємо кнопку назад
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Assert - перевіряємо, що відбулося повернення назад
      expect(didPop, isTrue);
    });

    testWidgets('notes should have correct styling', (WidgetTester tester) async {
      // Arrange
      const testCategory = 'Особисті';

      await tester.pumpWidget(
        MaterialApp(
          home: NotesListScreen(category: testCategory),
        ),
      );
      await tester.pumpAndSettle();

      // Знаходимо контейнери нотаток в ListView
      final containers = find.descendant(
        of: find.byType(ListView),
        matching: find.byType(Container),
      );

      // Перевіряємо, що контейнери існують
      expect(containers, findsWidgets);

      // Отримуємо перший контейнер для перевірки стилів
      if (containers.evaluate().isNotEmpty) {
        final Container container = tester.widget(containers.first);

        // Перевіряємо оформлення контейнера
        expect(container.decoration, isA<BoxDecoration>());

        final BoxDecoration decoration = container.decoration as BoxDecoration;

        // Перевіряємо граничний радіус
        expect(decoration.borderRadius, isA<BorderRadius>());

        // Перевіряємо наявність тіні
        expect(decoration.boxShadow, isNotNull);
      }
    });

    testWidgets('should display add note button', (WidgetTester tester) async {
      // Arrange
      const testCategory = 'Особисті';

      await tester.pumpWidget(
        MaterialApp(
          home: NotesListScreen(category: testCategory),
        ),
      );
      await tester.pumpAndSettle();

      // Знаходимо кнопку додавання нотатки
      final addNoteContainer = find.text('Додати нотатку');

      // Перевіряємо, що кнопка існує
      expect(addNoteContainer, findsOneWidget);

      // Перевіряємо, що у кнопки є іконка додавання
      final addIcon = find.byIcon(Icons.add);
      expect(addIcon, findsOneWidget);
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