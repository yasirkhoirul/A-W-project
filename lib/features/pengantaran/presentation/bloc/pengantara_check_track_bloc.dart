import 'package:a_and_w/features/pengantaran/domain/entities/data_cek_entity.dart';
import 'package:a_and_w/features/pengantaran/domain/entities/data_track_entity.dart';
import 'package:a_and_w/features/pengantaran/domain/usecase/cost_pengantaran.dart';
import 'package:a_and_w/features/pengantaran/domain/usecase/track_pengantaran.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'pengantara_check_track_event.dart';
part 'pengantara_check_track_state.dart';

class PengantaraCheckTrackBloc
    extends Bloc<PengantaraCheckTrackEvent, PengantaraCheckTrackState> {
  final CostPengantaran costPengantaran;
  final TrackPengantaran trackPengantaran;
  PengantaraCheckTrackBloc(this.costPengantaran, this.trackPengantaran)
    : super(PengantaraCheckTrackInitial()) {
    on<OnPengantaranCheckCost>(_onPengantaranCheckCost);
    on<OnPengantaranCheckTrack>(_onPengantaranCheckTrack);
  }

  Future<void> _onPengantaranCheckCost(
    OnPengantaranCheckCost event,
    Emitter<PengantaraCheckTrackState> emit,
  ) async {
    emit(PengantaraCheckTrackLoading());
    final result = await costPengantaran(event.dataTrackRequestEntity);
    result.fold(
      (failure) => emit(PengantaraCheckTrackError(message: failure.message)),
      (data) => emit(PengantaraCheckTrackCostLoaded(dataCekEntity: data)),
    );
  }

  Future<void> _onPengantaranCheckTrack(
    OnPengantaranCheckTrack event,
    Emitter<PengantaraCheckTrackState> emit,
  ) async {
    emit(PengantaraCheckTrackLoading());
    final result = await trackPengantaran(event.dataTrackRequestEntity);
    result.fold(
      (failure) => emit(PengantaraCheckTrackError(message: failure.message)),
      (data) => emit(PengantaraCheckTrackLoaded(dataCekEntity: data)),
    );
  }
}
