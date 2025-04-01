import 'package:flutter_test/flutter_test.dart';
// lib/calculator.dart
class Calculator {
  int add(int a, int b) => a + b;
}

// test/app_test.dart

void main() {
  group('Calculator', () {
    test('adds two numbers correctly', () {
      final calculator = Calculator();
      expect(calculator.add(2, 3), 5);
      expect(calculator.add(-1, 1), 0);
    });
  });
}