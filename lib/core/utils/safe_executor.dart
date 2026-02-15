import 'package:a_and_w/core/exceptions/exceptions.dart';
import 'package:dartz/dartz.dart';

Future<Either<Failure, T>> safeExecute<T>(Future<T> Function() action) async {
  try {
    return Right(await action());
  } catch (e) {
    return Left(ExceptionHandler.handle(e));
  }
}
