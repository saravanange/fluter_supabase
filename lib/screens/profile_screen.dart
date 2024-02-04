import 'package:fluter_supabase/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/task.dart'; // Import Task class
import '../services/api_service.dart'; // Import ApiService

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final supabase = Supabase.instance.client;
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    // Fetch tasks when the screen is initialized
    fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;
    final profileImageUrl = user?.userMetadata?['avatar_url'];
    final fullName = user?.userMetadata?['full_name'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          TextButton(
            onPressed: () async {
              await supabase.auth.signOut();
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
            child: const Text('Sign out'),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (profileImageUrl != null)
              ClipOval(
                child: Image.network(
                  profileImageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16),
            Text(
              fullName ?? '',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 32),
            // Display tasks
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(tasks[index].title),
                      subtitle: Text(tasks[index].description),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void fetchTasks() async {
    final userId =
        '32d7c56a-aadc-4faf-88da-e60e752981f8'; // Replace with actual user ID
    tasks = await ApiService.fetchTasks(userId);

    // Update the UI with the fetched tasks
    if (mounted) {
      setState(() {});
    }
  }
}
