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
    return await openDatabase(
      path, 
      version: 2, 
      onCreate: _createDB, 
      onUpgrade: _upgradeDB,
      onOpen: (db) {
        print('Database opened successfully');
      },
    );
  }

  Future<void> _createDB(Database db, int version) async {
    print('Creating database tables');
    try {
      await db.execute('''
      CREATE TABLE properties(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        totalAmount REAL,
        startDate TEXT,
        endDate TEXT,
        paidAmount REAL,
        area REAL,
        country TEXT,
        location TEXT
      )
      ''');
      print('Database tables created successfully');
    } catch (e) {
      print('Error creating database tables: $e');
    }
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    print('Upgrading database from version $oldVersion to $newVersion');
    if (oldVersion < 2) {
      try {
        await db.execute('ALTER TABLE properties ADD COLUMN paidAmount REAL DEFAULT 0.0');
        await db.execute('ALTER TABLE properties ADD COLUMN area REAL DEFAULT 0.0');
        await db.execute('ALTER TABLE properties ADD COLUMN country TEXT DEFAULT ""');
        await db.execute('ALTER TABLE properties ADD COLUMN location TEXT DEFAULT ""');
        print('Database upgraded successfully');
      } catch (e) {
        print('Error upgrading database: $e');
      }
    }
  }

  Future<int> createProperty(Property property) async {
    try {
      final db = await instance.database;
      final id = await db.insert('properties', property.toMap());
      print('Created property with id: $id');
      return id;
    } catch (e) {
      print('Error creating property: $e');
      return -1;
    }
  }

  Future<List<Property>> getAllProperties() async {
    try {
      final db = await instance.database;
      final result = await db.query('properties');
      print('Retrieved ${result.length} properties from database');
      print('Raw data from database: $result');
      
      List<Property> properties = [];
      for (var row in result) {
        try {
          properties.add(Property.fromMap(row));
        } catch (e) {
          print('Error converting property: $e');
          // Пропускаем проблемную запись и продолжаем с следующей
        }
      }
      
      print('Successfully converted ${properties.length} properties');
      return properties;
    } catch (e) {
      print('Error getting all properties: $e');
      return [];
    }
  }

  Future<Property?> getProperty(int id) async {
    try {
      final db = await instance.database;
      final maps = await db.query(
        'properties',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        print('Retrieved property with id: $id');
        return Property.fromMap(maps.first);
      } else {
        print('No property found with id: $id');
        return null;
      }
    } catch (e) {
      print('Error getting property: $e');
      return null;
    }
  }

  Future<int> updateProperty(Property property) async {
    try {
      final db = await instance.database;
      final result = await db.update(
        'properties',
        property.toMap(),
        where: 'id = ?',
        whereArgs: [property.id],
      );
      print('Updated property with id: ${property.id}. Rows affected: $result');
      return result;
    } catch (e) {
      print('Error updating property: $e');
      return -1;
    }
  }

  Future<int> deleteProperty(int id) async {
    try {
      final db = await instance.database;
      final result = await db.delete(
        'properties',
        where: 'id = ?',
        whereArgs: [id],
      );
      print('Deleted property with id: $id. Rows affected: $result');
      return result;
    } catch (e) {
      print('Error deleting property: $e');
      return -1;
    }
  }

  Future<void> closeDatabase() async {
    try {
      final db = await instance.database;
      await db.close();
      _database = null;
      print('Database closed successfully');
    } catch (e) {
      print('Error closing database: $e');
    }
  }
}