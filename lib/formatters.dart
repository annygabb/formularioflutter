import 'package:flutter/services.dart';

/// Aplica a máscara sem dependências e mantém o cursor durante edições.
class CadastroMaskFormatter extends TextInputFormatter {
  CadastroMaskFormatter.cpf() : _phone = false;
  CadastroMaskFormatter.telefone() : _phone = true;
  final bool _phone;

  String _digits(String value) => value.replaceAll(RegExp(r'\D'), '');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (!newValue.composing.isCollapsed) return newValue;
    var digits = _digits(newValue.text);
    final cursor = newValue.selection.extentOffset.clamp(0, newValue.text.length).toInt();
    var digitsBefore = _digits(newValue.text.substring(0, cursor)).length;
    // Backspace/Delete em um separador também remove o dígito vizinho.
    if (newValue.text.length < oldValue.text.length && digits == _digits(oldValue.text) && digits.isNotEmpty) {
      final backspace = oldValue.selection.extentOffset > cursor;
      final index = (backspace ? digitsBefore - 1 : digitsBefore).clamp(0, digits.length - 1).toInt();
      digits = digits.replaceRange(index, index + 1, '');
      if (backspace && digitsBefore > 0) digitsBefore--;
    }
    if (digits.length > 11) digits = digits.substring(0, 11);
    digitsBefore = digitsBefore.clamp(0, digits.length).toInt();
    final mask = _phone
        ? (digits.length > 10 ? '(##) #####-####' : '(##) ####-####')
        : '###.###.###-##';
    final output = StringBuffer();
    var index = 0;
    var selection = 0;
    for (var i = 0; i < mask.length && index < digits.length; i++) {
      if (mask[i] == '#') {
        output.write(digits[index++]);
        if (index <= digitsBefore) selection = output.length;
      } else {
        output.write(mask[i]);
      }
    }
    return TextEditingValue(
      text: output.toString(),
      selection: TextSelection.collapsed(offset: selection),
    );
  }
}
