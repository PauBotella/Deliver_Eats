// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:deliver_eats/main.dart';
import 'package:deliver_eats/models/user.dart';
import 'package:deliver_eats/services/auth_service.dart';
import 'package:deliver_eats/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("User", () {
    final UserF user = UserF(email: "hola@gmail.com", username: "hola", role: "admin", id: "ABCDEF");

    test("Comprobar que el usuario se convierte correctamente a un mapa", () async {
      final Map<String, dynamic> userMap = await user.toMap();
      expect(user.email, userMap["email"]);
    });
    test("Comprobar que el mapa se transforma correctamente al usuario", () async {
      final Map<String, dynamic> userMap = await user.toMap();
      final UserF jsonUser = UserF.fromJson(userMap, "ABCDEF");
      expect(user.email, userMap["email"]);
    });
  });
  group("Format Numbers", () {
    test("Comprobar que los números menores de 100 se mostrarán correctamente", () {
      double num = 12.5345935938483472347827432;
      expect(formatNumber(num).toString(), "12,5");
    });
    test("Comprobar que los números mayores de 100 se mostrarán correctamente", () {
      double num = 420.6945935938483472347827432;
      expect(formatNumber(num).toString(), "420,7");
    });
    test("Comprobar que los precios menores de 100 se mostrarán correctamente", () {
      double num = 12.5345935938483472347827432;
      expect(formatNumberPrice(num).toString(), "12,53");
    });
    test("Comprobar que los precios mayores de 100 se mostrarán correctamente", () {
      double num = 420.6945935938483472347827432;
      expect(formatNumberPrice(num).toString(), "420,69");
    });
  });
}