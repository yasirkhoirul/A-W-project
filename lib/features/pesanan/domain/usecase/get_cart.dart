import 'package:a_and_w/core/entities/cart_input.dart';
import 'package:a_and_w/core/exceptions/exceptions.dart';
import 'package:a_and_w/features/pesanan/domain/entities/cart_entity.dart';
import 'package:a_and_w/features/pesanan/domain/repository/pesanan_repository.dart';
import 'package:dartz/dartz.dart';

class GetCart {
  final PesananRepository repository;

  const GetCart({required this.repository});
  
  Future<Either<Failure, CartEntity>> call(List<CartInput> items) async {
    if (items.isEmpty) {
      return Left(UnknownFailure('Items list is empty'));
    }
    return repository.createCart(items);
  }
}