import 'package:equatable/equatable.dart';
import 'package:a_and_w/features/history/domain/entities/history_entity.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<HistoryEntity> history;

  const HistoryLoaded(this.history);

  @override
  List<Object?> get props => [history];
}

class HistoryError extends HistoryState {
  final String message;

  const HistoryError(this.message);

  @override
  List<Object?> get props => [message];
}

// Detail states
abstract class HistoryDetailState extends Equatable {
  const HistoryDetailState();

  @override
  List<Object?> get props => [];
}

class HistoryDetailInitial extends HistoryDetailState {}

class HistoryDetailLoading extends HistoryDetailState {}

class HistoryDetailLoaded extends HistoryDetailState {
  final HistoryEntity history;

  const HistoryDetailLoaded(this.history);

  @override
  List<Object?> get props => [history];
}

class HistoryDetailError extends HistoryDetailState {
  final String message;

  const HistoryDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
