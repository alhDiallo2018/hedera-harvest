import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DocumentsSectionWidget extends StatelessWidget {
  final List<Map<String, dynamic>> documents;

  const DocumentsSectionWidget({
    super.key,
    required this.documents,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Documents',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              TextButton.icon(
                onPressed: () => _showAllDocuments(context),
                icon: CustomIconWidget(
                  iconName: 'folder_open',
                  color: colorScheme.primary,
                  size: 18,
                ),
                label: Text(
                  'Voir Tout',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: documents.length > 3 ? 3 : documents.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final document = documents[index];
              return _DocumentItem(
                document: document,
                onTap: () => _openDocument(context, document),
                theme: theme,
              );
            },
          ),
          if (documents.length > 3) ...[
            SizedBox(height: 2.h),
            Center(
              child: TextButton(
                onPressed: () => _showAllDocuments(context),
                child: Text(
                  '+${documents.length - 3} autres documents',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _openDocument(BuildContext context, Map<String, dynamic> document) {
    // Handle document opening with native PDF viewing
    final documentType = document['type'] as String? ?? '';
    final documentName = document['name'] as String? ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ouvrir Document'),
        content: Text('Ouverture de $documentName...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showAllDocuments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                margin: EdgeInsets.only(top: 2.h),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tous les Documents',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: CustomIconWidget(
                        iconName: 'close',
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7),
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: documents.length,
                  separatorBuilder: (context, index) => SizedBox(height: 1.h),
                  itemBuilder: (context, index) {
                    final document = documents[index];
                    return _DocumentItem(
                      document: document,
                      onTap: () => _openDocument(context, document),
                      theme: Theme.of(context),
                      showFullDetails: true,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DocumentItem extends StatelessWidget {
  final Map<String, dynamic> document;
  final VoidCallback onTap;
  final ThemeData theme;
  final bool showFullDetails;

  const _DocumentItem({
    required this.document,
    required this.onTap,
    required this.theme,
    this.showFullDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = theme.colorScheme;
    final documentType = document['type'] as String? ?? '';
    final documentIcon = _getDocumentIcon(documentType);
    final documentColor = _getDocumentColor(documentType);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: documentColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: documentColor.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: documentColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: documentIcon,
                  color: documentColor,
                  size: 24,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document['name'] as String? ?? '',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      Text(
                        _getDocumentTypeLabel(documentType),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: documentColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (showFullDetails && document['size'] != null) ...[
                        Text(
                          ' • ${document['size']}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (showFullDetails && document['date'] != null) ...[
                    SizedBox(height: 0.5.h),
                    Text(
                      document['date'] as String? ?? '',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'download',
              color: colorScheme.onSurface.withValues(alpha: 0.5),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  String _getDocumentIcon(String type) {
    switch (type.toLowerCase()) {
      case 'certificate':
        return 'verified';
      case 'tax':
        return 'receipt_long';
      case 'report':
        return 'assessment';
      case 'contract':
        return 'description';
      default:
        return 'insert_drive_file';
    }
  }

  Color _getDocumentColor(String type) {
    switch (type.toLowerCase()) {
      case 'certificate':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'tax':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'report':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'contract':
        return AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.7);
      default:
        return AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.5);
    }
  }

  String _getDocumentTypeLabel(String type) {
    switch (type.toLowerCase()) {
      case 'certificate':
        return 'Certificat';
      case 'tax':
        return 'Document Fiscal';
      case 'report':
        return 'Rapport';
      case 'contract':
        return 'Contrat';
      default:
        return 'Document';
    }
  }
}
