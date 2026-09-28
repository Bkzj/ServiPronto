import 'package:flutter/material.dart';

enum _ProfileStep { name, surname, birthDate, address, review, paused }

/// Recorrido visual local para completar el perfil Cliente sin persistir datos.
/// La conexión y el guardado definitivo pertenecen al backend de cuentas.
class ClientProfileFlow extends StatefulWidget {
  const ClientProfileFlow({super.key});

  @override
  State<ClientProfileFlow> createState() => _ClientProfileFlowState();
}

class _ClientProfileFlowState extends State<ClientProfileFlow> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _addressController = TextEditingController();
  var _step = _ProfileStep.name;
  var _showSavedNotice = false;

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _birthDateController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _continueFrom(_ProfileStep currentStep) {
    if (!_hasValueFor(currentStep)) return;

    setState(() {
      _showSavedNotice = true;
      _step = switch (currentStep) {
        _ProfileStep.name => _ProfileStep.surname,
        _ProfileStep.surname => _ProfileStep.birthDate,
        _ProfileStep.birthDate => _ProfileStep.address,
        _ProfileStep.address => _ProfileStep.review,
        _ProfileStep.review || _ProfileStep.paused => currentStep,
      };
    });
  }

  bool _hasValueFor(_ProfileStep step) => switch (step) {
    _ProfileStep.name => _nameController.text.trim().isNotEmpty,
    _ProfileStep.surname => _surnameController.text.trim().isNotEmpty,
    _ProfileStep.birthDate => _birthDateController.text.trim().isNotEmpty,
    _ProfileStep.address => _addressController.text.trim().isNotEmpty,
    _ProfileStep.review || _ProfileStep.paused => true,
  };

  void _pause() => setState(() => _step = _ProfileStep.paused);

  void _resume() => setState(() {
    _step = _firstIncompleteStep();
    _showSavedNotice = true;
  });

  _ProfileStep _firstIncompleteStep() {
    if (_nameController.text.trim().isEmpty) return _ProfileStep.name;
    if (_surnameController.text.trim().isEmpty) return _ProfileStep.surname;
    if (_birthDateController.text.trim().isEmpty) return _ProfileStep.birthDate;
    if (_addressController.text.trim().isEmpty) return _ProfileStep.address;
    return _ProfileStep.review;
  }

  void _edit(_ProfileStep step) => setState(() {
    _step = step;
    _showSavedNotice = true;
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
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
                  Text(
                    'ServiPronto',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: colors.secondary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 28),
                  if (_showSavedNotice && _step != _ProfileStep.paused)
                    Semantics(
                      liveRegion: true,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          'Avance guardado',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: switch (_step) {
                      _ProfileStep.name => _ProfileDataStep(
                        key: const ValueKey('profile-name'),
                        progress: 'Nombre · falta apellido',
                        title: 'Tu nombre',
                        help: 'Así te vamos a llamar.',
                        controller: _nameController,
                        label: 'Nombre',
                        actionLabel: 'Continuar',
                        onContinue: () => _continueFrom(_ProfileStep.name),
                        onPause: _pause,
                        autofillHints: const [AutofillHints.givenName],
                      ),
                      _ProfileStep.surname => _ProfileDataStep(
                        key: const ValueKey('profile-surname'),
                        progress: 'Apellido · falta fecha de nacimiento',
                        title: 'Tu apellido',
                        help: 'Lo usamos para identificar tu cuenta.',
                        controller: _surnameController,
                        label: 'Apellido',
                        actionLabel: 'Continuar',
                        onContinue: () => _continueFrom(_ProfileStep.surname),
                        onPause: _pause,
                        autofillHints: const [AutofillHints.familyName],
                      ),
                      _ProfileStep.birthDate => _ProfileDataStep(
                        key: const ValueKey('profile-birth-date'),
                        progress: 'Fecha de nacimiento · falta dirección',
                        title: 'Tu fecha de nacimiento',
                        help: 'Te permite contratar cuando corresponda.',
                        controller: _birthDateController,
                        label: 'Fecha de nacimiento',
                        hint: 'DD/MM/AAAA',
                        actionLabel: 'Continuar',
                        onContinue: () => _continueFrom(_ProfileStep.birthDate),
                        onPause: _pause,
                        keyboardType: TextInputType.datetime,
                      ),
                      _ProfileStep.address => _ProfileDataStep(
                        key: const ValueKey('profile-address'),
                        progress: 'Dirección · después revisás todo',
                        title: 'Tu dirección',
                        help: 'La vamos a usar cuando pidas un servicio.',
                        controller: _addressController,
                        label: 'Dirección',
                        actionLabel: 'Revisar datos',
                        onContinue: () => _continueFrom(_ProfileStep.address),
                        onPause: _pause,
                        autofillHints: const [AutofillHints.fullStreetAddress],
                      ),
                      _ProfileStep.review => _ProfileReview(
                        key: const ValueKey('profile-review'),
                        name: _nameController.text,
                        surname: _surnameController.text,
                        birthDate: _birthDateController.text,
                        address: _addressController.text,
                        onEditName: () => _edit(_ProfileStep.name),
                        onEditSurname: () => _edit(_ProfileStep.surname),
                        onEditBirthDate: () => _edit(_ProfileStep.birthDate),
                        onEditAddress: () => _edit(_ProfileStep.address),
                      ),
                      _ProfileStep.paused => _ProfilePaused(
                        key: const ValueKey('profile-paused'),
                        onResume: _resume,
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

class _ProfileDataStep extends StatelessWidget {
  const _ProfileDataStep({
    super.key,
    required this.progress,
    required this.title,
    required this.help,
    required this.controller,
    required this.label,
    required this.actionLabel,
    required this.onContinue,
    required this.onPause,
    this.hint,
    this.keyboardType,
    this.autofillHints,
  });

  final String progress;
  final String title;
  final String help;
  final TextEditingController controller;
  final String label;
  final String actionLabel;
  final String? hint;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final VoidCallback onContinue;
  final VoidCallback onPause;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Semantics(
        label: progress,
        child: Text(
          progress,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      const SizedBox(height: 24),
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
      TextField(
        controller: controller,
        keyboardType: keyboardType,
        autofillHints: autofillHints,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(labelText: label, hintText: hint),
      ),
      const SizedBox(height: 28),
      FilledButton(onPressed: onContinue, child: Text(actionLabel)),
      const SizedBox(height: 8),
      TextButton(onPressed: onPause, child: const Text('Guardar y seguir después')),
    ],
  );
}

class _ProfilePaused extends StatelessWidget {
  const _ProfilePaused({super.key, required this.onResume});

  final VoidCallback onResume;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Semantics(
        header: true,
        child: Text(
          'Seguimos cuando quieras',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      const SizedBox(height: 8),
      const Text('Tu avance queda listo para retomar en esta sesión.'),
      const SizedBox(height: 28),
      FilledButton(onPressed: onResume, child: const Text('Retomar perfil')),
    ],
  );
}

class _ProfileReview extends StatelessWidget {
  const _ProfileReview({
    super.key,
    required this.name,
    required this.surname,
    required this.birthDate,
    required this.address,
    required this.onEditName,
    required this.onEditSurname,
    required this.onEditBirthDate,
    required this.onEditAddress,
  });

  final String name;
  final String surname;
  final String birthDate;
  final String address;
  final VoidCallback onEditName;
  final VoidCallback onEditSurname;
  final VoidCallback onEditBirthDate;
  final VoidCallback onEditAddress;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Semantics(
        header: true,
        child: Text(
          'Revisá tu perfil',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      const SizedBox(height: 8),
      const Text('Podés corregir un dato antes de guardarlo.'),
      const SizedBox(height: 24),
      _ReviewLine(label: 'Nombre', value: name, onEdit: onEditName),
      _ReviewLine(label: 'Apellido', value: surname, onEdit: onEditSurname),
      _ReviewLine(
        label: 'Fecha de nacimiento',
        value: birthDate,
        onEdit: onEditBirthDate,
      ),
      _ReviewLine(label: 'Dirección', value: address, onEdit: onEditAddress),
      const SizedBox(height: 20),
      FilledButton(onPressed: () {}, child: const Text('Guardar perfil')),
    ],
  );
}

class _ReviewLine extends StatelessWidget {
  const _ReviewLine({
    required this.label,
    required this.value,
    required this.onEdit,
  });

  final String label;
  final String value;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 2),
              Text(value),
            ],
          ),
        ),
        TextButton(onPressed: onEdit, child: Text('Editar ${label.toLowerCase()}')),
      ],
    ),
  );
}
