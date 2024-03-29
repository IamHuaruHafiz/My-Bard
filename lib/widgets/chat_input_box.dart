import 'package:flutter/material.dart';

class ChatInputBox extends StatelessWidget {
  const ChatInputBox({
    super.key,
    this.controller,
    this.onSend,
  });
  final TextEditingController? controller;
  final VoidCallback? onSend;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Theme.of(context).cardTheme.color,
      margin: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: controller,
            minLines: 1,
            maxLines: 6,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.w400, fontSize: 18),
            cursorColor: Theme.of(context).colorScheme.inversePrimary,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              hintText: "Enter prompt here",
              border: InputBorder.none,
            ),
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
          )),
          Padding(
            padding: const EdgeInsets.all(4),
            child: FloatingActionButton.small(
              onPressed: onSend,
              child: const Icon(Icons.send_rounded),
            ),
          )
        ],
      ),
    );
  }
}
