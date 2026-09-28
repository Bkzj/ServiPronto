import 'package:flutter/material.dart';

enum _RequestStep { description, timing, modality, location, review }

enum _RequestTiming { urgent, scheduled }

enum _RequestModality { atHome }

/// Borrador visual local: todavía no crea, envía ni contrata un servicio.
class ServiceRequestFlow extends StatefulWidget {
  const ServiceRequestFlow({super.key, required this.categoryName});

  final String categoryName;

  @override
  State<ServiceRequestFlow> createState() => _ServiceRequestFlowState();
}

class _ServiceRequestFlowState extends State<ServiceRequestFlow> {
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _recipientNameController = TextEditingController();
  final _recipientContactController = TextEditingController();
  var _step = _RequestStep.description;
  _RequestTiming? _timing;
  _RequestModality? _modality;
  var _isForFamily = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    _recipientNameController.dispose();
    _recipientContactController.dispose();
    super.dispose();
  }

  void _continue() {
    switch (_step) {
      case _RequestStep.description:
        if (_descriptionController.text.trim().isNotEmpty) {
          setState(() => _step = _RequestStep.timing);
        }
      case _RequestStep.timing:
        if (_timing != null) {
          setState(() => _step = _RequestStep.modality);
        }
      case _RequestStep.modality:
        if (_modality != null) {
          setState(() => _step = _RequestStep.location);
        }
      case _RequestStep.location:
        if (_locationController.text.trim().isNotEmpty) {
          setState(() => _step = _RequestStep.review);
        }
      case _RequestStep.review:
        break;
    }
  }

  void _back() {
    setState(() {
      _step = switch (_step) {
        _RequestStep.description => _RequestStep.description,
        _RequestStep.timing => _RequestStep.description,
        _RequestStep.modality => _RequestStep.timing,
        _RequestStep.location => _RequestStep.modality,
        _RequestStep.review => _RequestStep.location,
      };
    });
  }

  String get _guide => switch (widget.categoryName) {
    'Plomería' => 'Contá dónde aparece la pérdida o qué dejó de funcionar.',
    'Mudanzas y fletes' => 'Contá qué necesitás mover y entre qué zonas.',
    'Clases particulares' => 'Contá qué materia o tema querés practicar.',
    _ => 'Contá brevemente qué necesitás resolver.',
  };

  @override
  Widget build(BuildContext context) {
    final isFirstStep = _step == _RequestStep.description;
    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitud de ${widget.categoryName}'),
        leading: isFirstStep
            ? null
            : IconButton(
                onPressed: _back,
                tooltip: 'Volver',
                icon: const Icon(Icons.arrow_back_rounded),
              ),
      ),
      body: SafeArea(
        top: false,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: switch (_step) {
            _RequestStep.description => _DescriptionStep(
              key: const ValueKey('request-description'),
              controller: _descriptionController,
              guide: _guide,
              onContinue: _continue,
            ),
            _RequestStep.timing => _TimingStep(
              key: const ValueKey('request-timing'),
              selected: _timing,
              onSelected: (value) => setState(() => _timing = value),
              onContinue: _continue,
            ),
            _RequestStep.modality => _ModalityStep(
              key: const ValueKey('request-modality'),
              selected: _modality,
              onSelected: (value) => setState(() => _modality = value),
              onContinue: _continue,
            ),
            _RequestStep.location => _LocationStep(
              key: const ValueKey('request-location'),
              controller: _locationController,
              isForFamily: _isForFamily,
              recipientNameController: _recipientNameController,
              recipientContactController: _recipientContactController,
              onFamilyChanged: (value) => setState(() => _isForFamily = value),
              onContinue: _continue,
            ),
            _RequestStep.review => _ReviewStep(
              key: const ValueKey('request-review'),
              categoryName: widget.categoryName,
              description: _descriptionController.text.trim(),
              timing: _timing!,
              location: _locationController.text.trim(),
              recipient: _isForFamily
                  ? _Recipient(
                      name: _recipientNameController.text.trim(),
                      contact: _recipientContactController.text.trim(),
                    )
                  : null,
            ),
          },
        ),
      ),
    );
  }
}

class _RequestStepLayout extends StatelessWidget {
  const _RequestStepLayout({
    required this.title,
    required this.help,
    required this.child,
    this.action,
  });

  final String title;
  final String help;
  final Widget child;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Column(
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
            child,
            if (action != null) ...[const SizedBox(height: 28), action!],
          ],
        ),
      ),
    );
  }
}

class _DescriptionStep extends StatelessWidget {
  const _DescriptionStep({
    super.key,
    required this.controller,
    required this.guide,
    required this.onContinue,
  });

  final TextEditingController controller;
  final String guide;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) => _RequestStepLayout(
    title: 'Contanos qué necesitás',
    help: guide,
    action: FilledButton(onPressed: onContinue, child: const Text('Continuar')),
    child: TextField(
      controller: controller,
      minLines: 4,
      maxLines: 6,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        labelText: 'Contanos qué necesitás',
        alignLabelWithHint: true,
      ),
    ),
  );
}

