part of 'pengantaran_list_bloc.dart';

sealed class PengantaranListEvent extends Equatable {
  const PengantaranListEvent();

  @override
  List<Object> get props => [];
}

class OnPengantaranProvinsiList extends PengantaranListEvent {
  @override
  List<Object> get props => [];
}

class OnPengantaranKotaList extends PengantaranListEvent {
  final String provinsiId;
  const OnPengantaranKotaList({required this.provinsiId});
  @override
  List<Object> get props => [provinsiId];
}

class OnPengantaranDistrikList extends PengantaranListEvent {
  final String kotaId;
  const OnPengantaranDistrikList({required this.kotaId});
  @override
  List<Object> get props => [kotaId];
}
