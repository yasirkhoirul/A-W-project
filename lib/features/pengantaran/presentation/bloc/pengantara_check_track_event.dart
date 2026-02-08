part of 'pengantara_check_track_bloc.dart';

sealed class PengantaraCheckTrackEvent extends Equatable {
  const PengantaraCheckTrackEvent();

  @override
  List<Object> get props => [];
}

class OnPengantaranCheckCost extends PengantaraCheckTrackEvent {
  final DataCekRequestEntity dataTrackRequestEntity;
  const OnPengantaranCheckCost({required this.dataTrackRequestEntity});
  @override
  List<Object> get props => [dataTrackRequestEntity];
}

class OnPengantaranCheckTrack extends PengantaraCheckTrackEvent {
  final DataTrackRequestEntity dataTrackRequestEntity;
  const OnPengantaranCheckTrack({required this.dataTrackRequestEntity});
  @override
  List<Object> get props => [dataTrackRequestEntity];
}
