import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/subject_repository.dart';
 
class SubjectListScreen extends StatefulWidget {
  const SubjectListScreen({super.key});
 
  @override
  State<SubjectListScreen> createState() => _SubjectListScreenState();
}
 
class _SubjectListScreenState extends State<SubjectListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<SubjectViewModel>(context, listen: false).loadSubjects());
  }
 
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SubjectViewModel>(context);
 
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {context.go('/materias/create');},
      ),
      body: vm.loading
          ? const Center(child: CircularProgressIndicator())
           : vm.error != null
        ? Center(
            child: Text(
              vm.error!,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
          : vm.subjects.isEmpty
              ? const Center(child: Text('No hay materias'))
              : ListView.builder(
                  itemCount: vm.subjects.length,
                  itemBuilder: (_, i) {
                    final s = vm.subjects[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: const Icon(Icons.menu_book),
                        title: Text(s.name ?? ''),
                      ),
                    );
                  },
                ),
    );
  }
}