import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state_notifier/user_notifier.dart';

class UserScreen extends ConsumerStatefulWidget {
  const UserScreen({super.key});

  @override
  ConsumerState<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends ConsumerState<UserScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final notifier = ref.read(userNotifierProvider.notifier);
    notifier.loadUsers(reset: true); // initial load

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        // when near bottom, load next page
        notifier.loadUsers();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userNotifierProvider);
    final notifier = ref.read(userNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Paginated Users')),
      body: userAsync.when(
        data: (list) => ListView.builder(
          controller: _scrollController,
          itemCount: list.length + (notifier.isLoadingMore ? 1 : 0),
          itemBuilder: (ctx, i) {
            if (i < list.length) {
              final user = list[i];
              return ListTile(
                leading: CircleAvatar(child: Text(user.firstName[0])),
                title: Text('${user.firstName} ${user.lastName}'),
                subtitle: Text('ID: ${user.id}'),
              );
            } else {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
