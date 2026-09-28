import 'package:flutter/material.dart';

import '../activity/client_activity_tab.dart';
import 'explore_tab.dart';
import 'home_tab.dart';
import 'profile_tab.dart';
import '../jorge/jorge_chat_tab.dart';
import '../notifications/notification_center.dart';
import '../service_request/service_request_flow.dart';

enum ClientDestination {
  inicio('Inicio', 'Ir a Inicio', Icons.home_rounded),
  explorar('Explorar', 'Ir a Explorar', Icons.search_rounded),
  jorge('Jorge', 'Hablar con Jorge', Icons.auto_awesome_rounded),
  actividad('Actividad', 'Ir a Actividad', Icons.receipt_long_rounded),
  perfil('Perfil', 'Ir a Perfil', Icons.person_rounded);

  const ClientDestination(this.title, this.navigationLabel, this.icon);

  final String title;
  final String navigationLabel;
  final IconData icon;
}

class ClientShell extends StatefulWidget {
  const ClientShell({super.key});

  @override
  State<ClientShell> createState() => _ClientShellState();
}

class _ClientShellState extends State<ClientShell> {
  var _selectedIndex = 0;
  var _exploreQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _destinationBody()),
      bottomNavigationBar: SafeArea(
        top: false,
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) =>
              setState(() => _selectedIndex = index),
          destinations: [
            for (
              var index = 0;
              index < ClientDestination.values.length;
              index++
            )
              _navigationDestination(ClientDestination.values[index], index),
          ],
        ),
      ),
    );
  }

  Widget _destinationBody() =>
      switch (ClientDestination.values[_selectedIndex]) {
        ClientDestination.inicio => HomeTab(
          onExplore: (query) {
            setState(() {
              _exploreQuery = query;
              _selectedIndex = ClientDestination.explorar.index;
            });
          },
          onAskJorge: () =>
              setState(() => _selectedIndex = ClientDestination.jorge.index),
          onOpenNotifications: _openNotifications,
        ),
        ClientDestination.explorar => ExploreTab(
          query: _exploreQuery,
          onQueryChanged: (query) => setState(() => _exploreQuery = query),
          onAskJorge: () =>
              setState(() => _selectedIndex = ClientDestination.jorge.index),
          onRequestCategory: _openServiceRequest,
        ),
        ClientDestination.jorge => JorgeChatTab(
          onExploreCategories: _openExplore,
          onSearchService: _openExplore,
        ),
        ClientDestination.actividad => ClientActivityTab(onExplore: _openExplore),
        ClientDestination.perfil => const ProfileTab(),
      };

  void _openExplore() =>
      setState(() => _selectedIndex = ClientDestination.explorar.index);

  void _openServiceRequest(SampleCategory category) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ServiceRequestFlow(categoryName: category.name),
      ),
    );
  }

  void _openNotifications() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const NotificationCenter()),
    );
  }

  Widget _navigationDestination(ClientDestination destination, int index) {
    final isSelected = index == _selectedIndex;

    return Semantics(
      label: destination.navigationLabel,
      button: true,
      selected: isSelected,
      child: NavigationDestination(
        icon: destination == ClientDestination.jorge
            ? const _JorgeNavigationIcon()
            : Icon(destination.icon),
        selectedIcon: destination == ClientDestination.jorge
            ? const _JorgeNavigationIcon(selected: true)
            : Icon(destination.icon),
        label: destination.title,
      ),
    );
  }
}

class _JorgeNavigationIcon extends StatelessWidget {
  const _JorgeNavigationIcon({this.selected = false});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 48,
      height: 48,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: selected
              ? colorScheme.secondary
              : colorScheme.secondaryContainer,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Icon(
          Icons.auto_awesome_rounded,
          color: selected ? colorScheme.onSecondary : colorScheme.secondary,
        ),
      ),
    );
  }
}
