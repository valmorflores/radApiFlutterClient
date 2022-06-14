import 'package:flutter/material.dart';

class WidgetPageFilterInput extends StatelessWidget {
  String? title;
  GestureTapCallback? onTap;
  BuildContext context;
  TextEditingController searchTextController;
  String? workspace;
  String? hint;
  bool? showWorkspace;

  WidgetPageFilterInput({
    Key? key,
    this.title,
    this.hint,
    this.onTap,
    required this.searchTextController,
    required this.context,
    this.showWorkspace,
    this.workspace,
  }) : super(key: key) {
    showWorkspace ??= false;
    workspace ??= '';
    hint ??= 'Filtro';
    title ??= '';
  }

  @override
  Widget build(BuildContext context) {
    return render();
  }

  render() {
    return Container(
      height: 60.0,
      padding: const EdgeInsets.only(left: 20, top: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20.0,
            offset: Offset(0, 10.0),
          ),
        ],
      ),
      child: TextField(
        controller: searchTextController,
        decoration: InputDecoration(
          suffixIcon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.onBackground,
            size: 20.0,
          ),
          border: InputBorder.none,
          hintText: hint,
        ),
      ),
    );
  }
}
