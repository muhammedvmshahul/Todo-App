





import 'package:hive/hive.dart';

import '../models/todo_model.dart';

class TodoServices{

  Box<Todo>?_todoBox;

  Future<void>openBox()async{
    _todoBox = await Hive.openBox<Todo>('todos');
  }

  Future<void>closeBox()async{
    await _todoBox!.close();
  }

  // add to do

Future<void>addTodo(Todo todo)async{
    if(_todoBox == null){
      await openBox();
    }
    await _todoBox!.add(todo);
}

// get to do

Future<List<Todo>>getTodos()async{
      if(_todoBox == null){
        await openBox();

      }
      return _todoBox!.values.toList();
}


// update to do

Future<void>updateTodo(int index, Todo todo)async{
    if(_todoBox == null){
      await openBox();
    }
    await _todoBox!.putAt(index, todo);
    print('updated');
}

// delete to do

Future<void>deleteTodo(int index)async{
    if(_todoBox == null){
      await openBox();
    }
    await _todoBox!.deleteAt(index);
}

}