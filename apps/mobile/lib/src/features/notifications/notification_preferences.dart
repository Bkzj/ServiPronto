import 'package:flutter/material.dart';

class NotificationPreferenceStore extends ChangeNotifier {
  NotificationPreferenceStore({bool transactionalNoticesEnabled = true})
    : _transactionalNoticesEnabled = transactionalNoticesEnabled;

  bool _transactionalNoticesEnabled;

  bool get transactionalNoticesEnabled => _transactionalNoticesEnabled;

  void setTransactionalNoticesEnabled(bool enabled) {
    if (_transactionalNoticesEnabled == enabled) {
      return;
    }

    _transactionalNoticesEnabled = enabled;
    notifyListeners();
  }
}

class NotificationPreferences extends StatelessWidget {
  const NotificationPreferences({super.key, required this.store});

  final NotificationPreferenceStore store;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Preferencias de avisos')),
      body: SafeArea(
        top: false,
        child: AnimatedBuilder(
          animation: store,
          builder: (context, _) {
            final enabled = store.transactionalNoticesEnabled;

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              children: [
                Text(
                  'Elegí si querés recibir avisos de la actividad.',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                Material(
                  color: colors.surfaceContainerHighest,
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: SwitchListTile.adaptive(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    title: const Text('Mensajes y servicios'),
                    subtitle: Text(enabled ? 'Activos' : 'Pausados'),
                    value: enabled,
                    onChanged: store.setTransactionalNoticesEnabled,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'El centro de avisos sigue disponible dentro de ServiPronto.',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
