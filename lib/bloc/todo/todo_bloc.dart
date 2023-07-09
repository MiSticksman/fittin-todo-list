import 'package:fittin_1/bloc/todo/todo_event.dart';
import 'package:fittin_1/bloc/todo/todo_state.dart';
import 'package:fittin_1/models/todo_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {

  final List<TodoModel> _todos = [];
  int numberOfCompleted = 0;

  TodosBloc() : super(TodosLoadingState()) {
    on<LoadTodosEvent>(_onLoadTodos);
    on<ChangeTodoStatusEvent>(_onChangeTodoStatus);
    on<AddTodoEvent>(_onAddTodos);
    on<UpdateTodoEvent>(_onUpdateTodos);
    on<DeleteTodoEvent>(_onDeleteTodos);
    on<ChangeTodoVisibleEvent>(_onChangeVisible);
  }

  void _onLoadTodos(LoadTodosEvent event, Emitter<TodosState> emit) {
    numberOfCompleted = _todos.where((todo) => todo.done).length;
    emit(
      TodosLoadedState(todos: _todos, numberOfCompleted: numberOfCompleted),
    );
  }

  List<TodoModel> getVisibleTodos(
      List<TodoModel> todos, bool completeTasksVisible) {
    if (completeTasksVisible) {
      return todos;
    } else {
      return todos.where((todo) => todo.done == false).toList();
    }
  }

  void _onChangeTodoStatus(
      ChangeTodoStatusEvent event, Emitter<TodosState> emit) {
    final state = this.state;
    if (state is TodosLoadedState) {
      for (var i = 0; i < _todos.length; i++) {
        if (_todos[i] == event.todo) {
          _todos[i].done ? numberOfCompleted-- : numberOfCompleted++;
          _todos[i] = _todos[i].copyWith(done: !_todos[i].done);
          break;
        }
      }
      emit(TodosLoadedState(
          todos: _todos, numberOfCompleted: numberOfCompleted));
    }
  }

  void _onChangeVisible(
      ChangeTodoVisibleEvent event, Emitter<TodosState> emit) {
    final state = this.state;
    if (state is TodosLoadedState) {
      state.completeTasksVisible = !state.completeTasksVisible;
      final todos = getVisibleTodos(_todos, state.completeTasksVisible);
      var numberOfCompleted = _todos.where((todo) => todo.done).length;
      emit(TodosLoadedState(
          todos: todos,
          completeTasksVisible: state.completeTasksVisible,
          numberOfCompleted: numberOfCompleted));
    }
  }

  void _onAddTodos(AddTodoEvent event, Emitter<TodosState> emit) {
    final state = this.state;
    if (state is TodosLoadedState) {
      _todos.add(event.todo);
      emit(TodosLoadedState(
          todos: _todos, numberOfCompleted: numberOfCompleted));
    }
  }

  void _onUpdateTodos(UpdateTodoEvent event, Emitter<TodosState> emit) {
    final state = this.state;
    if (state is TodosLoadedState) {
      for (var i = 0; i < _todos.length; i++) {
        if (i == event.index) {
          _todos[i] = event.changedTodo.copyWith(
            text: event.changedTodo.text,
            deadline: event.changedTodo.deadline,
            done: _todos[i].done,
          );
          break;
        }
      }
      emit(TodosLoadedState(
          todos: _todos, numberOfCompleted: numberOfCompleted));
    }
  }

  void _onDeleteTodos(DeleteTodoEvent event, Emitter<TodosState> emit) {
    final state = this.state;
    if (state is TodosLoadedState) {
      if (_todos[event.index].done) {
        numberOfCompleted--;
      }
      _todos.removeAt(event.index);
      emit(TodosLoadedState(todos: _todos, numberOfCompleted: numberOfCompleted));
    }
  }
}
