import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProjectDescriptionWidget extends StatefulWidget {
  final String description;
  final Function(String) onDescriptionChanged;

  const ProjectDescriptionWidget({
    super.key,
    required this.description,
    required this.onDescriptionChanged,
  });

  @override
  State<ProjectDescriptionWidget> createState() =>
      _ProjectDescriptionWidgetState();
}

class _ProjectDescriptionWidgetState extends State<ProjectDescriptionWidget> {
  late QuillController _quillController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _quillController = QuillController.basic();
    if (widget.description.isNotEmpty) {
      // Remove this line - Document.fromPlainText doesn't exist
      // _quillController.document = Document.fromPlainText(widget.description);
      // Instead, create a document from JSON or use the document property directly
    }

    _quillController.addListener(() {
      final text = _quillController.document.toPlainText();
      widget.onDescriptionChanged(text);
    });
  }

  @override
  void dispose() {
    _quillController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Description du projet *',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_quillController.document.toPlainText().length}/1000',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          Text(
            'Décrivez votre projet agricole en détail',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 2.h),

          // Rich text editor toolbar
          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
            ),
            child: QuillSimpleToolbar(
              controller: _quillController,
              config: QuillSimpleToolbarConfig(
                showBoldButton: true,
                showItalicButton: true,
                showUnderLineButton: true,
                showListNumbers: true,
                showListBullets: true,
                showCodeBlock: false,
                showInlineCode: false,
                showColorButton: false,
                showBackgroundColorButton: false,
                showClearFormat: true,
                showAlignmentButtons: false,
                showDirection: false,
                showHeaderStyle: false,
                showFontFamily: false,
                showFontSize: false,
                showStrikeThrough: false,
                showQuote: false,
                showIndent: false,
                showLink: false,
                showUndo: true,
                showRedo: true,
                showSearchButton: false,
                showSubscript: false,
                showSuperscript: false,
                multiRowsDisplay: false,
              ),
            ),
          ),

          // Rich text editor
          Container(
            height: 20.h,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: QuillEditor.basic(
              controller: _quillController,
              focusNode: _focusNode,
              config: QuillEditorConfig(
                padding: EdgeInsets.all(3.w),
                placeholder:
                    'Décrivez votre projet agricole : objectifs, méthodes, bénéfices attendus, expérience, etc.',
                // readOnly: false,
                autoFocus: false,
                expands: false,
                scrollable: true,
                maxHeight: null,
                customStyles: DefaultStyles(
                  paragraph: DefaultTextBlockStyle(
                    AppTheme.lightTheme.textTheme.bodyMedium!,
                    HorizontalSpacing.zero,
                    VerticalSpacing(6, 0),
                    VerticalSpacing.zero,
                    null,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Helpful tips
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'lightbulb',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Conseils pour une bonne description',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  '• Expliquez clairement vos objectifs agricoles\n'
                  '• Mentionnez votre expérience et vos compétences\n'
                  '• Décrivez les bénéfices environnementaux\n'
                  '• Précisez l\'utilisation des fonds demandés',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.tertiary
                        .withValues(alpha: 0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}