import 'package:flutter/material.dart';

import 'notification_preferences.dart';

class NotificationCenter extends StatefulWidget {
  const NotificationCenter({super.key});

  static const sampleTitles = [
    'Tu solicitud fue enviada',
    'Jorge te dejó una recomendación',
  ];

  @override
  State<NotificationCenter> createState() => _NotificationCenterState();
}

class _NotificationCenterState extends State<NotificationCenter> {
  final _preferences = NotificationPreferenceStore();
  final _notices = <_LocalNotice>[
    const _LocalNotice(
      title: 'Tu solicitud fue enviada',
      message: 'Cuando haya una novedad, te la vamos a mostrar acá.',
    ),
    const _LocalNotice(
      title: 'Jorge te dejó una recomendación',
      message: 'Podés volver a la conversación cuando quieras.',
    ),
  ];

  void _markAsRead(int index) {
    setState(() => _notices[index] = _notices[index].copyWith(isRead: true));
  }

  @override
  Widget build(BuildContext context) {
    final unread = [
      for (var index = 0; index < _notices.length; index++)
        if (!_notices[index].isRead) (index, _notices[index]),
    ];
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Avisos'),
        actions: [
          IconButton(
            onPressed: _openPreferences,
            tooltip: 'Configurar avisos',
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: unread.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Semantics(
                    liveRegion: true,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.notifications_none_rounded,
                          size: 44,
                          color: colors.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No tenés avisos nuevos',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Los avisos importantes de tu actividad van a aparecer acá.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                itemCount: unread.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, listIndex) {
                  final (noticeIndex, notice) = unread[listIndex];
                  return Material(
                    color: colors.surfaceContainerHighest,
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: InkWell(
                      onTap: () => _markAsRead(noticeIndex),
                      customBorder: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Semantics(
                        button: true,
                        label: '${notice.title}. Sin leer',
                        child: ExcludeSemantics(
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.notifications_active_rounded,
                                  color: colors.secondary,
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        notice.title,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(fontWeight: FontWeight.w800),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        notice.message,
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Sin leer',
                                        style: theme.textTheme.labelLarge?.copyWith(
                                          color: colors.primary,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _openPreferences() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => NotificationPreferences(store: _preferences),
      ),
    );
  }
}

class _LocalNotice {
  const _LocalNotice({
    required this.title,
    required this.message,
    this.isRead = false,
  });

  final String title;
  final String message;
  final bool isRead;

  _LocalNotice copyWith({bool? isRead}) => _LocalNotice(
    title: title,
    message: message,
    isRead: isRead ?? this.isRead,
  );
}
