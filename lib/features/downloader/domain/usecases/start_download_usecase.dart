// >>> StartDownloadUseCase =======================
import 'package:injectable/injectable.dart';
import 'package:mdm/core/utils/result.dart';
import 'package:mdm/features/downloader/domain/entities/download_task.dart';
import 'package:mdm/features/downloader/domain/repositories/download_repository.dart';

@injectable
class StartDownloadUseCase {
  final DownloadRepository _repository;

  StartDownloadUseCase(this._repository);

  Future<Result<void>> call(DownloadTask task) {
    return _repository.startDownload(task);
  }
}
// <<< StartDownloadUseCase =======================
