import 'package:fittin_1/bloc/todo/todo_bloc.dart';
import 'package:fittin_1/bloc/todo/todo_event.dart';
import 'package:fittin_1/bloc/todo/todo_state.dart';
import 'package:fittin_1/models/todo_model.dart';
import 'package:fittin_1/pages/todo_list_pages/editing_todo_page.dart';
import 'package:fittin_1/pages/todo_list_pages/new_todo_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeData.colorScheme.background,
        centerTitle: true,
        title: Text(
          'Мои дела',
          style: themeData.textTheme.headlineSmall?.copyWith(),
        ),
      ),
      body: BlocBuilder<TodosBloc, TodosState>(
        builder: (context, state) {
          if (state is TodosLoadingState) {
            return const CircularProgressIndicator();
          }
          if (state is TodosLoadedState) {
            return SafeArea(
              top: false,
              child: Column(
                children: [
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 17, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            'Выполнено - ${state.numberOfCompleted}',
                            style: themeData.textTheme.headlineSmall?.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              height: 15 / 19,
                              color: const Color(0xFFAEAEAE),
                            ),
                          ),
                        ),
                        Container(
                            child: GestureDetector(
                          onTap: () {
                            context
                                .read<TodosBloc>()
                                .add(ChangeTodoVisibleEvent());
                          },
                          child: Icon(
                              state.completeTasksVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: themeData.colorScheme.primary),
                        ))
                      ],
                    ),
                  ),
                  Flexible(
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 17, vertical: 5),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.todos.length,
                        itemBuilder: ((context, index) {
                          TodoModel todo = state.todos[index];
                          return Dismissible(
                            key: ObjectKey(todo),
                            background: Container(
                              alignment: AlignmentDirectional.centerStart,
                              color: Colors.green,
                              child: Icon(
                                todo.done == false ? Icons.done : Icons.close,
                                color: themeData.colorScheme.surface,
                              ),
                            ),
                            secondaryBackground: Container(
                              alignment: AlignmentDirectional.centerEnd,
                              color: Colors.red,
                              child: Icon(
                                Icons.delete,
                                color: themeData.colorScheme.surface,
                              ),
                            ),
                            onDismissed: (DismissDirection direction) {
                              if (direction == DismissDirection.endToStart) {
                                context.read<TodosBloc>().add(
                                    DeleteTodoEvent(todo: todo, index: index));
                              }

                              if (direction == DismissDirection.startToEnd) {
                                context
                                    .read<TodosBloc>()
                                    .add(ChangeTodoStatusEvent(todo: todo));
                              }
                            },
                            child: CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: todo.done,
                              onChanged: (value) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => TodoEditingPage(
                                        index: index, todo: todo),
                                  ),
                                );
                              },
                              title: Text(
                                todo.text,
                                style: themeData.textTheme.headlineSmall
                                    ?.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        height: 15 / 19,
                                        decoration: todo.done == false
                                            ? TextDecoration.none
                                            : TextDecoration.lineThrough),
                              ),
                              subtitle: todo.deadline == null
                                  ? null
                                  : Text(
                                      DateFormat.yMMMMd()
                                          .format(todo.deadline!)
                                          .toString(),
                                      style: themeData.textTheme.headlineSmall
                                          ?.copyWith(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              height: 13 / 19,
                                              decoration: todo.done == false
                                                  ? TextDecoration.none
                                                  : TextDecoration.lineThrough),
                                    ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Text('Что-то пошло не так');
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const NewTodoPage(),
              ),
            );
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
