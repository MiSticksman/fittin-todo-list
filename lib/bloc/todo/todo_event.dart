import 'package:fittin_1/models/todo_model.dart';

abstract class TodosEvent {}

class LoadTodosEvent extends TodosEvent {
  // final List<TodoModel> todos;

  LoadTodosEvent();
}

class ChangeTodoStatusEvent extends TodosEvent {
  final TodoModel todo;
  ChangeTodoStatusEvent({required this.todo});
}

class ChangeTodoVisibleEvent extends TodosEvent {
  ChangeTodoVisibleEvent();
}

class AddTodoEvent extends TodosEvent {
  final TodoModel todo;

  AddTodoEvent({required this.todo});
}

class UpdateTodoEvent extends TodosEvent {
  final TodoModel changedTodo;
  final int index;

  UpdateTodoEvent({required this.changedTodo, required this.index});
}

class DeleteTodoEvent extends TodosEvent {
  final TodoModel todo;
  final int index;

  DeleteTodoEvent({required this.todo, required this.index});
}
