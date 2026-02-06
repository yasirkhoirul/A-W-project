import 'package:equatable/equatable.dart';

class UserEntities extends Equatable{
  final String email;
  final String password;
  final String nama;
  const UserEntities(this.email,this.password,this.nama);

  @override
  List<Object?> get props => [email,password,nama];
}