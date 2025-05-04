import 'package:integration_test/integration_test.dart';

import 'app_test.dart' as app_test;
import 'calendar_flow_test.dart' as calendar_test;
import 'notes_flow_test.dart' as notes_test;


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Запускаємо всі інтеграційні тести
  app_test.main();
  calendar_test.main();
  notes_test.main();

}