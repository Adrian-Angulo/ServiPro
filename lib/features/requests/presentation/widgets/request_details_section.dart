import 'package:flutter/material.dart';
import 'package:servi_pro/features/requests/presentation/widgets/title_input_field.dart';

class RequestDetailsSection extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  const RequestDetailsSection({
    super.key,
    required this.titleController,
    required this.descriptionController,
  });

  @override
  State<RequestDetailsSection> createState() => _RequestDetailsSectionState();
}

class _RequestDetailsSectionState extends State<RequestDetailsSection> {
  bool _titleHasFocus = false;
  bool _descriptionHasFocus = false;
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _titleFocusNode.addListener(() {
      setState(() => _titleHasFocus = _titleFocusNode.hasFocus);
    });
    _descriptionFocusNode.addListener(() {
      setState(() => _descriptionHasFocus = _descriptionFocusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleInputField(
            controller: widget.titleController,
            focusNode: _titleFocusNode,
            hasFocus: _titleHasFocus,
            labelText: "Titulo de la solicitud",
            hintText: "Ej. Reparación de Grifo",
          ),

          TitleInputField(
            controller: widget.descriptionController,
            focusNode: _descriptionFocusNode,
            hasFocus: _descriptionHasFocus,
            labelText: "Descripción breve",
            hintText:
                'Describe el problema o servicio que necesitas. Incluye detalles importantes como urgencia, materiales necesarios, etc.',
            icon: Icons.description_outlined,
            maxLines: 5,
          ),
        ],
      ),
    );
  }
}