class _TimingStep extends StatelessWidget {
  const _TimingStep({
    super.key,
    required this.selected,
    required this.onSelected,
    required this.onContinue,
  });

  final _RequestTiming? selected;
  final ValueChanged<_RequestTiming> onSelected;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) => _RequestStepLayout(
    title: '¿Cuándo lo necesitás?',
    help: 'Elegí la urgencia. No confirma disponibilidad.',
    action: FilledButton(onPressed: onContinue, child: const Text('Continuar')),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ChoiceButton(
          label: 'Urgente',
          description: 'Lo antes posible',
          selected: selected == _RequestTiming.urgent,
          onPressed: () => onSelected(_RequestTiming.urgent),
        ),
        const SizedBox(height: 12),
        _ChoiceButton(
          label: 'Programado',
          description: 'Elegís un momento más adelante',
          selected: selected == _RequestTiming.scheduled,
          onPressed: () => onSelected(_RequestTiming.scheduled),
        ),
      ],
    ),
  );
}

class _ModalityStep extends StatelessWidget {
  const _ModalityStep({
    super.key,
    required this.selected,
    required this.onSelected,
    required this.onContinue,
  });

  final _RequestModality? selected;
  final ValueChanged<_RequestModality> onSelected;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) => _RequestStepLayout(
    title: '¿Cómo querés resolverlo?',
    help: 'Para este servicio, la atención es en tu domicilio.',
    action: FilledButton(onPressed: onContinue, child: const Text('Continuar')),
    child: _ChoiceButton(
      label: 'A domicilio',
      description: 'Solo se comparte para coordinar la visita',
      selected: selected == _RequestModality.atHome,
      onPressed: () => onSelected(_RequestModality.atHome),
    ),
  );
}

class _LocationStep extends StatelessWidget {
  const _LocationStep({
    super.key,
    required this.controller,
    required this.isForFamily,
    required this.recipientNameController,
    required this.recipientContactController,
    required this.onFamilyChanged,
    required this.onContinue,
  });

  final TextEditingController controller;
  final bool isForFamily;
  final TextEditingController recipientNameController;
  final TextEditingController recipientContactController;
  final ValueChanged<bool> onFamilyChanged;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) => _RequestStepLayout(
    title: '¿Dónde lo necesitás?',
    help: 'Usamos esta referencia solo para coordinar el servicio.',
    action: FilledButton(
      onPressed: onContinue,
      child: const Text('Revisar solicitud'),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Zona o dirección aproximada',
            hintText: 'Ej.: Centro, Tandil',
          ),
        ),
        const SizedBox(height: 20),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Es para otra persona'),
          subtitle: const Text('Sumá un contacto para coordinar'),
          value: isForFamily,
          onChanged: onFamilyChanged,
        ),
        if (isForFamily) ...[
          const SizedBox(height: 12),
          TextField(
            controller: recipientNameController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Nombre de quien recibe el servicio',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: recipientContactController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Contacto de quien recibe el servicio',
            ),
          ),
        ],
      ],
    ),
  );
}

class _ReviewStep extends StatelessWidget {
  const _ReviewStep({
    super.key,
    required this.categoryName,
    required this.description,
    required this.timing,
    required this.location,
    required this.recipient,
  });

  final String categoryName;
  final String description;
  final _RequestTiming timing;
  final String location;
  final _Recipient? recipient;

  @override
  Widget build(BuildContext context) => _RequestStepLayout(
    title: 'Revisá tu solicitud',
    help: 'Revisá lo que contaste antes de seguir.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ReviewLine(label: 'Servicio', value: categoryName),
        _ReviewLine(label: 'Necesidad', value: description),
        _ReviewLine(
          label: 'Momento',
          value: timing == _RequestTiming.urgent
              ? 'Urgente · Lo antes posible'
              : 'Programado',
        ),
        _ReviewLine(label: 'Lugar', value: 'A domicilio · $location'),
        if (recipient != null)
          _ReviewLine(
            label: 'Recibe el servicio',
            value: '${recipient!.name} · ${recipient!.contact}',
          ),
        const SizedBox(height: 20),
        Semantics(
          liveRegion: true,
          child: Text(
            'Todavía no se envía ni se contrata nada.',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    ),
  );
}

class _Recipient {
  const _Recipient({required this.name, required this.contact});

  final String name;
  final String contact;
}

class _ReviewLine extends StatelessWidget {
  const _ReviewLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
      ],
    ),
  );
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    required this.label,
    required this.description,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final String description;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      selected: selected,
      button: true,
      label: '$label. $description',
      child: Material(
        color: selected
            ? colors.primaryContainer
            : colors.surfaceContainerHighest,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        child: InkWell(
          onTap: onPressed,
          customBorder: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 72),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          label,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 2),
                        Text(description),
                      ],
                    ),
                  ),
                  if (selected)
                    Icon(Icons.check_circle_rounded, color: colors.primary),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
