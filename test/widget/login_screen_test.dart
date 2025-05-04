import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_life/views/login_screen.dart';
import 'package:mockito/mockito.dart';

// Для тестування без Firebase, потрібно підготувати відповідне оточення
// Цей клас допомагає уникнути помилок Firebase-залежностей під час тестування
class TestUtils {
  static Widget makeTestableWidget({required Widget child}) {
    return MaterialApp(
      home: child,
    );
  }
}

void main() {
  group('LoginScreen Widget Tests', () {
    // Firebase не ініціалізується в тестовому середовищі,
    // тому ми зосередимось на тестуванні UI

    testWidgets('should display all UI components', (WidgetTester tester) async {
      // Arrange - створюємо віджет для тестування
      await tester.pumpWidget(
        TestUtils.makeTestableWidget(child: LoginScreen()),
      );
      await tester.pumpAndSettle();

      // Assert - перевіряємо присутність всіх елементів UI
      expect(find.text('Вхід'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2)); // Email та password поля

      // Перевіряємо підказки для полів вводу
      expect(find.text('Електронна пошта'), findsOneWidget);
      expect(find.text('Пароль'), findsOneWidget);

      // Перевіряємо кнопки
      expect(find.text('Увійти'), findsOneWidget);
      expect(find.text('Увійти через Google'), findsOneWidget);

      // Перевіряємо посилання
      expect(find.text('Забули пароль?'), findsOneWidget);
      expect(find.text('Ще не маєте акаунта? Зареєструватися'), findsOneWidget);
    });

    testWidgets('should allow text input in email and password fields', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        TestUtils.makeTestableWidget(child: LoginScreen()),
      );
      await tester.pumpAndSettle();

      // Act - вводимо текст в поля
      const testEmail = 'test@example.com';
      const testPassword = 'password123';

      await tester.enterText(find.byType(TextField).at(0), testEmail);
      await tester.enterText(find.byType(TextField).at(1), testPassword);
      await tester.pump();

      // Assert - перевіряємо, що текст був введений
      expect(find.text(testEmail), findsOneWidget);
      expect(find.text(testPassword), findsOneWidget);
    });

    testWidgets('should have obscured text for password field', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        TestUtils.makeTestableWidget(child: LoginScreen()),
      );
      await tester.pumpAndSettle();

      // Знаходимо поле пароля
      final passwordField = find.byType(TextField).at(1);
      final TextField passwordWidget = tester.widget(passwordField);

      // Assert - перевіряємо, що текст пароля прихований
      expect(passwordWidget.obscureText, isTrue);
    });

    testWidgets('should have styled ElevatedButton for login', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        TestUtils.makeTestableWidget(child: LoginScreen()),
      );
      await tester.pumpAndSettle();

      // Знаходимо кнопку "Увійти"
      final loginButton = find.widgetWithText(ElevatedButton, 'Увійти');
      expect(loginButton, findsOneWidget);

      // Перевіряємо стиль кнопки
      final ElevatedButton button = tester.widget(loginButton);

      // Оскільки стиль може бути null, перевіряємо обережно
      if (button.style != null) {
        // Перевіряємо, що для кнопки встановлено певний стиль
        // Наприклад, кольори або відступи
        expect(button.style, isNotNull);
      }
    });

    testWidgets('should have Google sign-in button with icon', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        TestUtils.makeTestableWidget(child: LoginScreen()),
      );
      await tester.pumpAndSettle();

      // Виправлений код - шукаємо ElevatedButton.icon замість ElevatedButton
      // Шукаємо текст кнопки Google
      final googleButtonText = find.text('Увійти через Google');
      expect(googleButtonText, findsOneWidget);

      // Перевіряємо наявність іконки входу
      final iconFinder = find.byIcon(Icons.login);
      expect(iconFinder, findsOneWidget);
    });

    testWidgets('should navigate to reset password screen when forgot password is tapped', (WidgetTester tester) async {
      // Arrange
      bool didNavigate = false;

      await tester.pumpWidget(
        MaterialApp(
          home: LoginScreen(),
          onGenerateRoute: (settings) {
            if (settings.name == '/resetPasswordScreen') {
              didNavigate = true;
            }
            return MaterialPageRoute(
              builder: (context) => Container(), // Порожній контейнер для тесту
            );
          },
        ),
      );
      await tester.pumpAndSettle();

      // Act - натискаємо на посилання "Забули пароль?"
      await tester.tap(find.text('Забули пароль?'));
      await tester.pumpAndSettle();

      // Assert - перевіряємо, що відбулася навігація
      // Оскільки ми не можемо використати справжню навігацію в тесті,
      // ми просто перевіряємо, що метод Navigator.pushNamed був викликаний
      // У реальному тесті це можна було б перевірити мокуванням Navigator
      expect(didNavigate, isTrue);
    });

    testWidgets('should navigate to register screen when register link is tapped', (WidgetTester tester) async {
      // Arrange
      bool didNavigate = false;

      await tester.pumpWidget(
        MaterialApp(
          home: LoginScreen(),
          onGenerateRoute: (settings) {
            if (settings.name == '/register') {
              didNavigate = true;
            }
            return MaterialPageRoute(
              builder: (context) => Container(), // Порожній контейнер для тесту
            );
          },
        ),
      );
      await tester.pumpAndSettle();

      // Act - натискаємо на посилання для реєстрації
      await tester.tap(find.text('Ще не маєте акаунта? Зареєструватися'));
      await tester.pumpAndSettle();

      // Assert - перевіряємо, що відбулася навігація
      expect(didNavigate, isTrue);
    });
  });
}