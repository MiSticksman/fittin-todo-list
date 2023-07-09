import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget todoTextFieldWidget(
    {String? hintText,
    String text = '',
    void Function(String value)? func,
    TextEditingController? controller}) {
  return Card(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(20),
      ),
    ),
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller,
        onChanged: (value) => func!(value),
        maxLines: 6,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    ),
  );
}

Widget todoDeadlineWidget(
    {required BuildContext context,
    DateTime? deadline,
    bool showDeadline = false,
    void Function(bool value)? func}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Дедлайн',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 16 / 19,
                ),
          ),
          const SizedBox(
            height: 5,
          ),
          deadline == null
              ? Container()
              : Text(
                  DateFormat.yMMMMd().format(deadline).toString(),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 16 / 19,
                      ),
                ),
        ],
      ),
      Checkbox(
        value: showDeadline,
        onChanged: (value) {
          func!(value ?? false);
        },
      ),
    ],
  );
}
