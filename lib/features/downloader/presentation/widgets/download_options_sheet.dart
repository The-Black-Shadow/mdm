import 'package:flutter/material.dart';

import 'package:mdm/core/helpers/file_helper.dart';
import 'package:mdm/core/theme/app_spacing.dart';
import 'package:mdm/core/utils/app_logger.dart';
import 'package:mdm/features/downloader/domain/entities/stream_info.dart';
import 'package:mdm/shared/components/bottom_sheet_handle.dart';

// >>> DownloadOptionsSheet =======================
// Bottom sheet with editable filename, download folder selector,
// extract audio toggle (for video streams), and start download button
class DownloadOptionsSheet extends StatefulWidget {
  final String videoTitle;
  final StreamInfo selectedStream;
  final void Function({
    required String fileName,
    required bool extractAudio,
  }) onStartDownload;

  const DownloadOptionsSheet({
    super.key,
    required this.videoTitle,
    required this.selectedStream,
    required this.onStartDownload,
  });

  static Future<void> show({
    required BuildContext context,
    required String videoTitle,
    required StreamInfo selectedStream,
    required void Function({
      required String fileName,
      required bool extractAudio,
    }) onStartDownload,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => DownloadOptionsSheet(
        videoTitle: videoTitle,
        selectedStream: selectedStream,
        onStartDownload: onStartDownload,
      ),
    );
  }

  @override
  State<DownloadOptionsSheet> createState() => _DownloadOptionsSheetState();
}

class _DownloadOptionsSheetState extends State<DownloadOptionsSheet> {
  late final TextEditingController _fileNameController;
  bool _extractAudio = false;
  String _downloadFolder = '';

  @override
  void initState() {
    super.initState();
    final sanitized = FileHelper.sanitizeFileName(widget.videoTitle);
    _fileNameController = TextEditingController(text: sanitized);
    _loadDownloadFolder();
  }

  Future<void> _loadDownloadFolder() async {
    try {
      final dir = await FileHelper.getDownloadDirectory();
      if (mounted) {
        setState(() => _downloadFolder = dir.path);
      }
    } catch (e) {
      AppLogger.e('Failed to load download directory', e);
    }
  }

  @override
  void dispose() {
    _fileNameController.dispose();
    super.dispose();
  }

  bool get _isVideoStream {
    return widget.selectedStream.resolution != null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.base),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const BottomSheetHandle(),
              const SizedBox(height: AppSpacing.base),
              _buildTitle(context),
              const SizedBox(height: AppSpacing.xl),
              _buildFileNameField(context),
              const SizedBox(height: AppSpacing.base),
              _buildDownloadFolderRow(context),
              if (_isVideoStream) ...[
                const SizedBox(height: AppSpacing.base),
                _buildExtractAudioToggle(context),
              ],
              const SizedBox(height: AppSpacing.xl),
              _buildStartButton(context),
              const SizedBox(height: AppSpacing.base),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      'Download Options',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
    );
  }

  Widget _buildFileNameField(BuildContext context) {
    return TextField(
      controller: _fileNameController,
      decoration: const InputDecoration(
        labelText: 'File name',
        prefixIcon: Icon(Icons.edit_outlined),
      ),
    );
  }

  Widget _buildDownloadFolderRow(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        // TODO: Implement folder picker in Phase 7
        AppLogger.d('Folder picker tapped');
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.base),
        decoration: BoxDecoration(
          color: theme.inputDecorationTheme.fillColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.folder_outlined,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Download folder',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _downloadFolder.isEmpty ? 'Loading...' : _downloadFolder,
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExtractAudioToggle(BuildContext context) {
    return SwitchListTile(
      value: _extractAudio,
      onChanged: (value) => setState(() => _extractAudio = value),
      title: const Text('Extract audio only (MP3)'),
      subtitle: const Text('Save as audio file instead of video'),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton.icon(
        onPressed: _handleStartDownload,
        icon: const Icon(Icons.download_rounded),
        label: const Text('Start Download'),
      ),
    );
  }

  void _handleStartDownload() {
    final fileName = _fileNameController.text.trim();
    if (fileName.isEmpty) return;

    widget.onStartDownload(
      fileName: fileName,
      extractAudio: _extractAudio,
    );

    Navigator.of(context).pop();
  }
}
// <<< DownloadOptionsSheet =======================
