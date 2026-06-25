// >>> CancelDownloadUseCase =======================
import 'package:injectable/injectable.dart';
import 'package:mdm/core/utils/result.dart';
import 'package:mdm/features/downloader/domain/repositories/download_repository.dart';

@injectable
class CancelDownloadUseCase {
  final DownloadRepository _repository;

  CancelDownloadUseCase(this._repository);

  Future<Result<void>> call(String taskId) {
    return _repository.cancelDownload(taskId);
  }
}
// <<< CancelDownloadUseCase =======================
