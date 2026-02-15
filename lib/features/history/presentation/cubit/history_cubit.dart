import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:a_and_w/features/history/domain/usecases/get_history.dart';
import 'package:a_and_w/features/history/presentation/cubit/history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final GetHistory getHistory;
  StreamSubscription? _subscription;

  HistoryCubit({required this.getHistory}) : super(HistoryInitial());

  void watchHistory() {
    emit(HistoryLoading());
    _subscription?.cancel();
    _subscription = getHistory().listen(
      (data) => emit(HistoryLoaded(data)),
      onError: (error) => emit(HistoryError(error.toString())),
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

class HistoryDetailCubit extends Cubit<HistoryDetailState> {
  final GetHistoryDetail getHistoryDetail;
  StreamSubscription? _subscription;

  HistoryDetailCubit({required this.getHistoryDetail})
    : super(HistoryDetailInitial());

  void watchDetail(String orderId) {
    emit(HistoryDetailLoading());
    _subscription?.cancel();
    _subscription = getHistoryDetail(orderId).listen(
      (data) => emit(HistoryDetailLoaded(data)),
      onError: (error) => emit(HistoryDetailError(error.toString())),
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
