import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_template_riverpod/core/widgets/common_network_image.dart';

import '../../../core/utils/language.dart';
import '../state_notifier/people_notifier.dart';

class PeopleScreen extends ConsumerStatefulWidget {
  const PeopleScreen({super.key});

  @override
  ConsumerState<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends ConsumerState<PeopleScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(peopleNotifierProvider.notifier).loadPeoples();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(peopleNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text(Languages.people)),
      body: state.when(
        data: (data) => ListView.builder(
          itemCount: data.length,
          itemBuilder: (_, i) {
            final person = data[i];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: person.image.isNotEmpty
                    ? CommonNetworkImage(imageUrl: person.image)
                    : Text(person.firstName[0].toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              title: Text('${person.firstName} ${person.lastName}', style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(person.email, style: const TextStyle(color: Colors.grey)),
              onTap: () {},
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }
}
