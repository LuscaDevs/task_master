import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_master/models/task_model.dart';

class DatabaseService {
  static final _databaseName = "task_master.db";
  static final _databaseVersion = 1;

  // Tornando o banco de dados um singleton
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;

  // Variável para armazenar o banco de dados
  static Database? _database;

  // Construtor privado para a classe singleton
  DatabaseService._internal();

  // Getter para acessar o banco de dados
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Inicializa o banco de dados na primeira vez que for acessado
    _database = await _initDatabase();
    return _database!;
  }

  // Método para inicializar o banco de dados
  Future<Database> _initDatabase() async {
    // Obtém o diretório do banco de dados
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    // Abre o banco de dados e o cria se não existir
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // Método que cria as tabelas quando o banco é criado pela primeira vez
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id TEXT PRIMARY KEY,
        title TEXT,
        description TEXT,
        dueDate TEXT,
        isCompleted INTEGER,
        category TEXT
      )
    ''');
  }

  // Função para inserir tarefa
  Future<void> insertTask(Task task) async {
    final db = await database;
    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace, // Substitui se já existir
    );
  }

  // Função para atualizar tarefa
  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Função para obter todas as tarefas
  Future<List<Task>> getAllTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return maps.map((map) => Task.fromMap(map)).toList();
  }

  // Função para obter uma tarefa pelo ID
  Future<Task?> getTaskById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Task(
        id: maps[0]['id'],
        title: maps[0]['title'],
        description: maps[0]['description'],
        dueDate: DateTime.parse(maps[0]['dueDate']),
        isCompleted: maps[0]['isCompleted'] == 1,
        category: maps[0]['category'],
      );
    } else {
      return null;
    }
  }

  // Função para excluir uma tarefa
  Future<void> deleteTask(String id) async {
    final db = await database;
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
