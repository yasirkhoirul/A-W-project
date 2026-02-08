import 'package:equatable/equatable.dart';

class DataWilayahEntity extends Equatable {
  final int? id;
  final String? name;

  const DataWilayahEntity({this.id, this.name});

  @override
  List<Object?> get props => [id, name];
}
