/// Retorne null para um campo válido ou a mensagem que aparecerá abaixo dele.
class Validators {
  static String digits(String value) => value.replaceAll(RegExp(r'\D'), '');

  static String? nome(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return 'Informe seu nome.';
    if (text.length < 3) return 'Digite pelo menos 3 caracteres.';
    if (!RegExp(r"^[A-Za-zÀ-ÖØ-öø-ÿ]+(?:[ '\-][A-Za-zÀ-ÖØ-öø-ÿ]+)*$").hasMatch(text)) {
      return 'Use letras, espaços, hífen ou apóstrofo.';
    }
    return null;
  }

  static String? email(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return 'Informe seu e-mail.';
    if (!RegExp(r'^[^\s@]+@[^\s@.]+(?:\.[^\s@.]+)+$').hasMatch(text)) {
      return 'Digite um e-mail válido. Ex.: nome@exemplo.com';
    }
    return null;
  }

  static String? cpf(String? value) {
    final text = digits(value ?? '');
    if (text.isEmpty) return 'Informe seu CPF.';
    if (text.length != 11) return 'O CPF deve ter 11 dígitos.';
    if (RegExp(r'^(\d)\1{10}$').hasMatch(text)) return 'Digite um CPF válido.';
    final numbers = text.split('').map(int.parse).toList();
    for (var position = 9; position <= 10; position++) {
      var sum = 0;
      for (var i = 0; i < position; i++) {
        sum += numbers[i] * (position + 1 - i);
      }
      final remainder = sum % 11;
      final digit = remainder < 2 ? 0 : 11 - remainder;
      if (numbers[position] != digit) return 'Digite um CPF válido.';
    }
    return null;
  }

  static String? telefone(String? value) {
    final text = digits(value ?? '');
    if (text.isEmpty) return 'Informe seu telefone.';
    if (text.length != 10 && text.length != 11) {
      return 'Digite o DDD e o número (10 ou 11 dígitos).';
    }
    const ddds = {
      '11','12','13','14','15','16','17','18','19',
      '21','22','24','27','28','31','32','33','34','35','37','38',
      '41','42','43','44','45','46','47','48','49','51','53','54','55',
      '61','62','63','64','65','66','67','68','69','71','73','74','75','77','79',
      '81','82','83','84','85','86','87','88','89','91','92','93','94','95','96','97','98','99',
    };
    if (!ddds.contains(text.substring(0, 2))) return 'Informe um DDD válido.';
    if (text.length == 11 && text[2] != '9') return 'O celular deve começar com 9 após o DDD.';
    if (text.length == 10 && !RegExp(r'[2-5]').hasMatch(text[2])) {
      return 'O telefone fixo deve começar com 2, 3, 4 ou 5.';
    }
    return null;
  }

  static String? senha(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return 'Informe uma senha.';
    if (text.length < 8) return 'A senha deve ter pelo menos 8 caracteres.';
    if (!RegExp(r'[A-Za-zÀ-ÖØ-öø-ÿ]').hasMatch(text) || !RegExp(r'[0-9]').hasMatch(text)) {
      return 'A senha deve conter uma letra e um número.';
    }
    if (RegExp(r'\s').hasMatch(text)) return 'A senha não pode conter espaços.';
    return null;
  }
}
