import 'dart:convert';
import 'package:a_and_w/features/auth/data/model/profile_model.dart';
import 'package:a_and_w/core/entities/profile.dart';
import 'package:a_and_w/core/models/address_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../dummy_data/json_reader.dart';

void main() {
  const tProfileModel = ProfileModel(
    uid: 'MI1L3LePEqZyfuoQoqEGyoGR3Aw2',
    email: 'yasir@gmail.com',
    nama: 'User Baru12',
    phoneNumber: null,
    address: null,
  );

  const tProfileModelWithAddress = ProfileModel(
    uid: 'MI1L3LePEqZyfuoQoqEGyoGR3Aw2',
    email: 'yasir@gmail.com',
    nama: 'User Baru12',
    phoneNumber: '081232134546',
    address: AddressModel(
      provinsi: DataAddressModel(id: 2, nama: 'MALUKU'),
      kota: DataAddressModel(id: 11, nama: 'AMBON'),
      district: DataAddressModel(id: 118, nama: 'SIRIMAU'),
    ),
  );

  group('ProfileModel', () {
   
    group('fromJson', () {
      test('should return a valid model from JSON without address', () {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(
          readJson('dummy_data/profile_base.json'),
        );

        // act
        final result = ProfileModel.fromJson(jsonMap);

        // assert
        expect(result.uid, tProfileModel.uid);
        expect(result.email, tProfileModel.email);
        expect(result.nama, tProfileModel.nama);
        expect(result.phoneNumber, isNull);
        expect(result.address, isNull);
      });

      test('should return a valid model from JSON with address', () {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(
          readJson('dummy_data/profile.json'),
        );

        // act
        final result = ProfileModel.fromJson(jsonMap);

        // assert
        expect(result.uid, tProfileModelWithAddress.uid);
        expect(result.email, tProfileModelWithAddress.email);
        expect(result.nama, tProfileModelWithAddress.nama);
        expect(result.phoneNumber, '081232134546');
        expect(result.address, isNotNull);
        expect(result.address?.provinsi.id, 2);
        expect(result.address?.provinsi.nama, 'MALUKU');
        expect(result.address?.kota.id, 11);
        expect(result.address?.kota.nama, 'AMBON');
        expect(result.address?.district.id, 118);
        expect(result.address?.district.nama, 'SIRIMAU');
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data without address', () {
        // act
        final result = tProfileModel.toJson();

        // assert
        final expectedMap = {
          'uid': 'MI1L3LePEqZyfuoQoqEGyoGR3Aw2',
          'email': 'yasir@gmail.com',
          'displayName': 'User Baru12',
          'phoneNumber': null,
          'address': null,
        };

        expect(result, expectedMap);
      });

      test('should return a JSON map containing proper data with address', () {
        // act
        final result = tProfileModelWithAddress.toJson();

        // assert
        expect(result['uid'], 'MI1L3LePEqZyfuoQoqEGyoGR3Aw2');
        expect(result['email'], 'yasir@gmail.com');
        expect(result['displayName'], 'User Baru12');
        expect(result['phoneNumber'], '081232134546');
        expect(result['address'], isNotNull);
        expect(result['address']['provinsi']['id'], 2);
        expect(result['address']['provinsi']['nama'], 'MALUKU');
        expect(result['address']['kota']['id'], 11);
        expect(result['address']['kota']['nama'], 'AMBON');
        expect(result['address']['district']['id'], 118);
        expect(result['address']['district']['nama'], 'SIRIMAU');
      });
    });

    group('toEntity', () {
      test('should convert ProfileModel to Profile entity', () {
        // act
        final result = tProfileModel.toEntity();

        // assert
        expect(result, isA<Profile>());
        expect(result.uid, tProfileModel.uid);
        expect(result.email, tProfileModel.email);
        expect(result.nama, tProfileModel.nama);
        expect(result.phoneNumber, tProfileModel.phoneNumber);
        expect(result.address, tProfileModel.address?.toEntity());
      });

      test('should convert ProfileModel with address to Profile entity', () {
        // act
        final result = tProfileModelWithAddress.toEntity();

        // assert
        expect(result, isA<Profile>());
        expect(result.address, isNotNull);
        expect(result.address?.provinsi.id, 2);
        expect(result.address?.provinsi.nama, 'MALUKU');
      });
    });

    group('fromEntity', () {
      test('should create ProfileModel from Profile entity', () {
        // arrange
        final entity = tProfileModel.toEntity();

        // act
        final result = ProfileModel.fromEntity(entity);

        // assert
        expect(result, isA<ProfileModel>());
        expect(result.uid, entity.uid);
        expect(result.email, entity.email);
        expect(result.nama, entity.nama);
      });

      test('should create ProfileModel with address from Profile entity', () {
        // arrange
        final entity = tProfileModelWithAddress.toEntity();

        // act
        final result = ProfileModel.fromEntity(entity);

        // assert
        expect(result, isA<ProfileModel>());
        expect(result.address, isNotNull);
        expect(result.address?.provinsi.id, 2);
        expect(result.address?.kota.id, 11);
        expect(result.address?.district.id, 118);
      });
    });
  });

  group('AddressModel', () {
    const tAddressModel = AddressModel(
      provinsi: DataAddressModel(id: 2, nama: 'MALUKU'),
      kota: DataAddressModel(id: 11, nama: 'AMBON'),
      district: DataAddressModel(id: 118, nama: 'SIRIMAU'),
    );

    test('should convert to Address entity', () {
      // act
      final result = tAddressModel.toEntity();

      // assert
      expect(result, isA<Address>());
      expect(result.provinsi.id, 2);
      expect(result.provinsi.nama, 'MALUKU');
      expect(result.kota.id, 11);
      expect(result.district.id, 118);
    });

    test('should create from Address entity', () {
      // arrange
      final entity = tAddressModel.toEntity();

      // act
      final result = AddressModel.fromEntity(entity);

      // assert
      expect(result, isA<AddressModel>());
      expect(result.provinsi.id, entity.provinsi.id);
      expect(result.kota.id, entity.kota.id);
      expect(result.district.id, entity.district.id);
    });
  });

  group('DataAddressModel', () {
    const tDataAddressModel = DataAddressModel(id: 2, nama: 'MALUKU');

    test('should convert to DataAddress entity', () {
      // act
      final result = tDataAddressModel.toEntity();

      // assert
      expect(result, isA<DataAddress>());
      expect(result.id, 2);
      expect(result.nama, 'MALUKU');
    });

    test('should create from DataAddress entity', () {
      // arrange
      final entity = tDataAddressModel.toEntity();

      // act
      final result = DataAddressModel.fromEntity(entity);

      // assert
      expect(result, isA<DataAddressModel>());
      expect(result.id, entity.id);
      expect(result.nama, entity.nama);
    });
  });
}
