import 'package:flutter/material.dart';

/// Resultado exclusivamente visual para probar recuperaciones de la interfaz.
/// La verificación real pertenece al backend de acceso C.
enum DemoChallengeResult { confirmed, invalid, expired }

enum _AccessStep { email, credentials, code }

class ClientAccessFlow extends StatefulWidget {
  const ClientAccessFlow({
    super.key,
    this.demoChallengeResult = DemoChallengeResult.confirmed,
    this.onAccessConfirmed,
  });

  final DemoChallengeResult demoChallengeResult;
  final VoidCallback? onAccessConfirmed;

  @override
  State<ClientAccessFlow> createState() => _ClientAccessFlowState();
}

class _ClientAccessFlowState extends State<ClientAccessFlow> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  var _step = _AccessStep.email;
  String? _codeMessage;
  String _maskedPhone = '••••';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _continueFromEmail() {
    if (_emailController.text.trim().isEmpty) return;
    setState(() => _step = _AccessStep.credentials);
  }

  void _requestCode() {
    if (_passwordController.text.isEmpty || _phoneController.text.trim().isEmpty) {
      return;
    }

    final phone = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    _maskedPhone = phone.length >= 4 ? '••••${phone.substring(phone.length - 4)}' : '••••';
    _passwordController.clear();
    _phoneController.clear();
    setState(() {
      _codeMessage = null;
      _step = _AccessStep.code;
    });
  }

  void _confirmCode() {
    if (_codeController.text.isEmpty) return;
    _codeController.clear();

    if (widget.demoChallengeResult == DemoChallengeResult.confirmed) {
      widget.onAccessConfirmed?.call();
      return;
    }

    setState(() {
      _codeMessage = switch (widget.demoChallengeResult) {
        DemoChallengeResult.confirmed => null,
        DemoChallengeResult.invalid => 'Ese código no es válido. Probá de nuevo.',
        DemoChallengeResult.expired => 'Ese código venció. Pedí uno nuevo.',
      };
    });
  }

  void _requestAnotherCode() {
    setState(() => _codeMessage = 'Te enviamos un código nuevo.');
  }

  void _goBack() {
    setState(() {
      _codeMessage = null;
      _step = switch (_step) {
        _AccessStep.email => _AccessStep.email,
        _AccessStep.credentials => _AccessStep.email,
        _AccessStep.code => _AccessStep.credentials,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final step = _step == _AccessStep.email
        ? 'Paso 1 de 3'
        : _step == _AccessStep.credentials
        ? 'Paso 2 de 3'
        : 'Paso 3 de 3';

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      if (_step != _AccessStep.email)
                        IconButton(
                          onPressed: _goBack,
                          tooltip: 'Volver',
                          icon: const Icon(Icons.arrow_back_rounded),
                        )
                      else
                        const SizedBox(width: 48),
                      const Spacer(),
                      Semantics(
                        label: step,
                        child: Text(
                          step,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  Semantics(
                    header: true,
                    child: Text(
                      'ServiPronto',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: colors.secondary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: switch (_step) {
                      _AccessStep.email => _EmailStep(
                        key: const ValueKey('email'),
                        controller: _emailController,
                        onContinue: _continueFromEmail,
                      ),
                      _AccessStep.credentials => _CredentialsStep(
                        key: const ValueKey('credentials'),
                        passwordController: _passwordController,
                        phoneController: _phoneController,
                        onContinue: _requestCode,
                      ),
                      _AccessStep.code => _CodeStep(
                        key: const ValueKey('code'),
                        controller: _codeController,
                        maskedPhone: _maskedPhone,
                        message: _codeMessage,
                        onConfirm: _confirmCode,
                        onRequestAnother: _requestAnotherCode,
                      ),
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailStep extends StatelessWidget {
  const _EmailStep({super.key, required this.controller, required this.onContinue});

  final TextEditingController controller;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) => _StepLayout(
    title: 'Tu correo',
    help: 'Lo usamos para que vuelvas a entrar.',
    field: TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email],
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Correo electrónico',
        hintText: 'vos@correo.com',
      ),
    ),
    action: FilledButton(onPressed: onContinue, child: const Text('Continuar')),
  );
}

class _CredentialsStep extends StatelessWidget {
  const _CredentialsStep({
    super.key,
    required this.passwordController,
    required this.phoneController,
    required this.onContinue,
  });

  final TextEditingController passwordController;
  final TextEditingController phoneController;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) => _StepLayout(
    title: 'Protegé tu cuenta',
    help: 'Elegí una contraseña y confirmá tu teléfono.',
    field: Column(
      children: [
        TextField(
          controller: passwordController,
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          autofillHints: const [AutofillHints.newPassword],
          decoration: const InputDecoration(labelText: 'Contraseña'),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          autofillHints: const [AutofillHints.telephoneNumber],
          decoration: const InputDecoration(labelText: 'Teléfono'),
        ),
      ],
    ),
    action: FilledButton(onPressed: onContinue, child: const Text('Continuar')),
  );
}

class _CodeStep extends StatelessWidget {
  const _CodeStep({
    super.key,
    required this.controller,
    required this.maskedPhone,
    required this.message,
    required this.onConfirm,
    required this.onRequestAnother,
  });

  final TextEditingController controller;
  final String maskedPhone;
  final String? message;
  final VoidCallback onConfirm;
  final VoidCallback onRequestAnother;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return _StepLayout(
      title: 'Confirmá tu teléfono',
      help: 'Mandamos un código a $maskedPhone.',
      field: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: controller,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(labelText: 'Código temporal'),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Semantics(
              liveRegion: true,
              child: Text(
                message!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: onRequestAnother,
              child: const Text('Pedir otro código'),
            ),
          ),
        ],
      ),
      action: FilledButton(
        onPressed: onConfirm,
        child: const Text('Confirmar código'),
      ),
    );
  }
}

class _StepLayout extends StatelessWidget {
  const _StepLayout({
    required this.title,
    required this.help,
    required this.field,
    required this.action,
  });

  final String title;
  final String help;
  final Widget field;
  final Widget action;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Semantics(
        header: true,
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      const SizedBox(height: 8),
      Text(help),
      const SizedBox(height: 28),
      field,
      const SizedBox(height: 28),
      action,
    ],
  );
}
