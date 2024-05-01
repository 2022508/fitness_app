import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  test('To 0dp', () {
    double a = 5432.1241254125412112;

    a = double.parse(a.toStringAsFixed(0));

    expect(a, 5432);
  });
  test('String to formatted string', () {
    String a = DateTime(2017, 9, 7, 17, 30, 12, 1111, 2323).toString();

    a = DateFormat('HH:mm dd/MM/yy').format(DateTime.parse(a));

    expect(a, '17:30 07/09/17');
  });

  test('String to millisecondsSinceEpoch', () {
    double a = DateTime.parse(DateTime(2017, 9, 7, 17, 30, 12).toString())
        .millisecondsSinceEpoch
        .toDouble();

    expect(a, 1504801812000);
  });
}
