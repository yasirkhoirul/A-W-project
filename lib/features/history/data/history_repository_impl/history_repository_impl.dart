import 'package:a_and_w/features/history/data/datasources/history_remote_datasource.dart';
import 'package:a_and_w/features/history/domain/entities/history_entity.dart';
import 'package:a_and_w/features/history/domain/repositories/history_repository.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryRemoteDatasource historyRemoteDatasource;
  const HistoryRepositoryImpl(this.historyRemoteDatasource);

  @override
  Stream<List<HistoryEntity>> watchHistory() {
    return historyRemoteDatasource.watchHistory().map(
      (models) => models.map((e) => e.toEntity()).toList(),
    );
  }

  @override
  Stream<HistoryEntity> watchHistoryDetail(String orderId) {
    return historyRemoteDatasource
        .watchHistoryDetail(orderId)
        .map((model) => model.toEntity());
  }
}
