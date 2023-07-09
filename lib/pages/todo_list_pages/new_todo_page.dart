import 'package:fittin_1/bloc/todo/todo_bloc.dart';
import 'package:fittin_1/bloc/todo/todo_event.dart';
import 'package:fittin_1/bloc/todo/todo_state.dart';
import 'package:fittin_1/models/todo_model.dart';
import 'package:fittin_1/widgets/todo_widgets/todo_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class NewTodoPage extends StatefulWidget {
  const NewTodoPage({super.key});

  @override
  State<NewTodoPage> createState() => _NewTodoPageState();
}

class _NewTodoPageState extends State<NewTodoPage> {
  String text = '';
  bool showDeadline = false;
  DateTime? deadline = null;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocListener<TodosBloc, TodosState>(
          listener: (context, state) {
            if (state is TodosLoadedState) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Задача добавлена в список')));
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: const Icon(Icons.close),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      onPressed: text.isNotEmpty
                          ? () {
                              context.read<TodosBloc>().add(
                                    AddTodoEvent(
                                      todo: TodoModel(
                                          text: text,
                                          deadline: deadline ?? null),
                                    ),
                                  );
                              Navigator.pop(context);
                            }
                          : null,
                      child: Text(
                        'СОХРАНИТЬ',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w700,
                          height: 16 / 20,
                        ),
                      ),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  child: todoTextFieldWidget(
                      hintText: 'Здесь будут мои заметки',
                      func: (value) {
                        setState(() {
                          text = value;
                        });
                      }),
                ),
                todoDeadlineWidget(
                    context: context,
                    deadline: deadline,
                    showDeadline: showDeadline,
                    func: (value) {
                      setState(() {
                        showDeadline = value;
                      });
                    }),
                TextButton(
                  onPressed: showDeadline
                      ? () async {
                          final time = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 30),
                            ),
                          );
                          setState(() {
                            deadline = time;
                          });
                        }
                      : null,
                  child: const Text('Выбрать дату'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
