import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/property.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('properties.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    print('Initializing database at $path');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    print('Creating database tables');
    await db.execute('''
    CREATE TABLE properties(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      totalAmount REAL,
      startDate TEXT,
      endDate TEXT
    )
    ''');
    print('Database tables created successfully');
  }

  Future<int> createProperty(Property property) async {
    final db = await instance.database;
    final id = await db.insert('properties', property.toMap());
    print('Created property with id: $id');
    return id;
  }

  Future<List<Property>> getAllProperties() async {
    final db = await instance.database;
    final result = await db.query('properties');
    print('Retrieved ${result.length} properties from database');
    return result.map((json) => Property.fromMap(json)).toList();
  }

  Future<Property?> getProperty(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'properties',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Property.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> updateProperty(Property property) async {
    final db = await instance.database;
    return await db.update(
      'properties',
      property.toMap(),
      where: 'id = ?',
      whereArgs: [property.id],
    );
  }

  Future<int> deleteProperty(int id) async {
    final db = await instance.database;
    return await db.delete(
      'properties',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> closeDatabase() async {
    final db = await instance.database;
    db.close();
    _database = null;
  }
}