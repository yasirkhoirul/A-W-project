import 'package:a_and_w/features/history/domain/entities/history_entity.dart';
import 'package:a_and_w/features/history/domain/repositories/history_repository.dart';

class GetHistory {
  final HistoryRepository repository;

  GetHistory(this.repository);

  Stream<List<HistoryEntity>> call() {
    return repository.watchHistory();
  }
}

class GetHistoryDetail {
  final HistoryRepository repository;

  GetHistoryDetail(this.repository);

  Stream<HistoryEntity> call(String orderId) {
    return repository.watchHistoryDetail(orderId);
  }
}
