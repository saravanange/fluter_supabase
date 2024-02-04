import 'dart:convert';

import 'package:fluter_supabase/constants.dart';
import 'package:http/http.dart' as http;

import '../models/task.dart';

class ApiService {
  static Future<List<Task>> fetchTasks(String userId) async {
    try {
      final apiUrl =
          '${Constants.apiBaseURL}/api/hustles/get-current-week-tasks?userId=$userId';
      final response = await http.get(Uri.parse(apiUrl));
      print('Fetching tasks: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Assuming the tasks are nested under a key like 'daily_tasks'
        final List<dynamic> dailyTasks = data['daily_tasks'] ?? [];

        return dailyTasks.map((task) {
          return Task(
            title: task['title'] ?? '',
            description: task['description'] ?? '',
          );
        }).toList();
      } else {
        print('Error fetching tasks: ${response.reasonPhrase}');
        return [];
      }
    } catch (error) {
      print('Error fetching tasks: $error');
      return [];
    }
  }
}
