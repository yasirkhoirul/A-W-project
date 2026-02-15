import 'package:a_and_w/core/entities/profile.dart';
import 'package:a_and_w/core/exceptions/failure.dart';
import 'package:a_and_w/features/pesanan/domain/entities/cart_entity.dart';
import 'package:a_and_w/features/pesanan/domain/entities/pesanan.dart';
import 'package:a_and_w/features/pesanan/domain/usecase/submit_pesanan.dart';
import 'package:a_and_w/features/pengantaran/domain/entities/data_cek_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../test_helper.mocks.dart';

void main() {
  late MockPesananRepository mockPesananRepository;
  late SubmitPesanan usecase;

  setUp(() {
    mockPesananRepository = MockPesananRepository();
    usecase = SubmitPesanan(mockPesananRepository);
  });

  // Valid test data
  const tAddress = Address(
    provinsi: DataAddress(id: 1, nama: 'DKI Jakarta'),
    kota: DataAddress(id: 10, nama: 'Jakarta Selatan'),
    district: DataAddress(id: 100, nama: 'Kebayoran Baru'),
  );

  const tUser = CartUserEntity(
    uid: 'test-uid',
    displayName: 'Test User',
    email: 'test@example.com',
    phoneNumber: '08123456789',
    address: tAddress,
  );

  const tCartItem = CartItemEntity(
    id: 'product-1',
    name: 'Test Product',
    price: 50000,
    weight: 500,
    category: 'food',
    images: ['image1.jpg'],
    quantity: 2,
    subtotalPrice: 100000,
    subtotalWeight: 1000,
  );

  const tCart = CartEntity(
    user: tUser,
    products: [tCartItem],
    totalPrice: 100000,
    totalWeight: 1000,
    totalItems: 2,
    productCount: 1,
  );

  const tShipping = DataCekEntity(
    name: 'JNE',
    code: 'jne',
    service: 'REG',
    description: 'Layanan Reguler',
    cost: 15000,
    etd: '2-3',
  );

  group('SubmitPesanan', () {
    test(
      'should return Right(SubmitPesananEntity) when all validations pass',
      () async {
        // Arrange
        const tSubmitResult = SubmitPesananEntity(
          token: 'test-token',
          redirectUrl: 'https://test.midtrans.com',
          orderId: 'ORDER-123',
        );
        when(
          mockPesananRepository.submitPesanan(any, any),
        ).thenAnswer((_) async => const Right(tSubmitResult));

        // Act
        final result = await usecase(tCart, tShipping);

        // Assert
        expect(result, const Right(tSubmitResult));
        verify(mockPesananRepository.submitPesanan(tCart, tShipping));
        verifyNoMoreInteractions(mockPesananRepository);
      },
    );

    group('User Info Validation', () {
      test('should return UnknownFailure when displayName is null', () async {
        // Arrange
        const invalidCart = CartEntity(
          user: CartUserEntity(
            uid: 'test-uid',
            displayName: null,
            email: 'test@example.com',
            phoneNumber: '08123456789',
            address: tAddress,
          ),
          products: [tCartItem],
          totalPrice: 100000,
          totalWeight: 1000,
          totalItems: 2,
          productCount: 1,
        );

        // Act
        final result = await usecase(invalidCart, tShipping);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<UnknownFailure>());
            expect(failure.message, contains('Nama'));
          },
          (_) => fail('Should return failure'),
        );
      });

      test('should return UnknownFailure when displayName is empty', () async {
        // Arrange
        const invalidCart = CartEntity(
          user: CartUserEntity(
            uid: 'test-uid',
            displayName: '',
            email: 'test@example.com',
            phoneNumber: '08123456789',
            address: tAddress,
          ),
          products: [tCartItem],
          totalPrice: 100000,
          totalWeight: 1000,
          totalItems: 2,
          productCount: 1,
        );

        // Act
        final result = await usecase(invalidCart, tShipping);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<UnknownFailure>());
            expect(failure.message, contains('Nama'));
          },
          (_) => fail('Should return failure'),
        );
      });

      test('should return UnknownFailure when email is null', () async {
        // Arrange
        const invalidCart = CartEntity(
          user: CartUserEntity(
            uid: 'test-uid',
            displayName: 'Test User',
            email: null,
            phoneNumber: '08123456789',
            address: tAddress,
          ),
          products: [tCartItem],
          totalPrice: 100000,
          totalWeight: 1000,
          totalItems: 2,
          productCount: 1,
        );

        // Act
        final result = await usecase(invalidCart, tShipping);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<UnknownFailure>());
            expect(failure.message, contains('Email'));
          },
          (_) => fail('Should return failure'),
        );
      });

      test('should return UnknownFailure when email format is invalid',
          () async {
        // Arrange
        const invalidCart = CartEntity(
          user: CartUserEntity(
            uid: 'test-uid',
            displayName: 'Test User',
            email: 'invalid-email',
            phoneNumber: '08123456789',
            address: tAddress,
          ),
          products: [tCartItem],
          totalPrice: 100000,
          totalWeight: 1000,
          totalItems: 2,
          productCount: 1,
        );

        // Act
        final result = await usecase(invalidCart, tShipping);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<UnknownFailure>());
            expect(failure.message, 'Format email tidak valid');
          },
          (_) => fail('Should return failure'),
        );
      });

      test('should return UnknownFailure when phoneNumber is null', () async {
        // Arrange
        const invalidCart = CartEntity(
          user: CartUserEntity(
            uid: 'test-uid',
            displayName: 'Test User',
            email: 'test@example.com',
            phoneNumber: null,
            address: tAddress,
          ),
          products: [tCartItem],
          totalPrice: 100000,
          totalWeight: 1000,
          totalItems: 2,
          productCount: 1,
        );

        // Act
        final result = await usecase(invalidCart, tShipping);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<UnknownFailure>());
            expect(failure.message, contains('Nomor HP'));
          },
          (_) => fail('Should return failure'),
        );
      });

      test('should return UnknownFailure when phoneNumber is too short',
          () async {
        // Arrange
        const invalidCart = CartEntity(
          user: CartUserEntity(
            uid: 'test-uid',
            displayName: 'Test User',
            email: 'test@example.com',
            phoneNumber: '081234',
            address: tAddress,
          ),
          products: [tCartItem],
          totalPrice: 100000,
          totalWeight: 1000,
          totalItems: 2,
          productCount: 1,
        );

        // Act
        final result = await usecase(invalidCart, tShipping);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<UnknownFailure>());
            expect(failure.message, contains('Nomor HP'));
          },
          (_) => fail('Should return failure'),
        );
      });
    });

    group('Address Validation', () {
      test('should return UnknownFailure when address is null', () async {
        // Arrange
        const invalidCart = CartEntity(
          user: CartUserEntity(
            uid: 'test-uid',
            displayName: 'Test User',
            email: 'test@example.com',
            phoneNumber: '08123456789',
            address: null,
          ),
          products: [tCartItem],
          totalPrice: 100000,
          totalWeight: 1000,
          totalItems: 2,
          productCount: 1,
        );

        // Act
        final result = await usecase(invalidCart, tShipping);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<UnknownFailure>());
            expect(failure.message, 'Alamat pengiriman harus diisi');
          },
          (_) => fail('Should return failure'),
        );
      });

      test('should return UnknownFailure when provinsi id is 0', () async {
        // Arrange
        const invalidAddress = Address(
          provinsi: DataAddress(id: 0, nama: ''),
          kota: DataAddress(id: 10, nama: 'Jakarta Selatan'),
          district: DataAddress(id: 100, nama: 'Kebayoran Baru'),
        );

        const invalidCart = CartEntity(
          user: CartUserEntity(
            uid: 'test-uid',
            displayName: 'Test User',
            email: 'test@example.com',
            phoneNumber: '08123456789',
            address: invalidAddress,
          ),
          products: [tCartItem],
          totalPrice: 100000,
          totalWeight: 1000,
          totalItems: 2,
          productCount: 1,
        );

        // Act
        final result = await usecase(invalidCart, tShipping);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<UnknownFailure>());
            expect(failure.message, 'Provinsi harus dipilih');
          },
          (_) => fail('Should return failure'),
        );
      });

      test('should return UnknownFailure when kota id is 0', () async {
        // Arrange
        const invalidAddress = Address(
          provinsi: DataAddress(id: 1, nama: 'DKI Jakarta'),
          kota: DataAddress(id: 0, nama: ''),
          district: DataAddress(id: 100, nama: 'Kebayoran Baru'),
        );

        const invalidCart = CartEntity(
          user: CartUserEntity(
            uid: 'test-uid',
            displayName: 'Test User',
            email: 'test@example.com',
            phoneNumber: '08123456789',
            address: invalidAddress,
          ),
          products: [tCartItem],
          totalPrice: 100000,
          totalWeight: 1000,
          totalItems: 2,
          productCount: 1,
        );

        // Act
        final result = await usecase(invalidCart, tShipping);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<UnknownFailure>());
            expect(failure.message, 'Kota tujuan harus dipilih');
          },
          (_) => fail('Should return failure'),
        );
      });

      test('should return UnknownFailure when district id is 0', () async {
        // Arrange
        const invalidAddress = Address(
          provinsi: DataAddress(id: 1, nama: 'DKI Jakarta'),
          kota: DataAddress(id: 10, nama: 'Jakarta Selatan'),
          district: DataAddress(id: 0, nama: ''),
        );

        const invalidCart = CartEntity(
          user: CartUserEntity(
            uid: 'test-uid',
            displayName: 'Test User',
            email: 'test@example.com',
            phoneNumber: '08123456789',
            address: invalidAddress,
          ),
          products: [tCartItem],
          totalPrice: 100000,
          totalWeight: 1000,
          totalItems: 2,
          productCount: 1,
        );

        // Act
        final result = await usecase(invalidCart, tShipping);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<UnknownFailure>());
            expect(failure.message, 'Kecamatan harus dipilih');
          },
          (_) => fail('Should return failure'),
        );
      });
    });

    group('Cart Validation', () {
      test('should return UnknownFailure when products list is empty',
          () async {
        // Arrange
        const invalidCart = CartEntity(
          user: tUser,
          products: [],
          totalPrice: 0,
          totalWeight: 0,
          totalItems: 0,
          productCount: 0,
        );

        // Act
        final result = await usecase(invalidCart, tShipping);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<UnknownFailure>());
            expect(failure.message, 'Keranjang belanja masih kosong');
          },
          (_) => fail('Should return failure'),
        );
      });

      test('should return UnknownFailure when product quantity is 0',
          () async {
        // Arrange
        const invalidItem = CartItemEntity(
          id: 'product-1',
          name: 'Test Product',
          price: 50000,
          weight: 500,
          category: 'food',
          images: ['image1.jpg'],
          quantity: 0,
          subtotalPrice: 0,
          subtotalWeight: 0,
        );

        const invalidCart = CartEntity(
          user: tUser,
          products: [invalidItem],
          totalPrice: 0,
          totalWeight: 0,
          totalItems: 0,
          productCount: 1,
        );

        // Act
        final result = await usecase(invalidCart, tShipping);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<UnknownFailure>());
            expect(failure.message, contains('Jumlah produk'));
            expect(failure.message, contains('tidak valid'));
          },
          (_) => fail('Should return failure'),
        );
      });

      test('should return UnknownFailure when totalPrice is 0', () async {
        // Arrange
        const invalidCart = CartEntity(
          user: tUser,
          products: [tCartItem],
          totalPrice: 0,
          totalWeight: 1000,
          totalItems: 2,
          productCount: 1,
        );

        // Act
        final result = await usecase(invalidCart, tShipping);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<UnknownFailure>());
            expect(failure.message, 'Total harga tidak valid');
          },
          (_) => fail('Should return failure'),
        );
      });

      test('should return UnknownFailure when totalWeight is 0', () async {
        // Arrange
        const invalidCart = CartEntity(
          user: tUser,
          products: [tCartItem],
          totalPrice: 100000,
          totalWeight: 0,
          totalItems: 2,
          productCount: 1,
        );

        // Act
        final result = await usecase(invalidCart, tShipping);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<UnknownFailure>());
            expect(failure.message, 'Total berat tidak valid');
          },
          (_) => fail('Should return failure'),
        );
      });
    });

    group('Shipping Validation', () {
      test('should return UnknownFailure when shipping cost is null',
          () async {
        // Arrange
        const invalidShipping = DataCekEntity(
          name: 'JNE',
          code: 'jne',
          service: 'REG',
          description: 'Layanan Reguler',
          cost: null,
          etd: '2-3',
        );

        // Act
        final result = await usecase(tCart, invalidShipping);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<UnknownFailure>());
            expect(failure.message, 'Biaya pengiriman tidak valid');
          },
          (_) => fail('Should return failure'),
        );
      });

      test('should return UnknownFailure when shipping cost is 0', () async {
        // Arrange
        const invalidShipping = DataCekEntity(
          name: 'JNE',
          code: 'jne',
          service: 'REG',
          description: 'Layanan Reguler',
          cost: 0,
          etd: '2-3',
        );

        // Act
        final result = await usecase(tCart, invalidShipping);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<UnknownFailure>());
            expect(failure.message, 'Biaya pengiriman tidak valid');
          },
          (_) => fail('Should return failure'),
        );
      });

      test('should return UnknownFailure when shipping cost is negative',
          () async {
        // Arrange
        const invalidShipping = DataCekEntity(
          name: 'JNE',
          code: 'jne',
          service: 'REG',
          description: 'Layanan Reguler',
          cost: -1000,
          etd: '2-3',
        );

        // Act
        final result = await usecase(tCart, invalidShipping);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<UnknownFailure>());
            expect(failure.message, 'Biaya pengiriman tidak valid');
          },
          (_) => fail('Should return failure'),
        );
      });
    });

    group('Edge Cases', () {
      test('should validate multiple products correctly', () async {
        // Arrange
        const tCartItem2 = CartItemEntity(
          id: 'product-2',
          name: 'Test Product 2',
          price: 30000,
          weight: 300,
          category: 'drink',
          images: ['image2.jpg'],
          quantity: 3,
          subtotalPrice: 90000,
          subtotalWeight: 900,
        );

        const multiItemCart = CartEntity(
          user: tUser,
          products: [tCartItem, tCartItem2],
          totalPrice: 190000,
          totalWeight: 1900,
          totalItems: 5,
          productCount: 2,
        );

        const tSubmitResult = SubmitPesananEntity(
          token: 'test-token',
          redirectUrl: 'https://test.midtrans.com',
          orderId: 'ORDER-123',
        );
        when(
          mockPesananRepository.submitPesanan(any, any),
        ).thenAnswer((_) async => const Right(tSubmitResult));

        // Act
        final result = await usecase(multiItemCart, tShipping);

        // Assert
        expect(result, const Right(tSubmitResult));
        verify(mockPesananRepository.submitPesanan(multiItemCart, tShipping));
      });

      test(
          'should fail when one product in multiple products has invalid quantity',
          () async {
        // Arrange
        const invalidItem = CartItemEntity(
          id: 'product-2',
          name: 'Invalid Product',
          price: 30000,
          weight: 300,
          category: 'drink',
          images: ['image2.jpg'],
          quantity: -1,
          subtotalPrice: -30000,
          subtotalWeight: -300,
        );

        const multiItemCart = CartEntity(
          user: tUser,
          products: [tCartItem, invalidItem],
          totalPrice: 70000,
          totalWeight: 700,
          totalItems: 1,
          productCount: 2,
        );

        // Act
        final result = await usecase(multiItemCart, tShipping);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<UnknownFailure>());
            expect(failure.message, contains('Invalid Product'));
          },
          (_) => fail('Should return failure'),
        );
      });
    });
  });
}
