import 'package:flutter/material.dart';

enum _ProviderStep {
  category,
  tasks,
  modality,
  coverage,
  availability,
  experience,
  price,
  review,
}

/// Alta local y progresiva de un prestador.
///
/// Es un borrador visual: no publica el perfil, no recibe trabajos y no envía
/// información a la API.
class ProviderProfileFlow extends StatefulWidget {
  const ProviderProfileFlow({super.key});

  @override
  State<ProviderProfileFlow> createState() => _ProviderProfileFlowState();
}

class _ProviderProfileFlowState extends State<ProviderProfileFlow> {
  final _tasksController = TextEditingController();
  final _coverageController = TextEditingController();
  final _experienceController = TextEditingController();
  final _registrationController = TextEditingController();
  final _priceController = TextEditingController();

  var _step = _ProviderStep.category;
  String? _category;
  String? _modality;
  String? _availability;

  @override
  void dispose() {
    _tasksController.dispose();
    _coverageController.dispose();
    _experienceController.dispose();
    _registrationController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  bool get _canContinue => switch (_step) {
    _ProviderStep.category => _category != null,
    _ProviderStep.tasks => _tasksController.text.trim().isNotEmpty,
    _ProviderStep.modality => _modality != null,
    _ProviderStep.coverage => _coverageController.text.trim().isNotEmpty,
    _ProviderStep.availability => _availability != null,
    _ProviderStep.experience => _experienceController.text.trim().isNotEmpty,
    _ProviderStep.price => int.tryParse(_priceController.text.trim()) != null,
    _ProviderStep.review => true,
  };

  void _continue() {
    if (!_canContinue) return;
    setState(() {
      _step = switch (_step) {
        _ProviderStep.category => _ProviderStep.tasks,
        _ProviderStep.tasks => _ProviderStep.modality,
        _ProviderStep.modality => _ProviderStep.coverage,
        _ProviderStep.coverage => _ProviderStep.availability,
        _ProviderStep.availability => _ProviderStep.experience,
        _ProviderStep.experience => _ProviderStep.price,
        _ProviderStep.price => _ProviderStep.review,
        _ProviderStep.review => _ProviderStep.review,
      };
    });
  }

  void _edit(_ProviderStep step) => setState(() => _step = step);

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
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: switch (_step) {
                      _ProviderStep.category => _SelectionStep(
                        key: const ValueKey('provider-category'),
                        eyebrow: 'Primer paso',
                        title: 'Tu servicio principal',
                        help: 'Después podés sumar otros.',
                        options: const [
                          'Plomería',
                          'Electricidad',
                          'Limpieza',
                          'Gasista',
                          'Jardinería',
                          'Clases particulares',
                        ],
                        selected: _category,
                        onSelected: (value) => setState(() => _category = value),
                        actionLabel: 'Continuar',
                        onContinue: _continue,
                      ),
                      _ProviderStep.tasks => _TextStep(
                        key: const ValueKey('provider-tasks'),
                        eyebrow: 'Servicio · $_category',
                        title: '¿Qué trabajos hacés?',
                        help: 'Contalo en pocas palabras.',
                        label: 'Tareas que ofrecés',
                        hint: 'Ej.: reparaciones y pérdidas de agua',
                        controller: _tasksController,
                        actionLabel: 'Continuar',
                        onContinue: _continue,
                      ),
                      _ProviderStep.modality => _SelectionStep(
                        key: const ValueKey('provider-modality'),
                        eyebrow: 'Servicio · $_category',
                        title: '¿Cómo trabajás?',
                        help: 'Elegí la modalidad principal.',
                        options: const ['A domicilio', 'Online', 'En mi espacio'],
                        selected: _modality,
                        onSelected: (value) => setState(() => _modality = value),
                        actionLabel: 'Continuar',
                        onContinue: _continue,
                      ),
                      _ProviderStep.coverage => _TextStep(
                        key: const ValueKey('provider-coverage'),
                        eyebrow: 'Servicio · $_category',
                        title: 'Tu cobertura',
                        help: 'Decí hasta dónde te movés.',
                        label: 'Zona de cobertura',
                        hint: 'Ej.: Tandil y alrededores',
                        controller: _coverageController,
                        actionLabel: 'Continuar',
                        onContinue: _continue,
                      ),
                      _ProviderStep.availability => _SelectionStep(
                        key: const ValueKey('provider-availability'),
                        eyebrow: 'Servicio · $_category',
                        title: 'Tu disponibilidad',
                        help: 'Más adelante vas a tener agenda completa.',
                        options: const [
                          'Lunes a viernes · 8 a 18 h',
                          'Todos los días · horarios variables',
                          'Solo con reserva previa',
                        ],
                        selected: _availability,
                        onSelected: (value) =>
                            setState(() => _availability = value),
                        actionLabel: 'Continuar',
                        onContinue: _continue,
                      ),
                      _ProviderStep.experience => _ExperienceStep(
                        key: const ValueKey('provider-experience'),
                        experienceController: _experienceController,
                        registrationController: _registrationController,
                        onContinue: _continue,
                      ),
                      _ProviderStep.price => _TextStep(
                        key: const ValueKey('provider-price'),
                        eyebrow: 'Servicio · $_category',
                        title: 'Tu precio de referencia',
                        help: 'Es una guía para empezar. Lo podés cambiar.',
                        label: 'Precio por hora',
                        hint: 'Ej.: 18000',
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        prefix: r'$ ',
                        actionLabel: 'Revisar borrador',
                        onContinue: _continue,
                      ),
                      _ProviderStep.review => _ProviderReview(
                        key: const ValueKey('provider-review'),
                        category: _category ?? '',
                        tasks: _tasksController.text.trim(),
                        modality: _modality ?? '',
                        coverage: _coverageController.text.trim(),
                        availability: _availability ?? '',
                        experience: _experienceController.text.trim(),
                        registration: _registrationController.text.trim(),
                        price: _formattedPrice(_priceController.text.trim()),
                        onEdit: _edit,
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

  String _formattedPrice(String value) {
    final price = int.tryParse(value) ?? 0;
    return price.toString().replaceAllMapped(
      RegExp(r'(?<!^)(?=(\d{3})+$)'),
      (_) => '.',
    );
  }
}

class _StepFrame extends StatelessWidget {
  const _StepFrame({
    required this.eyebrow,
    required this.title,
    required this.help,
    required this.child,
  });

  final String eyebrow;
  final String title;
  final String help;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        eyebrow,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.secondary,
          fontWeight: FontWeight.w800,
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
      child,
    ],
  );
}

class _SelectionStep extends StatelessWidget {
  const _SelectionStep({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.help,
    required this.options,
    required this.selected,
    required this.onSelected,
    required this.actionLabel,
    required this.onContinue,
  });

