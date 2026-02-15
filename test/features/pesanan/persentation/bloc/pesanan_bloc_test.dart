import 'package:a_and_w/core/entities/profile.dart';
import 'package:a_and_w/core/exceptions/failure.dart';
import 'package:a_and_w/features/pesanan/domain/entities/cart_entity.dart';
import 'package:a_and_w/features/pesanan/domain/entities/pesanan.dart';
import 'package:a_and_w/features/pengantaran/domain/entities/data_cek_entity.dart';
import 'package:a_and_w/features/pesanan/presentation/bloc/pesanan_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../test_helper.mocks.dart';

void main() {
  late PesananBloc pesananBloc;
  late MockCostPengantaran mockCostPengantaran;
  late MockSubmitPesanan mockSubmitPesanan;

  setUp(() {
    mockCostPengantaran = MockCostPengantaran();
    mockSubmitPesanan = MockSubmitPesanan();
    pesananBloc = PesananBloc(
      costPengantaran: mockCostPengantaran,
      submitPesanan: mockSubmitPesanan,
    );
  });

  // Test data
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

  const tShippingCosts = [
    DataCekEntity(
      name: 'JNE',
      code: 'jne',
      service: 'REG',
      description: 'Layanan Reguler',
      cost: 15000,
      etd: '2-3',
    ),
    DataCekEntity(
      name: 'JNE',
      code: 'jne',
      service: 'YES',
      description: 'Yakin Esok Sampai',
      cost: 25000,
      etd: '1-1',
    ),
  ];

  const tSelectedShipping = DataCekEntity(
    name: 'JNE',
    code: 'jne',
    service: 'REG',
    description: 'Layanan Reguler',
    cost: 15000,
    etd: '2-3',
  );

  const tPesananResult = SubmitPesananEntity(
    token: 'snap-token-123',
    redirectUrl:
        'https://app.sandbox.midtrans.com/snap/v2/vtweb/snap-token-123',
    orderId: 'AW-123456-abc',
  );

  // Example DataCekRequestEntity that would be created by the bloc
  // (not directly used in tests as bloc creates it internally from cart data)
  // final tDataCekRequest = DataCekRequestEntity(
  //   origin: 234,
  //   destination: 10,
  //   weight: 1000,
  //   courier: "jne:sicepat:ide:sap:jnt",
  // );

  group('PesananBloc', () {
    test('initial state should be PesananState with initial status', () {
      // Assert
      expect(pesananBloc.state.status, PesananStatus.initial);
      expect(pesananBloc.state.cart, null);
      expect(pesananBloc.state.shippingCosts, const []);
      expect(pesananBloc.state.selectedShipping, null);
      expect(pesananBloc.state.errorMessage, null);
    });

    group('OnUpdatePesanan', () {
      blocTest<PesananBloc, PesananState>(
        'should emit state with cart',
        build: () => pesananBloc,
        act: (bloc) => bloc.add(OnUpdatePesanan(cart: tCart)),
        expect: () => [
          const PesananState(status: PesananStatus.initial, cart: tCart),
        ],
      );
    });

    group('OnLoadKurir', () {
      blocTest<PesananBloc, PesananState>(
        'should emit [loading, loaded] when getCekHarga is successful',
        build: () {
          when(
            mockCostPengantaran(any),
          ).thenAnswer((_) async => const Right(tShippingCosts));
          return pesananBloc;
        },
        seed: () => const PesananState(cart: tCart),
        act: (bloc) => bloc.add(OnLoadKurir()),
        expect: () => [
          const PesananState(status: PesananStatus.loading, cart: tCart),
          const PesananState(
            status: PesananStatus.loaded,
            cart: tCart,
            shippingCosts: tShippingCosts,
          ),
        ],
        verify: (_) {
          verify(mockCostPengantaran(any)).called(1);
        },
      );

      blocTest<PesananBloc, PesananState>(
        'should emit [loading, error] when getCekHarga fails',
        build: () {
          when(mockCostPengantaran(any)).thenAnswer(
            (_) async =>
                const Left(UnknownFailure('Failed to get shipping costs')),
          );
          return pesananBloc;
        },
        seed: () => const PesananState(cart: tCart),
        act: (bloc) => bloc.add(OnLoadKurir()),
        expect: () => [
          const PesananState(status: PesananStatus.loading, cart: tCart),
          const PesananState(
            status: PesananStatus.error,
            cart: tCart,
            errorMessage: 'Failed to get shipping costs',
          ),
        ],
      );

      blocTest<PesananBloc, PesananState>(
        'should emit [loading, error] when exception occurs',
        build: () {
          when(mockCostPengantaran(any)).thenThrow(Exception('Network error'));
          return pesananBloc;
        },
        seed: () => const PesananState(cart: tCart),
        act: (bloc) => bloc.add(OnLoadKurir()),
        expect: () => [
          const PesananState(status: PesananStatus.loading, cart: tCart),
          const PesananState(
            status: PesananStatus.error,
            cart: tCart,
            errorMessage: 'Exception: Network error',
          ),
        ],
      );
    });

    group('OnSelectKurir', () {
      blocTest<PesananBloc, PesananState>(
        'should emit state with selected shipping and clear error',
        build: () => pesananBloc,
        seed: () => const PesananState(
          cart: tCart,
          shippingCosts: tShippingCosts,
          errorMessage: 'Previous error',
        ),
        act: (bloc) => bloc.add(OnSelectKurir(tSelectedShipping)),
        expect: () => [
          const PesananState(
            cart: tCart,
            shippingCosts: tShippingCosts,
            selectedShipping: tSelectedShipping,
            errorMessage: null,
          ),
        ],
      );
    });

    group('OnChangeAlamat', () {
      const tNewAddress = Address(
        provinsi: DataAddress(id: 2, nama: 'Jawa Barat'),
        kota: DataAddress(id: 20, nama: 'Bandung'),
        district: DataAddress(id: 200, nama: 'Coblong'),
      );

      blocTest<PesananBloc, PesananState>(
        'should update address, clear selectedShipping, clear error, and trigger OnLoadKurir',
        build: () {
          when(
            mockCostPengantaran(any),
          ).thenAnswer((_) async => const Right(tShippingCosts));
          return pesananBloc;
        },
        seed: () => const PesananState(
          cart: tCart,
          selectedShipping: tSelectedShipping,
          errorMessage: 'Previous error',
        ),
        act: (bloc) => bloc.add(OnChangeAlamat(tNewAddress)),
        expect: () => [
          const PesananState(
            cart: CartEntity(
              user: CartUserEntity(
                uid: 'test-uid',
                displayName: 'Test User',
                email: 'test@example.com',
                phoneNumber: '08123456789',
                address: tNewAddress,
              ),
              products: [tCartItem],
              totalPrice: 100000,
              totalWeight: 1000,
              totalItems: 2,
              productCount: 1,
            ),
            selectedShipping: null,
            errorMessage: null,
          ),
          const PesananState(
            status: PesananStatus.loading,
            cart: CartEntity(
              user: CartUserEntity(
                uid: 'test-uid',
                displayName: 'Test User',
                email: 'test@example.com',
                phoneNumber: '08123456789',
                address: tNewAddress,
              ),
              products: [tCartItem],
              totalPrice: 100000,
              totalWeight: 1000,
              totalItems: 2,
              productCount: 1,
            ),
            selectedShipping: null,
          ),
          const PesananState(
            status: PesananStatus.loaded,
            cart: CartEntity(
              user: CartUserEntity(
                uid: 'test-uid',
                displayName: 'Test User',
                email: 'test@example.com',
                phoneNumber: '08123456789',
                address: tNewAddress,
              ),
              products: [tCartItem],
              totalPrice: 100000,
              totalWeight: 1000,
              totalItems: 2,
              productCount: 1,
            ),
            shippingCosts: tShippingCosts,
          ),
        ],
      );
    });

    group('OnUpdateUserInfo', () {
      blocTest<PesananBloc, PesananState>(
        'should update user info and clear error',
        build: () => pesananBloc,
        seed: () =>
            const PesananState(cart: tCart, errorMessage: 'Previous error'),
        act: (bloc) => bloc.add(
          OnUpdateUserInfo(
            displayName: 'Updated Name',
            email: 'updated@example.com',
            phoneNumber: '08999999999',
          ),
        ),
        expect: () => [
          const PesananState(
            cart: CartEntity(
              user: CartUserEntity(
                uid: 'test-uid',
                displayName: 'Updated Name',
                email: 'updated@example.com',
                phoneNumber: '08999999999',
                address: tAddress,
              ),
              products: [tCartItem],
              totalPrice: 100000,
              totalWeight: 1000,
              totalItems: 2,
              productCount: 1,
            ),
            errorMessage: null,
          ),
        ],
      );

      blocTest<PesananBloc, PesananState>(
        'should update only provided fields',
        build: () => pesananBloc,
        seed: () => const PesananState(cart: tCart),
        act: (bloc) => bloc.add(OnUpdateUserInfo(displayName: 'Updated Name')),
        expect: () => [
          const PesananState(
            cart: CartEntity(
              user: CartUserEntity(
                uid: 'test-uid',
                displayName: 'Updated Name',
                email: 'test@example.com',
                phoneNumber: '08123456789',
                address: tAddress,
              ),
              products: [tCartItem],
              totalPrice: 100000,
              totalWeight: 1000,
              totalItems: 2,
              productCount: 1,
            ),
            errorMessage: null,
          ),
        ],
      );

      blocTest<PesananBloc, PesananState>(
        'should do nothing if cart is null',
        build: () => pesananBloc,
        act: (bloc) => bloc.add(OnUpdateUserInfo(displayName: 'New Name')),
        expect: () => [],
      );
    });

    group('OnUpdateQuantity', () {
      blocTest<PesananBloc, PesananState>(
        'should update quantity, recalculate totals, clear selectedShipping, clear error',
        build: () => PesananBloc(
          costPengantaran: mockCostPengantaran,
          submitPesanan: mockSubmitPesanan,
        ),
        seed: () => const PesananState(
          cart: tCart,
          selectedShipping: tSelectedShipping,
          errorMessage: 'Previous error',
        ),
        act: (bloc) =>
            bloc.add(OnUpdateQuantity(productId: 'product-1', newQuantity: 5)),
        expect: () => [
          const PesananState(
            cart: CartEntity(
              user: tUser,
              products: [
                CartItemEntity(
                  id: 'product-1',
                  name: 'Test Product',
                  price: 50000,
                  weight: 500,
                  category: 'food',
                  images: ['image1.jpg'],
                  quantity: 5,
                  subtotalPrice: 250000,
                  subtotalWeight: 2500,
                ),
              ],
              totalPrice: 250000,
              totalWeight: 2500,
              totalItems: 5,
              productCount: 1,
            ),
            selectedShipping: null,
            errorMessage: null,
          ),
        ],
      );

      blocTest<PesananBloc, PesananState>(
        'should not emit if cart is null',
        build: () => PesananBloc(
          costPengantaran: mockCostPengantaran,
          submitPesanan: mockSubmitPesanan,
        ),
        act: (bloc) =>
            bloc.add(OnUpdateQuantity(productId: 'product-1', newQuantity: 5)),
        expect: () => [],
      );

      blocTest<PesananBloc, PesananState>(
        'should not emit if new quantity is 0 or negative',
        build: () => PesananBloc(
          costPengantaran: mockCostPengantaran,
          submitPesanan: mockSubmitPesanan,
        ),
        seed: () => const PesananState(cart: tCart),
        act: (bloc) =>
            bloc.add(OnUpdateQuantity(productId: 'product-1', newQuantity: 0)),
        expect: () => [],
      );
    });

    group('OnSubmitPesanan', () {
      blocTest<PesananBloc, PesananState>(
        'should emit [loading, submitted] when validation passes and preserve selectedShipping',
        build: () {
          when(
            mockSubmitPesanan(any, any),
          ).thenAnswer((_) async => const Right(tPesananResult));
          return PesananBloc(
            costPengantaran: mockCostPengantaran,
            submitPesanan: mockSubmitPesanan,
          );
        },
        seed: () => const PesananState(
          cart: tCart,
          selectedShipping: tSelectedShipping,
        ),
        act: (bloc) => bloc.add(OnSubmitPesanan()),
        expect: () => [
          const PesananState(
            status: PesananStatus.loading,
            cart: tCart,
            selectedShipping: tSelectedShipping,
          ),
          const PesananState(
            status: PesananStatus.submitted,
            cart: tCart,
            selectedShipping: tSelectedShipping,
            errorMessage: null,
            snapToken: 'snap-token-123',
            redirectUrl:
                'https://app.sandbox.midtrans.com/snap/v2/vtweb/snap-token-123',
            orderId: 'AW-123456-abc',
          ),
        ],
        verify: (_) {
          verify(mockSubmitPesanan(tCart, tSelectedShipping)).called(1);
        },
      );

      blocTest<PesananBloc, PesananState>(
        'should emit [loading, error] when validation fails and preserve selectedShipping',
        build: () {
          when(mockSubmitPesanan(any, any)).thenAnswer(
            (_) async => const Left(UnknownFailure('Nama harus diisi')),
          );
          return PesananBloc(
            costPengantaran: mockCostPengantaran,
            submitPesanan: mockSubmitPesanan,
          );
        },
        seed: () => const PesananState(
          cart: tCart,
          selectedShipping: tSelectedShipping,
        ),
        act: (bloc) => bloc.add(OnSubmitPesanan()),
        expect: () => [
          const PesananState(
            status: PesananStatus.loading,
            cart: tCart,
            selectedShipping: tSelectedShipping,
          ),
          const PesananState(
            status: PesananStatus.error,
            cart: tCart,
            selectedShipping: tSelectedShipping,
            errorMessage: 'Nama harus diisi',
          ),
        ],
      );

      blocTest<PesananBloc, PesananState>(
        'should emit error when cart is null and preserve selectedShipping',
        build: () => PesananBloc(
          costPengantaran: mockCostPengantaran,
          submitPesanan: mockSubmitPesanan,
        ),
        seed: () => const PesananState(selectedShipping: tSelectedShipping),
        act: (bloc) => bloc.add(OnSubmitPesanan()),
        expect: () => [
          const PesananState(
            status: PesananStatus.error,
            selectedShipping: tSelectedShipping,
            errorMessage: 'Data pesanan tidak lengkap',
          ),
        ],
        verify: (_) {
          verifyNever(mockSubmitPesanan(any, any));
        },
      );

      blocTest<PesananBloc, PesananState>(
        'should emit error when selectedShipping is null',
        build: () => PesananBloc(
          costPengantaran: mockCostPengantaran,
          submitPesanan: mockSubmitPesanan,
        ),
        seed: () => const PesananState(cart: tCart),
        act: (bloc) => bloc.add(OnSubmitPesanan()),
        expect: () => [
          const PesananState(
            status: PesananStatus.error,
            cart: tCart,
            errorMessage: 'Data pesanan tidak lengkap',
          ),
        ],
        verify: (_) {
          verifyNever(mockSubmitPesanan(any, any));
        },
      );
    });

    group('State totalPrice Calculation', () {
      test('should calculate totalPrice correctly', () {
        // Arrange
        const state = PesananState(
          cart: tCart,
          selectedShipping: tSelectedShipping,
        );

        // Assert
        expect(state.totalPrice, 115000); // 100000 + 15000
      });

      test('should return 0 when cart is null', () {
        // Arrange
        const state = PesananState();

        // Assert
        expect(state.totalPrice, 0);
      });

      test('should return only cart price when shipping is null', () {
        // Arrange
        const state = PesananState(cart: tCart);

        // Assert
        expect(state.totalPrice, 100000);
      });

      test('should return only shipping cost when cart is null', () {
        // Arrange
        const state = PesananState(selectedShipping: tSelectedShipping);

        // Assert
        expect(state.totalPrice, 15000);
      });
    });
  });
}
