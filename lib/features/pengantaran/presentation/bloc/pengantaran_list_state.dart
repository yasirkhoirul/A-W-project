part of 'pengantaran_list_bloc.dart';

sealed class PengantaranListState extends Equatable {
  const PengantaranListState();

  @override
  List<Object> get props => [];
}

final class PengantaranListInitial extends PengantaranListState {}

final class PengantaranListLoading extends PengantaranListState {}

final class PengantaranListLoaded extends PengantaranListState {
  final List<DataWilayahEntity> data;
  const PengantaranListLoaded({required this.data});
  @override
  List<Object> get props => [data];
}

final class PengantaranListError extends PengantaranListState {
  final String message;
  const PengantaranListError({required this.message});
  @override
  List<Object> get props => [message];
}
