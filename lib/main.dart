import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'formatters.dart';
import 'validators.dart';

void main() => runApp(const CadastroApp());

class CadastroApp extends StatelessWidget {
  const CadastroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB91C1C),
          primary: const Color(0xFFB91C1C),
          onPrimary: Colors.white,
          surface: Colors.white,
          error: const Color(0xFFB91C1C),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFB91C1C),
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF5F5),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFFFFFFF),
          errorMaxLines: 3,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFFECACA)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFB91C1C), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        ),
      ),
      home: const CadastroPage(),
    );
  }
}

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  // A GlobalKey dá acesso ao validate() do Form.
  final _formKey = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _email = TextEditingController();
  final _cpf = TextEditingController();
  final _telefone = TextEditingController();
  final _senha = TextEditingController();
  final _cpfMask = CadastroMaskFormatter.cpf();
  final _telefoneMask = CadastroMaskFormatter.telefone();
  bool _ocultarSenha = true;

  @override
  void dispose() {
    // Libere os controllers quando a tela for removida.
    _nome.dispose();
    _email.dispose();
    _cpf.dispose();
    _telefone.dispose();
    _senha.dispose();
    super.dispose();
  }

  void _cadastrar() {
    FocusScope.of(context).unfocus();
    // Cada validator retorna a mensagem de erro ou null.
    if (!_formKey.currentState!.validate()) return;

    // Nesta aula o cadastro é LOCAL: não envia nem armazena os dados.
    // Na próxima aula, a chamada HTTP pode ser feita aqui usando os controllers.
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(
        content: Text('Cadastro realizado com sucesso! (Demonstração local)'),
        backgroundColor: Color(0xFFB91C1C),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 4),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulário de cadastro')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Card(
                elevation: 0,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: AutofillGroup(
                    child: Form(
                      key: _formKey,
                      // Após interação, os erros se atualizam ao digitar.
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Icon(Icons.person_add_alt_1, size: 42, color: Color(0xFFB91C1C)),
                          const SizedBox(height: 16),
                          Text('Crie seu cadastro', textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          const Text('Preencha os campos abaixo. Todos são obrigatórios.', textAlign: TextAlign.center),
                          const SizedBox(height: 28),
                          TextFormField(
                            controller: _nome,
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.name],
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'[\r\n]')),
                              LengthLimitingTextInputFormatter(100),
                            ],
                            decoration: const InputDecoration(labelText: 'Nome', hintText: 'Seu nome', prefixIcon: Icon(Icons.person_outline)),
                            validator: Validators.nome,
                          ),
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autocorrect: false,
                            autofillHints: const [AutofillHints.email],
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                              LengthLimitingTextInputFormatter(254),
                            ],
                            decoration: const InputDecoration(labelText: 'E-mail', hintText: 'nome@exemplo.com', prefixIcon: Icon(Icons.email_outlined)),
                            validator: Validators.email,
                          ),
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: _cpf,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            inputFormatters: [_cpfMask],
                            decoration: const InputDecoration(labelText: 'CPF', hintText: '000.000.000-00', prefixIcon: Icon(Icons.badge_outlined)),
                            validator: Validators.cpf,
                          ),
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: _telefone,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.telephoneNumberNational],
                            inputFormatters: [_telefoneMask],
                            decoration: const InputDecoration(labelText: 'Telefone', hintText: '(61) 99999-9999', prefixIcon: Icon(Icons.phone_outlined)),
                            validator: Validators.telefone,
                          ),
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: _senha,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                            obscureText: _ocultarSenha,
                            enableSuggestions: false,
                            autocorrect: false,
                            autofillHints: const [AutofillHints.newPassword],
                            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[\r\n]'))],
                            decoration: InputDecoration(
                              labelText: 'Senha',
                              helperText: 'Mínimo de 8 caracteres, com letra e número.',
                              helperMaxLines: 2,
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                tooltip: _ocultarSenha ? 'Mostrar senha' : 'Ocultar senha',
                                onPressed: () => setState(() => _ocultarSenha = !_ocultarSenha),
                                icon: Icon(_ocultarSenha ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                              ),
                            ),
                            validator: Validators.senha,
                            onFieldSubmitted: (_) => _cadastrar(),
                          ),
                          const SizedBox(height: 28),
                          FilledButton.icon(
                            onPressed: _cadastrar,
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text('Cadastrar'),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text('Exercício demonstrativo: os dados não são enviados a um servidor.',
                            textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
