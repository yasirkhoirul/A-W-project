// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $KeranjangItemsTable extends KeranjangItems
    with TableInfo<$KeranjangItemsTable, KeranjangItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KeranjangItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _barangIdMeta = const VerificationMeta(
    'barangId',
  );
  @override
  late final GeneratedColumn<String> barangId = GeneratedColumn<String>(
    'barang_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<int> price = GeneratedColumn<int>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
    'image',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    barangId,
    name,
    price,
    category,
    image,
    quantity,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'keranjang_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<KeranjangItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('barang_id')) {
      context.handle(
        _barangIdMeta,
        barangId.isAcceptableOrUnknown(data['barang_id']!, _barangIdMeta),
      );
    } else if (isInserting) {
      context.missing(_barangIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('image')) {
      context.handle(
        _imageMeta,
        image.isAcceptableOrUnknown(data['image']!, _imageMeta),
      );
    } else if (isInserting) {
      context.missing(_imageMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KeranjangItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KeranjangItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      barangId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barang_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      image: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
    );
  }

  @override
  $KeranjangItemsTable createAlias(String alias) {
    return $KeranjangItemsTable(attachedDatabase, alias);
  }
}

class KeranjangItem extends DataClass implements Insertable<KeranjangItem> {
  final int id;
  final String barangId;
  final String name;
  final int price;
  final String category;
  final String image;
  final int quantity;
  const KeranjangItem({
    required this.id,
    required this.barangId,
    required this.name,
    required this.price,
    required this.category,
    required this.image,
    required this.quantity,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['barang_id'] = Variable<String>(barangId);
    map['name'] = Variable<String>(name);
    map['price'] = Variable<int>(price);
    map['category'] = Variable<String>(category);
    map['image'] = Variable<String>(image);
    map['quantity'] = Variable<int>(quantity);
    return map;
  }

  KeranjangItemsCompanion toCompanion(bool nullToAbsent) {
    return KeranjangItemsCompanion(
      id: Value(id),
      barangId: Value(barangId),
      name: Value(name),
      price: Value(price),
      category: Value(category),
      image: Value(image),
      quantity: Value(quantity),
    );
  }

  factory KeranjangItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KeranjangItem(
      id: serializer.fromJson<int>(json['id']),
      barangId: serializer.fromJson<String>(json['barangId']),
      name: serializer.fromJson<String>(json['name']),
      price: serializer.fromJson<int>(json['price']),
      category: serializer.fromJson<String>(json['category']),
      image: serializer.fromJson<String>(json['image']),
      quantity: serializer.fromJson<int>(json['quantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'barangId': serializer.toJson<String>(barangId),
      'name': serializer.toJson<String>(name),
      'price': serializer.toJson<int>(price),
      'category': serializer.toJson<String>(category),
      'image': serializer.toJson<String>(image),
      'quantity': serializer.toJson<int>(quantity),
    };
  }

  KeranjangItem copyWith({
    int? id,
    String? barangId,
    String? name,
    int? price,
    String? category,
    String? image,
    int? quantity,
  }) => KeranjangItem(
    id: id ?? this.id,
    barangId: barangId ?? this.barangId,
    name: name ?? this.name,
    price: price ?? this.price,
    category: category ?? this.category,
    image: image ?? this.image,
    quantity: quantity ?? this.quantity,
  );
  KeranjangItem copyWithCompanion(KeranjangItemsCompanion data) {
    return KeranjangItem(
      id: data.id.present ? data.id.value : this.id,
      barangId: data.barangId.present ? data.barangId.value : this.barangId,
      name: data.name.present ? data.name.value : this.name,
      price: data.price.present ? data.price.value : this.price,
      category: data.category.present ? data.category.value : this.category,
      image: data.image.present ? data.image.value : this.image,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KeranjangItem(')
          ..write('id: $id, ')
          ..write('barangId: $barangId, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('category: $category, ')
          ..write('image: $image, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, barangId, name, price, category, image, quantity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KeranjangItem &&
          other.id == this.id &&
          other.barangId == this.barangId &&
          other.name == this.name &&
          other.price == this.price &&
          other.category == this.category &&
          other.image == this.image &&
          other.quantity == this.quantity);
}

class KeranjangItemsCompanion extends UpdateCompanion<KeranjangItem> {
  final Value<int> id;
  final Value<String> barangId;
  final Value<String> name;
  final Value<int> price;
  final Value<String> category;
  final Value<String> image;
  final Value<int> quantity;
  const KeranjangItemsCompanion({
    this.id = const Value.absent(),
    this.barangId = const Value.absent(),
    this.name = const Value.absent(),
    this.price = const Value.absent(),
    this.category = const Value.absent(),
    this.image = const Value.absent(),
    this.quantity = const Value.absent(),
  });
  KeranjangItemsCompanion.insert({
    this.id = const Value.absent(),
    required String barangId,
    required String name,
    required int price,
    required String category,
    required String image,
    this.quantity = const Value.absent(),
  }) : barangId = Value(barangId),
       name = Value(name),
       price = Value(price),
       category = Value(category),
       image = Value(image);
  static Insertable<KeranjangItem> custom({
    Expression<int>? id,
    Expression<String>? barangId,
    Expression<String>? name,
    Expression<int>? price,
    Expression<String>? category,
    Expression<String>? image,
    Expression<int>? quantity,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (barangId != null) 'barang_id': barangId,
      if (name != null) 'name': name,
      if (price != null) 'price': price,
      if (category != null) 'category': category,
      if (image != null) 'image': image,
      if (quantity != null) 'quantity': quantity,
    });
  }

  KeranjangItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? barangId,
    Value<String>? name,
    Value<int>? price,
    Value<String>? category,
    Value<String>? image,
    Value<int>? quantity,
  }) {
    return KeranjangItemsCompanion(
      id: id ?? this.id,
      barangId: barangId ?? this.barangId,
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      image: image ?? this.image,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (barangId.present) {
      map['barang_id'] = Variable<String>(barangId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (price.present) {
      map['price'] = Variable<int>(price.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KeranjangItemsCompanion(')
          ..write('id: $id, ')
          ..write('barangId: $barangId, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('category: $category, ')
          ..write('image: $image, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $KeranjangItemsTable keranjangItems = $KeranjangItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [keranjangItems];
}

typedef $$KeranjangItemsTableCreateCompanionBuilder =
    KeranjangItemsCompanion Function({
      Value<int> id,
      required String barangId,
      required String name,
      required int price,
      required String category,
      required String image,
      Value<int> quantity,
    });
typedef $$KeranjangItemsTableUpdateCompanionBuilder =
    KeranjangItemsCompanion Function({
      Value<int> id,
      Value<String> barangId,
      Value<String> name,
      Value<int> price,
      Value<String> category,
      Value<String> image,
      Value<int> quantity,
    });

class $$KeranjangItemsTableFilterComposer
    extends Composer<_$AppDatabase, $KeranjangItemsTable> {
  $$KeranjangItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barangId => $composableBuilder(
    column: $table.barangId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );
}

class $$KeranjangItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $KeranjangItemsTable> {
  $$KeranjangItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barangId => $composableBuilder(
    column: $table.barangId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KeranjangItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $KeranjangItemsTable> {
  $$KeranjangItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get barangId =>
      $composableBuilder(column: $table.barangId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);
}

class $$KeranjangItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KeranjangItemsTable,
          KeranjangItem,
          $$KeranjangItemsTableFilterComposer,
          $$KeranjangItemsTableOrderingComposer,
          $$KeranjangItemsTableAnnotationComposer,
          $$KeranjangItemsTableCreateCompanionBuilder,
          $$KeranjangItemsTableUpdateCompanionBuilder,
          (
            KeranjangItem,
            BaseReferences<_$AppDatabase, $KeranjangItemsTable, KeranjangItem>,
          ),
          KeranjangItem,
          PrefetchHooks Function()
        > {
  $$KeranjangItemsTableTableManager(
    _$AppDatabase db,
    $KeranjangItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KeranjangItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KeranjangItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KeranjangItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> barangId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> price = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> image = const Value.absent(),
                Value<int> quantity = const Value.absent(),
              }) => KeranjangItemsCompanion(
                id: id,
                barangId: barangId,
                name: name,
                price: price,
                category: category,
                image: image,
                quantity: quantity,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String barangId,
                required String name,
                required int price,
                required String category,
                required String image,
                Value<int> quantity = const Value.absent(),
              }) => KeranjangItemsCompanion.insert(
                id: id,
                barangId: barangId,
                name: name,
                price: price,
                category: category,
                image: image,
                quantity: quantity,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$KeranjangItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KeranjangItemsTable,
      KeranjangItem,
      $$KeranjangItemsTableFilterComposer,
      $$KeranjangItemsTableOrderingComposer,
      $$KeranjangItemsTableAnnotationComposer,
      $$KeranjangItemsTableCreateCompanionBuilder,
      $$KeranjangItemsTableUpdateCompanionBuilder,
      (
        KeranjangItem,
        BaseReferences<_$AppDatabase, $KeranjangItemsTable, KeranjangItem>,
      ),
      KeranjangItem,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$KeranjangItemsTableTableManager get keranjangItems =>
      $$KeranjangItemsTableTableManager(_db, _db.keranjangItems);
}
