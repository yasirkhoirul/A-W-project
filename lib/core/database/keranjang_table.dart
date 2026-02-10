import 'package:drift/drift.dart';

class KeranjangItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get barangId => text()();
  TextColumn get name => text()();
  IntColumn get price => integer()();
  TextColumn get category => text()();
  TextColumn get image => text()();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
}
