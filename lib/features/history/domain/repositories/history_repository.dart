import 'package:a_and_w/features/history/domain/entities/history_entity.dart';

abstract class HistoryRepository {
  Stream<List<HistoryEntity>> watchHistory();
  Stream<HistoryEntity> watchHistoryDetail(String orderId);
}
