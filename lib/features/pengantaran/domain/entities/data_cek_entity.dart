import 'package:equatable/equatable.dart';

class DataCekEntity extends Equatable {
  final String? name;
  final String? code;
  final String? service;
  final String? description;
  final int? cost;
  final String? etd;

  const DataCekEntity({
    this.name,
    this.code,
    this.service,
    this.description,
    this.cost,
    this.etd,
  });

  @override
  List<Object?> get props => [name, code, service, description, cost, etd];
}

class DataCekRequestEntity {
  final int origin;
  final int destination;
  final int weight;
  final String courier;

  DataCekRequestEntity({
    required this.origin,
    required this.destination,
    required this.weight,
    required this.courier,
  });
}