  final String eyebrow;
  final String title;
  final String help;
  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelected;
  final String actionLabel;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) => _StepFrame(
    eyebrow: eyebrow,
    title: title,
    help: help,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final option in options) ...[
          _SelectionTile(
            label: option,
            selected: selected == option,
            onTap: () => onSelected(option),
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 18),
        FilledButton(onPressed: onContinue, child: Text(actionLabel)),
      ],
    ),
  );
}

class _SelectionTile extends StatelessWidget {
  const _SelectionTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: selected
            ? colors.secondaryContainer
            : colors.surfaceContainerHighest,
        shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: InkWell(
          onTap: onTap,
          customBorder: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 56),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (selected) Icon(Icons.check_circle, color: colors.secondary),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TextStep extends StatelessWidget {
  const _TextStep({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.help,
    required this.label,
    required this.controller,
    required this.actionLabel,
    required this.onContinue,
    this.hint,
    this.keyboardType,
    this.prefix,
  });

  final String eyebrow;
  final String title;
  final String help;
  final String label;
  final String? hint;
  final TextEditingController controller;
  final String actionLabel;
  final VoidCallback onContinue;
  final TextInputType? keyboardType;
  final String? prefix;

  @override
  Widget build(BuildContext context) => _StepFrame(
    eyebrow: eyebrow,
    title: title,
    help: help,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            prefixText: prefix,
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
        const SizedBox(height: 28),
        FilledButton(onPressed: onContinue, child: Text(actionLabel)),
      ],
    ),
  );
}

class _ExperienceStep extends StatelessWidget {
  const _ExperienceStep({
    super.key,
    required this.experienceController,
    required this.registrationController,
    required this.onContinue,
  });

  final TextEditingController experienceController;
  final TextEditingController registrationController;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) => _StepFrame(
    eyebrow: 'Servicio',
    title: 'Tu experiencia',
    help: 'Contá lo importante. La matrícula es opcional.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: experienceController,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: 'Experiencia',
            hintText: 'Ej.: 8 años',
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: registrationController,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: 'Matrícula (opcional)',
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
        const SizedBox(height: 28),
        FilledButton(onPressed: onContinue, child: const Text('Continuar')),
      ],
    ),
  );
}

class _ProviderReview extends StatelessWidget {
  const _ProviderReview({
    super.key,
    required this.category,
    required this.tasks,
    required this.modality,
    required this.coverage,
    required this.availability,
    required this.experience,
    required this.registration,
    required this.price,
    required this.onEdit,
  });

  final String category;
  final String tasks;
  final String modality;
  final String coverage;
  final String availability;
  final String experience;
  final String registration;
  final String price;
  final ValueChanged<_ProviderStep> onEdit;

  @override
  Widget build(BuildContext context) {
    final rows = <({String label, String value, _ProviderStep step})>[
      (label: 'Servicio', value: category, step: _ProviderStep.category),
      (label: 'Trabajos', value: tasks, step: _ProviderStep.tasks),
      (label: 'Modalidad', value: modality, step: _ProviderStep.modality),
      (label: 'Cobertura', value: coverage, step: _ProviderStep.coverage),
      (
        label: 'Disponibilidad',
        value: availability,
        step: _ProviderStep.availability,
      ),
      (label: 'Experiencia', value: experience, step: _ProviderStep.experience),
      (label: 'Precio por hora', value: r'$ ' + price, step: _ProviderStep.price),
    ];
    if (registration.isNotEmpty) {
      rows.insert(
        6,
        (
          label: 'Matrícula declarada',
          value: registration,
          step: _ProviderStep.experience,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(
            'Revisá tu borrador',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text('Todavía no se publica ni se envía a revisión.'),
        const SizedBox(height: 24),
        for (final row in rows)
          _ReviewRow(
            label: row.label,
            value: row.value,
            onEdit: () => onEdit(row.step),
          ),
      ],
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({
    required this.label,
    required this.value,
    required this.onEdit,
  });

  final String label;
  final String value;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        TextButton(onPressed: onEdit, child: const Text('Editar')),
      ],
    ),
  );
}
