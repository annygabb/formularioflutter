import 'package:cadastro_flutter/main.dart';
import 'package:cadastro_flutter/validators.dart';
import 'package:cadastro_flutter/formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CPF confere dígitos e rejeita sequências repetidas', () {
    expect(Validators.cpf('529.982.247-25'), isNull);
    expect(Validators.cpf('529.982.247-24'), isNotNull);
    expect(Validators.cpf('111.111.111-11'), isNotNull);
    expect(Validators.cpf(''), isNotNull);
  });
  test('Campos obrigatórios e regras de entrada', () {
    expect(Validators.nome(''), isNotNull);
    expect(Validators.nome('Anny Oliveira'), isNull);
    expect(Validators.email('anny@exemplo.com'), isNull);
    expect(Validators.email('anny@'), isNotNull);
    expect(Validators.telefone('(61) 99999-1234'), isNull);
    expect(Validators.telefone('(11) 3333-1234'), isNull);
    expect(Validators.telefone('123'), isNotNull);
    expect(Validators.senha('abc12345'), isNull);
    expect(Validators.senha('12345678'), isNotNull);
    expect(Validators.senha('abc123'), isNotNull);
  });
  test('Máscaras formatam colagem e permitem apagar separadores', () {
    final cpf = CadastroMaskFormatter.cpf();
    final value = cpf.formatEditUpdate(TextEditingValue.empty,
        const TextEditingValue(text: '52998224725', selection: TextSelection.collapsed(offset: 11)));
    expect(value.text, '529.982.247-25');
    final removed = cpf.formatEditUpdate(
      const TextEditingValue(text: '529.9', selection: TextSelection.collapsed(offset: 4)),
      const TextEditingValue(text: '5299', selection: TextSelection.collapsed(offset: 3)),
    );
    expect(removed.text, '529');
    final phone = CadastroMaskFormatter.telefone().formatEditUpdate(
      TextEditingValue.empty,
      const TextEditingValue(text: '61999991234', selection: TextSelection.collapsed(offset: 11)),
    );
    expect(phone.text, '(61) 99999-1234');
  });
  testWidgets('Envio vazio mostra erros sem sucesso', (tester) async {
    await tester.pumpWidget(const CadastroApp());
    await tester.ensureVisible(find.text('Cadastrar'));
    await tester.tap(find.text('Cadastrar'));
    await tester.pumpAndSettle();
    expect(find.text('Informe seu nome.'), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
  });
  testWidgets('Cadastro válido mostra SnackBar', (tester) async {
    await tester.pumpWidget(const CadastroApp());
    final fields = find.byType(TextFormField);
    final values = ['Anny Oliveira', 'anny@exemplo.com', '52998224725', '61999991234', 'abc12345'];
    for (var i = 0; i < values.length; i++) {
      await tester.ensureVisible(fields.at(i));
      await tester.enterText(fields.at(i), values[i]);
    }
    await tester.ensureVisible(find.text('Cadastrar'));
    await tester.tap(find.text('Cadastrar'));
    await tester.pumpAndSettle();
    expect(find.text('Cadastro realizado com sucesso! (Demonstração local)'), findsOneWidget);
  });
}
