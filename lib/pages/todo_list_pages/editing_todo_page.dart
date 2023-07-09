import 'package:fittin_1/bloc/todo/todo_bloc.dart';
import 'package:fittin_1/bloc/todo/todo_event.dart';
import 'package:fittin_1/models/todo_model.dart';
import 'package:fittin_1/widgets/todo_widgets/todo_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TodoEditingPage extends StatefulWidget {
  int index;
  TodoModel todo;
  TodoEditingPage({super.key, required this.index, required this.todo});

  @override
  State<TodoEditingPage> createState() => _TodoEditingPageState();
}

class _TodoEditingPageState extends State<TodoEditingPage> {
  late String text;
  late DateTime? deadline;
  late bool showDeadline;

  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    text = widget.todo.text;
    deadline = widget.todo.deadline;
    showDeadline = deadline == null ? false : true;
    textController.text = text;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                                  UpdateTodoEvent(
                                    changedTodo: TodoModel(
                                      text: text,
                                      deadline: deadline ?? null,
                                    ),
                                    index: widget.index,
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
                  text: text,
                  func: (value) {
                    setState(() {
                      text = value;
                    });
                  },
                  controller: textController,
                ),
              ),
              // todoDeadlineWidget(
              //   deadline: deadline,
              //   showDeadline: showDeadline,
              //   func: (value) {
              //     setState(() {
              //       showDeadline = value;
              //     });
              //   },
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const Text('Дедлайн'),
                      deadline == null
                          ? Container()
                          : Text(
                              DateFormat.yMMMMd().format(deadline!).toString(),
                            ),
                    ],
                  ),
                  Checkbox(
                    value: showDeadline,
                    onChanged: (value) {
                      setState(() {
                        showDeadline = value ?? false;
                        if (showDeadline == false) {
                          deadline = null;
                        }
                      });
                    },
                  ),
                ],
              ),

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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.background,
                    elevation: 0),
                onPressed: () {
                  context.read<TodosBloc>().add(
                      DeleteTodoEvent(todo: widget.todo, index: widget.index));
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.delete_outline, color: Colors.red),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Удалить',
                      style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        height: 15 / 19,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
