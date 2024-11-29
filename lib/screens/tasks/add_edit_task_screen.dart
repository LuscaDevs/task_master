import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_master/models/task_model.dart';
import 'package:task_master/utils/globals.dart';
import 'package:task_master/services/database_service.dart'; // Importe o DatabaseService

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;

  const AddEditTaskScreen({super.key, this.task});

  @override
  _AddEditTaskScreenState createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String? _description;
  late DateTime _dueDate;
  late String _status;
  late String _category;
  String _selectedFilter = 'Todas';

  // Instância do DatabaseService
  final DatabaseService _dbService = DatabaseService();

  @override
  void initState() {
    super.initState();

    // Inicializa os campos com os dados da tarefa, se estiver editando
    if (widget.task != null) {
      _title = widget.task!.title;
      _description = widget.task!.description ?? '';
      _dueDate = widget.task!.dueDate!;
      _status = widget.task!.isCompleted ? 'Feita' : 'Pendente';
      _category = widget.task!.category ?? 'Pessoal';
      _selectedFilter = _category;
    } else {
      // Valores padrão para nova tarefa
      _title = '';
      _description = '';
      _dueDate = DateTime.now();
      _status = 'Pendente';
      _category = 'Pessoal';
    }
  }

  // Método de salvar a tarefa no banco de dados
  void _saveTask() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Cria um objeto Task com os dados preenchidos
      final task = Task(
        id: widget.task?.id ?? DateTime.now().toString(), // Gera um ID único
        title: _title,
        description: _description!.isEmpty ? null : _description,
        dueDate: _dueDate,
        isCompleted: _status == 'Feita',
        category: _category,
      );

      // Converte a tarefa em Map se necessário
      final taskMap = task.toMap();

      // Insere ou atualiza a tarefa
      if (widget.task != null) {
        // Atualiza a tarefa no banco de dados
        await _dbService.updateTask(task);
      } else {
        // Insere a nova tarefa no banco de dados
        await _dbService.insertTask(task);
      }

      // Retorna para a tela anterior com o Map, se precisar dele
      Navigator.of(context).pop(taskMap);
    }
  }

  void _showAddCategoryDialog() {
    String newCategory = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Categoria'),
          content: TextField(
            onChanged: (value) {
              newCategory = value;
            },
            decoration:
                const InputDecoration(hintText: 'Digite a nova categoria'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
            ),
            TextButton(
              child: const Text('Salvar'),
              onPressed: () {
                if (newCategory.isNotEmpty) {
                  setState(() {
                    Globals.categories
                        .add(newCategory); // Adiciona a nova categoria à lista
                  });
                }
                Navigator.of(context).pop(); // Fecha o diálogo
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[800] // Cor de fundo mais clara no tema escuro
          : Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800] // Cor de fundo mais clara no tema escuro
            : Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          widget.task != null ? 'Editar Tarefa' : 'Criar Tarefa',
          style: TextStyle(
            fontSize: 32, // Mantém o tamanho da fonte
            fontWeight: FontWeight.bold, // Mantém o peso da fonte
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white // Cor clara para o tema escuro
                : Colors.black, // Cor escura para o tema claro
          ),
        ),
      ),
      body: SingleChildScrollView(
        // Envolvendo o conteúdo em SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Preencha o formulário abaixo para continuar.',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                TextFormField(
                  style: const TextStyle(
                    fontSize: 28, // Define o tamanho da fonte
                    fontWeight: FontWeight.bold, // Deixa o texto em negrito
                  ),
                  initialValue: _title,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 20.0, // Padding vertical
                      horizontal: 15.0, // Padding horizontal
                    ),
                    filled: true,
                    fillColor: const Color(0xFFf1f4f8),
                    hintText: 'Tarefa...',
                    hintStyle: const TextStyle(
                      fontSize: 28, // Define o tamanho da fonte
                      fontWeight: FontWeight.bold, // Deixa o texto em negrito
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(16.0), // Borda mais arredondada
                      borderSide: const BorderSide(
                        color: Color(
                            0xFFe0e3e7), // Cor da borda quando o campo estiver ativo
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(16.0), // Borda mais arredondada
                      borderSide: const BorderSide(
                        color: Color(
                            0xFFe0e3e7), // Cor da borda quando o campo não estiver focado
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: const BorderSide(
                        color: Color(
                            0xFFe0e3e7), // Cor da borda quando o campo estiver focado
                        width: 2.0,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um título.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _title = value!;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  minLines: 3,
                  maxLines: 5,
                  initialValue: _description,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 20.0, // Padding vertical
                      horizontal: 15.0, // Padding horizontal
                    ),
                    filled: true,
                    fillColor: const Color(0xFFf1f4f8),
                    hintText: 'Descrição',
                    hintStyle: const TextStyle(
                      fontSize: 16, // Define o tamanho da fonte
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(16.0), // Borda mais arredondada
                      borderSide: const BorderSide(
                        color: Color(
                            0xFFe0e3e7), // Cor da borda quando o campo estiver ativo
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(16.0), // Borda mais arredondada
                      borderSide: const BorderSide(
                        color: Color(
                            0xFFe0e3e7), // Cor da borda quando o campo não estiver focado
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: const BorderSide(
                        color: Color(
                            0xFFe0e3e7), // Cor da borda quando o campo estiver focado
                        width: 2.0,
                      ),
                    ),
                  ),
                  onSaved: (value) {
                    _description = value!;
                  },
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Adicionar categorias',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                SingleChildScrollView(
                  scrollDirection:
                      Axis.horizontal, // Permite rolagem horizontal
                  child: Row(
                    children: Globals.categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          backgroundColor: Theme.of(context).brightness ==
                                  Brightness.dark
                              ? Colors.grey[
                                  800] // Cor de fundo mais clara no tema escuro
                              : Theme.of(context).scaffoldBackgroundColor,
                          selectedColor: const Color(0xFF4B39EF),
                          label: Text(
                            category,
                            style: TextStyle(
                              color: _selectedFilter == category
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                          ),
                          selected: _selectedFilter == category,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedFilter = category;
                                _category =
                                    category; // Atualiza a categoria selecionada
                              });
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextButton(
                  onPressed:
                      _showAddCategoryDialog, // Chama o método que mostra o diálogo
                  child: const Text(
                    'Adicionar nova categoria',
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Data e Hora: ${DateFormat('dd/MM/yyyy HH:mm').format(_dueDate)}',
                ),
                TextButton(
                  onPressed: () async {
                    // Exibe o seletor de data
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );

                    if (pickedDate != null) {
                      // Exibe o seletor de hora se a data for selecionada
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (pickedTime != null) {
                        // Combina a data e a hora selecionadas em um objeto DateTime
                        final DateTime pickedDateTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );

                        // Atualiza o estado com a data e hora selecionadas
                        setState(() {
                          _dueDate = pickedDateTime;
                        });
                      }
                    }
                  },
                  child: const Text('Selecionar data e hora'),
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: ['Pendente', 'Em progresso', 'Feita']
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _status = value!;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveTask,
        child: const Icon(Icons.check),
      ),
    );
  }
}
