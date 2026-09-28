import 'package:flutter/material.dart';

class JorgeChatTab extends StatefulWidget {
  const JorgeChatTab({
    super.key,
    this.onExploreCategories,
    this.onSearchService,
    this.responseAvailable = true,
  });

  final VoidCallback? onExploreCategories;
  final VoidCallback? onSearchService;
  final bool responseAvailable;

  @override
  State<JorgeChatTab> createState() => _JorgeChatTabState();
}

class _JorgeChatTabState extends State<JorgeChatTab> {
  final _messageController = TextEditingController();
  final List<_ChatEntry> _entries = [];
  var _hasSampleAttachment = false;
  var _showRecommendation = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) {
      setState(
        () => _entries.add(
          const _ChatEntry.error('Contame qué pasó en una frase corta.'),
        ),
      );
      return;
    }

    setState(() {
      _entries.add(_ChatEntry.client(message));
      _messageController.clear();
      if (!widget.responseAvailable) {
        _entries.add(
          const _ChatEntry.error(
            'Ahora no puedo responder desde acá.\nNo envié ninguna solicitud.',
          ),
        );
        return;
      }
      _entries.add(
        const _ChatEntry.jorge(
          'Entiendo. Contame si es en toda la casa o solo en un ambiente.',
        ),
      );
      _showRecommendation = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Column(
          children: [
            Row(
              children: [
                Semantics(
                  label: 'Jorge, el asistente de ServiPronto',
                  image: true,
                  child: ExcludeSemantics(
                    child: Icon(
                      Icons.pets_rounded,
                      color: colors.secondary,
                      size: 42,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Semantics(
                        header: true,
                        child: Text(
                          'Hola, soy Jorge',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Text(
                        'Te ayudo a ordenar el problema.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 12),
                children: [
                  _JorgeBubble(
                    child: Text(
                      'Contame qué pasó y lo vemos paso a paso.',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                  if (_hasSampleAttachment) ...[
                    const SizedBox(height: 12),
                    const _SampleAttachment(),
                  ],
                  for (final entry in _entries) ...[
                    const SizedBox(height: 12),
                    _MessageBubble(entry: entry),
                  ],
                  if (_showRecommendation) ...[
                    const SizedBox(height: 12),
                    _RecommendationCard(
                      onExplore: widget.onExploreCategories,
                    ),
                  ],
                  if (widget.onExploreCategories != null ||
                      widget.onSearchService != null) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        if (widget.onExploreCategories != null)
                          TextButton(
                            onPressed: widget.onExploreCategories,
                            child: const Text('Explorar categorías'),
                          ),
                        if (widget.onSearchService != null)
                          TextButton(
                            onPressed: widget.onSearchService,
                            child: const Text('Buscar un servicio'),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            DecoratedBox(
              decoration: ShapeDecoration(
                color: colors.surfaceContainerHighest,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => setState(() => _hasSampleAttachment = true),
                    tooltip: 'Adjuntar foto de muestra',
                    icon: const Icon(Icons.add_photo_alternate_outlined),
                  ),
                  Expanded(
                    child: Semantics(
                      label: 'Contale a Jorge qué pasó',
                      textField: true,
                      child: TextField(
                        controller: _messageController,
                        minLines: 1,
                        maxLines: 3,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                        decoration: const InputDecoration(
                          hintText: 'Contale qué pasó',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton.filled(
                    onPressed: _sendMessage,
                    tooltip: 'Enviar mensaje a Jorge',
                    icon: const Icon(Icons.arrow_upward_rounded),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({this.onExplore});

  final VoidCallback? onExplore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Semantics(
      container: true,
      label: 'Recomendación orientativa de Jorge',
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: colors.surfaceContainerHigh,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Podría ser electricidad',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Es una orientación. No confirma disponibilidad ni crea una solicitud.',
                style: theme.textTheme.bodyMedium,
              ),
              if (onExplore != null) ...[
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: onExplore,
                  icon: const Icon(Icons.search_rounded),
                  label: const Text('Ver electricidad'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _JorgeBubble extends StatelessWidget {
  const _JorgeBubble({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.centerLeft,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: colors.secondaryContainer,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.entry});

  final _ChatEntry entry;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isClient = entry.kind == _ChatEntryKind.client;
    final isError = entry.kind == _ChatEntryKind.error;
    final color = isClient
        ? colors.primaryContainer
        : isError
        ? colors.errorContainer
        : colors.secondaryContainer;
    final textColor = isClient
        ? colors.onPrimaryContainer
        : isError
        ? colors.onErrorContainer
        : colors.onSecondaryContainer;

    return Align(
      alignment: isClient ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 340),
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: color,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              entry.message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SampleAttachment extends StatelessWidget {
  const _SampleAttachment();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Semantics(
      label: 'Foto de muestra adjunta',
      image: true,
      child: ExcludeSemantics(
        child: _JorgeBubble(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.image_outlined, color: colors.secondary),
              const SizedBox(width: 10),
              const Text('Foto de muestra'),
            ],
          ),
        ),
      ),
    );
  }
}

enum _ChatEntryKind { client, jorge, error }

class _ChatEntry {
  const _ChatEntry.client(this.message) : kind = _ChatEntryKind.client;
  const _ChatEntry.jorge(this.message) : kind = _ChatEntryKind.jorge;
  const _ChatEntry.error(this.message) : kind = _ChatEntryKind.error;

  final String message;
  final _ChatEntryKind kind;
}
