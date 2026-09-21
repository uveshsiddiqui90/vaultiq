import 'package:flutter_test/flutter_test.dart';
import 'package:vaultiq/core/config/app_config.dart';
import 'package:vaultiq/core/errors/app_exception.dart';
import 'package:vaultiq/core/services/validation_service.dart';

/// Format a DateTime as a yyyy-MM-dd string (the format stored in Supabase).
String asDateString(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

void main() {
  group('ValidationService.validateEmail', () {
    test('accepts a valid email', () {
      expect(
        () => ValidationService.validateEmail('user@example.com'),
        returnsNormally,
      );
    });

    test('accepts an email with surrounding whitespace (trimmed)', () {
      expect(
        () => ValidationService.validateEmail('  user@example.com  '),
        returnsNormally,
      );
    });

    test('rejects an empty email', () {
      expect(
        () => ValidationService.validateEmail(''),
        throwsA(isA<ValidationException>()),
      );
    });

    test('rejects a malformed email', () {
      expect(
        () => ValidationService.validateEmail('not-an-email'),
        throwsA(isA<ValidationException>()),
      );
    });
  });

  group('ValidationService.validatePassword', () {
    test('accepts a 6 character password (minimum)', () {
      expect(
        () => ValidationService.validatePassword('123456'),
        returnsNormally,
      );
    });

    test('rejects an empty password', () {
      expect(
        () => ValidationService.validatePassword(''),
        throwsA(isA<ValidationException>()),
      );
    });

    test('rejects a 5 character password', () {
      expect(
        () => ValidationService.validatePassword('12345'),
        throwsA(isA<ValidationException>()),
      );
    });
  });

  group('ValidationService.validatePasswordConfirmation', () {
    test('accepts matching passwords', () {
      expect(
        () =>
            ValidationService.validatePasswordConfirmation('secret1', 'secret1'),
        returnsNormally,
      );
    });

    test('rejects mismatching passwords', () {
      expect(
        () =>
            ValidationService.validatePasswordConfirmation('secret1', 'secret2'),
        throwsA(isA<ValidationException>()),
      );
    });
  });

  group('ValidationService.validateName', () {
    test('accepts a normal name', () {
      expect(() => ValidationService.validateName('Uvesh'), returnsNormally);
    });

    test('rejects an empty name', () {
      expect(
        () => ValidationService.validateName('   '),
        throwsA(isA<ValidationException>()),
      );
    });

    test('rejects a 1 character name', () {
      expect(
        () => ValidationService.validateName('A'),
        throwsA(isA<ValidationException>()),
      );
    });

    test('rejects a name longer than 100 characters', () {
      expect(
        () => ValidationService.validateName('a' * 101),
        throwsA(isA<ValidationException>()),
      );
    });
  });

  group('ValidationService.validateBudgetAmount', () {
    test('accepts the minimum budget', () {
      expect(
        () => ValidationService.validateBudgetAmount(AppConfig.minBudgetAmount),
        returnsNormally,
      );
    });

    test('accepts the maximum budget', () {
      expect(
        () => ValidationService.validateBudgetAmount(AppConfig.maxBudgetAmount),
        returnsNormally,
      );
    });

    test('rejects an amount below the minimum', () {
      expect(
        () => ValidationService.validateBudgetAmount(
          AppConfig.minBudgetAmount - 1,
        ),
        throwsA(isA<InvalidBudgetException>()),
      );
    });

    test('rejects an amount above the maximum', () {
      expect(
        () => ValidationService.validateBudgetAmount(
          AppConfig.maxBudgetAmount + 1,
        ),
        throwsA(isA<InvalidBudgetException>()),
      );
    });
  });

  group('ValidationService.validateExpenseAmount', () {
    test('accepts a valid amount', () {
      expect(
        () => ValidationService.validateExpenseAmount(250.50),
        returnsNormally,
      );
    });

    test('rejects zero', () {
      expect(
        () => ValidationService.validateExpenseAmount(0),
        throwsA(isA<InvalidExpenseException>()),
      );
    });

    test('rejects a negative amount', () {
      expect(
        () => ValidationService.validateExpenseAmount(-10),
        throwsA(isA<InvalidExpenseException>()),
      );
    });

    test('rejects an amount below the minimum', () {
      expect(
        () => ValidationService.validateExpenseAmount(
          AppConfig.minExpenseAmount / 2,
        ),
        throwsA(isA<InvalidExpenseException>()),
      );
    });

    test('rejects an amount above the maximum', () {
      expect(
        () => ValidationService.validateExpenseAmount(
          AppConfig.maxExpenseAmount + 1,
        ),
        throwsA(isA<InvalidExpenseException>()),
      );
    });
  });

  group('ValidationService.validateCategory', () {
    test('accepts every supported category', () {
      for (final category in const [
        'Groceries',
        'Food',
        'Transport',
        'Shopping',
        'Bills',
        'Health',
      ]) {
        expect(
          () => ValidationService.validateCategory(category),
          returnsNormally,
          reason: '$category should be valid',
        );
      }
    });

    test('rejects an empty category', () {
      expect(
        () => ValidationService.validateCategory(''),
        throwsA(isA<InvalidExpenseException>()),
      );
    });

    test('rejects an unsupported category', () {
      expect(
        () => ValidationService.validateCategory('Yacht'),
        throwsA(isA<InvalidExpenseException>()),
      );
    });
  });

  group('ValidationService.validateExpenseDate', () {
    test('accepts today', () {
      expect(
        () =>
            ValidationService.validateExpenseDate(asDateString(DateTime.now())),
        returnsNormally,
      );
    });

    test('accepts a past date', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      expect(
        () => ValidationService.validateExpenseDate(asDateString(yesterday)),
        returnsNormally,
      );
    });

    test('rejects a future date with the correct message', () {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      expect(
        () => ValidationService.validateExpenseDate(asDateString(tomorrow)),
        throwsA(
          isA<InvalidExpenseException>().having(
            (e) => e.message,
            'message',
            'Expense date cannot be in the future.',
          ),
        ),
      );
    });

    test('rejects an empty date', () {
      expect(
        () => ValidationService.validateExpenseDate('  '),
        throwsA(isA<InvalidExpenseException>()),
      );
    });

    test('rejects a malformed date', () {
      expect(
        () => ValidationService.validateExpenseDate('not-a-date'),
        throwsA(isA<InvalidExpenseException>()),
      );
    });
  });

  group('ValidationService.validateNote', () {
    test('accepts null', () {
      expect(() => ValidationService.validateNote(null), returnsNormally);
    });

    test('accepts a note at the maximum length', () {
      expect(
        () => ValidationService.validateNote('a' * AppConfig.maxNoteLength),
        returnsNormally,
      );
    });

    test('rejects a note above the maximum length', () {
      expect(
        () =>
            ValidationService.validateNote('a' * (AppConfig.maxNoteLength + 1)),
        throwsA(isA<InvalidExpenseException>()),
      );
    });
  });

  group('ValidationService.validateExpense (combined)', () {
    test('accepts a fully valid expense', () {
      expect(
        () => ValidationService.validateExpense(
          amount: 199.99,
          category: 'Food',
          date: asDateString(DateTime.now()),
          note: 'Lunch with team',
        ),
        returnsNormally,
      );
    });

    test('fails when the date is in the future', () {
      expect(
        () => ValidationService.validateExpense(
          amount: 199.99,
          category: 'Food',
          date: asDateString(DateTime.now().add(const Duration(days: 2))),
          note: '',
        ),
        throwsA(isA<InvalidExpenseException>()),
      );
    });
  });

  group('ValidationService helpers', () {
    test('isEmpty detects null, empty and whitespace strings', () {
      expect(ValidationService.isEmpty(null), isTrue);
      expect(ValidationService.isEmpty(''), isTrue);
      expect(ValidationService.isEmpty('   '), isTrue);
      expect(ValidationService.isEmpty('x'), isFalse);
    });

    test('isValidAmount only accepts positive numbers', () {
      expect(ValidationService.isValidAmount(null), isFalse);
      expect(ValidationService.isValidAmount(0), isFalse);
      expect(ValidationService.isValidAmount(-1), isFalse);
      expect(ValidationService.isValidAmount(1), isTrue);
    });
  });
}