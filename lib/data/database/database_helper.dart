import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('cafe_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    // Αν τρέχουμε σε Linux ή Windows, αρχικοποιούμε τη μηχανή FFI για Desktop
    if (Platform.isLinux || Platform.isWindows) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE employees (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        category TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        table_number INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        quantity INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        opened_by_employee_id INTEGER NOT NULL,
        status TEXT NOT NULL,
        is_paid INTEGER NOT NULL,
        closed_by_employee_id INTEGER,
        FOREIGN KEY (opened_by_employee_id) REFERENCES employees (id),
        FOREIGN KEY (product_id) REFERENCES products (id)
      )
    ''');
  }

  // ==========================================
  // ΣΥΝΑΡΤΗΣΕΙΣ ΓΙΑ ΕΡΓΑΖΟΜΕΝΟΥΣ (Employees)
  // ==========================================

  Future<int> insertEmployee(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('employees', row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> fetchAllEmployees() async {
    final db = await instance.database;
    return await db.query('employees');
  }

  // ==========================================
  // ΣΥΝΑΡΤΗΣΕΙΣ ΓΙΑ ΠΡΟΪΟΝΤΑ (Products)
  // ==========================================

  Future<int> insertProduct(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('products', row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> fetchAllProducts() async {
    final db = await instance.database;
    return await db.query('products');
  }

  // ==========================================
  // ΣΥΝΑΡΤΗΣΕΙΣ ΓΙΑ ΠΑΡΑΓΓΕΛΙΕΣ (Orders)
  // ==========================================

  Future<int> insertOrder(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('orders', row);
  }

  Future<List<Map<String, dynamic>>> fetchOpenOrdersByTable(int tableNumber) async {
    final db = await instance.database;
    return await db.query(
      'orders',
      where: 'table_number = ? AND is_paid = 0',
      whereArgs: [tableNumber],
    );
  }

  Future<int> updateOrderStatus(int orderId, String newStatus) async {
    final db = await instance.database;
    return await db.update(
      'orders',
      {'status': newStatus},
      where: 'id = ?',
      whereArgs: [orderId],
    );
  }

  Future<int> closeOrder(int orderId, int employeeId) async {
    final db = await instance.database;
    return await db.update(
      'orders',
      {
        'is_paid': 1,
        'closed_by_employee_id': employeeId,
      },
      where: 'id = ?',
      whereArgs: [orderId],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
} // Εδώ κλείνει σωστά η κλάση DatabaseHelper
