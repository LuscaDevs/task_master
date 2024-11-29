import 'package:flutter/material.dart';
import 'package:task_master/models/task_model.dart';
import 'package:task_master/screens/settings/settings_profile_screen.dart';
import 'package:task_master/screens/tasks/add_edit_task_screen.dart';
import 'package:task_master/services/database_service.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String? _selectedCategory;
  String _searchQuery = ''; // Variável para armazenar o termo de pesquisa
  bool _isSearching = false; // Controle para o modo de pesquisa

  // Lista de tarefas temporária para exibir na tela
  List<Map<String, dynamic>> _tasks = [];
  List<String> _categories = []; // Lista para armazenar as categorias únicas

  @override
  void initState() {
    super.initState();
    _loadTasks(); // Carregar as tarefas do banco de dados
  }

  // Função para carregar as tarefas do banco de dados
  Future<void> _loadTasks() async {
    final tasks = await DatabaseService().getAllTasks();
    setState(() {
      _tasks =
          tasks.map((task) => task.toMap()).toList(); // Converte Task para Map
      _categories = _getCategoriesFromTasks(_tasks); // Atualiza as categorias
    });
  }

  // Função para obter as categorias únicas das tarefas
  List<String> _getCategoriesFromTasks(List<Map<String, dynamic>> tasks) {
    Set<String> categoriesSet = {};
    for (var task in tasks) {
      if (task['category'] != null && task['category'] is String) {
        categoriesSet.add(task['category']);
      }
    }
    return categoriesSet.toList();
  }

  // Filtro de tarefas
  List<Map<String, dynamic>> get _filteredTasks {
    List<Map<String, dynamic>> filteredTasks = _tasks;

    // Filtra por categoria selecionada
    if (_selectedCategory != null && _selectedCategory != 'Todas') {
      filteredTasks = filteredTasks
          .where((task) => task['category'] == _selectedCategory)
          .toList();
    }

    // Filtra por título ou descrição usando o termo de pesquisa
    if (_searchQuery.isNotEmpty) {
      filteredTasks = filteredTasks.where((task) {
        final title = (task['title'] as String).toLowerCase();
        final description =
            (task['description'] as String?)?.toLowerCase() ?? '';
        return title.contains(_searchQuery.toLowerCase()) ||
            description.contains(_searchQuery.toLowerCase());
      }).toList();
    }

    return filteredTasks;
  }

  // Widget para renderizar o status
  Widget _buildStatusTag(bool status) {
    Color color = status ? Colors.blue : Colors.teal;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        status ? 'Feita' : 'Pendente',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Método para excluir a tarefa
  Future<void> _deleteTask(String taskId) async {
    await DatabaseService()
        .deleteTask(taskId); // Exclui a tarefa do banco de dados

    setState(() {
      // Atualiza a lista removendo a tarefa excluída
      _tasks.removeWhere((task) => task['id'] == taskId);
      _loadTasks();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tarefa excluída com sucesso!'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Função para editar uma tarefa
  Future<void> _editTask(Map<String, dynamic> taskMap) async {
    // Converte o Map para Task
    Task task = Task.fromMap(taskMap);

    final updatedTask = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditTaskScreen(task: task),
      ),
    );

    if (updatedTask != null) {
      setState(() {
        // Atualiza a tarefa na lista local
        int index = _tasks.indexWhere((t) => t['id'] == task.id);
        if (index != -1) {
          _tasks[index] = updatedTask; // Substitui a tarefa
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tarefa editada com sucesso!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      _loadTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[800]
          : Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]
            : Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: !_isSearching
            ? Text(
                'Tarefas',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              )
            : TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Pesquisar tarefas...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
              ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              size: 30,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                _searchQuery = '';
              });
            },
          ),
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: Colors.blueGrey,
              child: Icon(Icons.person, color: Colors.white),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UserProfileScreen()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddEditTaskScreen(task: null),
            ),
          );

          if (newTask != null) {
            setState(() {
              _tasks.add(newTask);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tarefa adicionada com sucesso!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
            _loadTasks();
          }
        },
        backgroundColor: const Color(0xFF4B39EF),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Abaixo está um resumo das tarefas.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            // Adicionando os Choice Chips para filtro por categoria
            SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Define a rolagem horizontal
              child: Wrap(
                spacing: 8.0,
                children: [
                  for (var category in _categories)
                    ChoiceChip(
                      label: Text(
                        category,
                        style: TextStyle(
                          color: _selectedCategory == category
                              ? Colors.white
                              : Colors.grey,
                        ),
                      ),
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      selectedColor: const Color(0xFF4B39EF),
                      selected: _selectedCategory == category,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = selected ? category : null;
                        });
                      },
                    ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredTasks.length,
                itemBuilder: (context, index) {
                  var task = _filteredTasks[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 5.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task['title'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (task['description'] != null)
                                Text(
                                  task['description'] ?? 'Sem descrição',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              if (task['dueDate'] != null)
                                Text(
                                  'Vencimento: ${DateTime.parse(task['dueDate']).toString().substring(0, 10)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: DateTime.parse(task['dueDate'])
                                            .isBefore(DateTime.now())
                                        ? Colors.redAccent
                                        : Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        _buildStatusTag(task['isCompleted'] == 1),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _editTask(task),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteTask(task['id'].toString()),
                            ),
                          ],
                        ),
                        Checkbox(
                          value: task['isCompleted'] == 1,
                          onChanged: (bool? value) {
                            setState(() {
                              task['isCompleted'] = value! ? 1 : 0;

                              // Converter dueDate de String para DateTime
                              DateTime? dueDate = task['dueDate'] != null
                                  ? DateTime.parse(task['dueDate'])
                                  : null; // Verifica se dueDate não é nulo e converte para DateTime

                              // Criar um objeto Task
                              Task updatedTask = Task(
                                id: task['id'],
                                title: task['title'],
                                description: task['description'],
                                category: task['category'],
                                dueDate: dueDate, // Passa o DateTime
                                isCompleted: task['isCompleted'] == 1,
                              );

                              // Chama o método updateTask passando o objeto Task
                              DatabaseService().updateTask(updatedTask);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
