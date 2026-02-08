part of 'pengantara_check_track_bloc.dart';

sealed class PengantaraCheckTrackState extends Equatable {
  const PengantaraCheckTrackState();

  @override
  List<Object> get props => [];
}

final class PengantaraCheckTrackInitial extends PengantaraCheckTrackState {}

final class PengantaraCheckTrackLoading extends PengantaraCheckTrackState {}

final class PengantaraCheckTrackLoaded extends PengantaraCheckTrackState {
  final List<DataTrackEntity> dataCekEntity;
  const PengantaraCheckTrackLoaded({required this.dataCekEntity});
  @override
  List<Object> get props => [dataCekEntity];
}

final class PengantaraCheckTrackCostLoaded extends PengantaraCheckTrackState {
  final List<DataCekEntity> dataCekEntity;
  const PengantaraCheckTrackCostLoaded({required this.dataCekEntity});
  @override
  List<Object> get props => [dataCekEntity];
}

final class PengantaraCheckTrackError extends PengantaraCheckTrackState {
  final String message;
  const PengantaraCheckTrackError({required this.message});
  @override
  List<Object> get props => [message];
}
