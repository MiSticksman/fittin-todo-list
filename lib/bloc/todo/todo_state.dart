// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fittin_1/models/todo_model.dart';

abstract class TodosState {}

class TodosLoadingState extends TodosState {}

class TodosLoadedState extends TodosState {
  final int numberOfCompleted;
  final List<TodoModel> todos;
  bool completeTasksVisible;

  TodosLoadedState({required this.todos, required this.numberOfCompleted, this.completeTasksVisible=true});
}
