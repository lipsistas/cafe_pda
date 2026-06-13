import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('cafe_v6.db'); // Αλλαγή σε v6
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    if (Platform.isLinux || Platform.isWindows) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // Πίνακας Εργαζομένων με σωστό διαχωρισμό (πρόσθεσα το κόμμα)
    await db.execute('''
      CREATE TABLE employees (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        role TEXT
      )
    ''');
    
    // Εγγραφή του Admin
    await db.insert('employees', {'id': 101, 'name': 'Λουκάς', 'role': 'admin'});
    // Εγγραφή ενός απλού χρήστη για δοκιμή
    await db.insert('employees', {'id': 200, 'name': 'Γιάννης', 'role': 'user'});

    // Πίνακας Προϊόντων
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        category TEXT NOT NULL
      )
    ''');

    // Πίνακας Παραγγελιών
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
        FOREIGN KEY (opened_by_employee_id) REFERENCES employees (id),
        FOREIGN KEY (product_id) REFERENCES products (id)
      )
    ''');
  }

  Future<Map<String, dynamic>?> getEmployeeById(int id) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'employees',
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty ? maps.first : null;
  }
// Λίστα όλων των εργαζομένων
  Future<List<Map<String, dynamic>>> fetchAllEmployees() async {
    final db = await instance.database;
    return await db.query('employees');
  }

  // Προσθήκη εργαζόμενου
  Future<int> insertEmployee(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('employees', row);
  }
  // Διαγραφή εργαζόμενου
  Future<int> deleteEmployee(int id) async {
    final db = await instance.database;
    return await db.delete(
      'employees', 
      where: 'id = ?', 
      whereArgs: [id],
    );
  }
}
