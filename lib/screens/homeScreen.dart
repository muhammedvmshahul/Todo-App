import 'package:flutter/material.dart';
import 'package:hivetodo/services/todo_Services.dart';
import 'package:intl/intl.dart';

import '../models/todo_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // validation



  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _lastDateController = TextEditingController();

  final TodoServices _todoServices = TodoServices();
  List<Todo> _todos = [];

// loading all todos- data fetching from hive

  Future<void> _loadTodos() async {
    _todos = await _todoServices.getTodos();
    setState(() {});
  }

  @override
  void initState() {
    _loadTodos();
    super.initState();
  }

  // validation

  // bool _validatetitle = false;
  // bool _validateDescription = false;
  // bool _validateDate = false;

  final _formKey = GlobalKey<FormState>();
  // final fieldBox = GlobalKey<AlerState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Todo Hive'),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          _showAddDialog();
          _titleController.clear();
          _descriptionController.clear();
          _lastDateController.clear();
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: ListView.builder(
            itemCount: _todos.length,
            itemBuilder: (context, index) {
              final todo = _todos[index];
              return Card(
                color: Colors.yellow,
                elevation: 5,
                child: Column(
                  children: [
                    ListTile(
                      leading:
                      CircleAvatar(
                        backgroundColor: Colors.black,
                        child: Text('${index + 1}',style: const TextStyle(color: Colors.white,fontSize: 20),),
                      ),
                      onTap: () {
                        // edit dialog
                        _showEditDialog(todo, index);
                      },
                      title: Text(
                        todo.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 20),
                      ),
                      subtitle: Text(
                        todo.description,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                      trailing: Checkbox(
                        value: todo.completed,
                        onChanged: (value) {
                          setState(() {
                            // value toggle
                            todo.completed = value!;
                            // update the hive db
                            _todoServices.updateTodo(index, todo);
                            setState(() {});
                          });
                        },
                      ),
                    ),
                    const Divider(
                      color: Colors.black,
                    ),
                    Row(
                      children: [
                       const  SizedBox(width: 10,),
                        Text(
                          'Deadline : ${todo.lastDate}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 16),
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () async {
                              await _todoServices.deleteTodo(index);
                              _titleController.clear();
                              _descriptionController.clear();
                              _lastDateController.clear();
                              _loadTodos();
                            },
                            icon:  const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ))
                      ],
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }

  // show add dialog
  Future<void> _showAddDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: Form(
              key: _formKey,
              child: SizedBox(
                height: 300,
                // width: 250,
                child: Column(
                  children: [
                    const Text(
                      'Add new Task',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    // Add Title
                    TextFormField(
                      controller: _titleController,
                      decoration:  const InputDecoration(hintText: 'Title',
                      ), validator: (value){
                      if(value!.isEmpty){
                        return 'Description can\'t be empty';
                      }
                      else if(!RegExp(r'[a-z A-Z]+$').hasMatch(value)){
                        return 'letters value must';
                      }else{
                        return null;
                      }
                    },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // Add description
                    TextFormField(
                      controller: _descriptionController,
                      decoration:  const InputDecoration(hintText: 'Description',
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Description can\'t be empty';
                        }
                        else if(!RegExp(r'[a-z A-Z]+$').hasMatch(value)){
                          return 'letters value must';
                        }else{
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // Add lastDate
                    TextFormField(
                      controller: _lastDateController,
                      readOnly: true,
                      onTap: () async {
                        final DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100).add(const Duration(days: 365)),
                        );
                        final formattedDate =
                            DateFormat("dd-MM-yyyy").format(date!);
                        setState(() {
                          _lastDateController.text = formattedDate.toString();
                        });
                      },
                      decoration: const InputDecoration(
                        icon:  Icon(Icons.date_range_sharp),
                        hintText: 'LastDate',
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Date can\'t be empty';
                        }else{
                          return null;
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () async {
                    if( _formKey.currentState!.validate()){
                      final newTodo = Todo(
                      title: _titleController.text,
                      description:_descriptionController.text,
                      lastDate:_lastDateController.text,
                        completed: false,
                      );
                      await _todoServices.addTodo(newTodo);
                      _loadTodos();
                      Navigator.pus
                        _titleController.clear();
                        _descriptionController.clear();
                        _lastDateController.clear();
                    }
                  },
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () {
                    Navigator.pop(context);
                    _titleController.clear();
                    _descriptionController.clear();
                    _lastDateController.clear();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          );
        });
  }

  // edit dialog

  Future<void> _showEditDialog(Todo todo, int index) async {
    _titleController.text = todo.title;
    _descriptionController.text = todo.description;
    _lastDateController.text = todo.lastDate;
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // key: fieldBox,
            backgroundColor: Colors.white,
            content: Form(
              key: _formKey,
              child: SizedBox(

                height: 300,
                child: Column(

                  children: [
                    const Text(
                      'Add new Task',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    // Add Title
                    TextFormField(
                      controller: _titleController,
                      decoration:  const InputDecoration(hintText: 'Title',
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Description can\'t be empty';
                        }
                        else if(!RegExp(r'[a-z A-Z]+$').hasMatch(value)){
                          return 'letters value must';
                        }else{
                          return null;
                        }
                      },

                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // Add description
                    TextFormField(
                      controller: _descriptionController,
                      decoration:  const InputDecoration(hintText: 'Description',
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Description can\'t be empty';
                        }
                        else if(!RegExp(r'[a-z A-Z]+$').hasMatch(value)){
                          return 'letters value must';
                        }else{
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // Add lastDate
                    TextFormField(
                      controller: _lastDateController,
                      readOnly: true,
                      onTap: () async {
                        final DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100).add(const Duration(days: 365)),
                        );
                        final formattedDate =
                            DateFormat("dd-MM-yyyy").format(date!);
                        setState(() {
                          _lastDateController.text = formattedDate.toString();
                        });
                      },
                      decoration:  const InputDecoration(
                        icon:  Icon(Icons.date_range_sharp),
                        hintText: 'LastDate',
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Date can\'t be empty';
                        }else{
                          return null;
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () async {
                    if( _formKey.currentState!.validate()){
                      todo.title = _titleController.text;
                        todo.description = _descriptionController.text;
                        todo.lastDate = _lastDateController.text;
                        await _todoServices.updateTodo(index, todo);
                        _loadTodos();
                      Navigator.pop(context);
                    }

                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          );
        });
  }
}
