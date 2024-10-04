import 'package:flutter/material.dart';
import 'package:pks3/components/item_note.dart';
import 'package:pks3/pages/create_page.dart';


final List<String> titleNotes = <String>['Кот','Собака', 'Попугай', 'Аллигатор'];
final List<String> data = <String>['Хороший серый кот, очень воспитанный и вежливый. Иногда может странно смотреть на вас.','Добрая собака, всегда в хорошем настроении, но иногда грызет обувь.', 'Умный попугай, умеет говорить и иногда даже петь.', 'Купите аллигатора, пожалуйста...'];
final List<String> picture = <String>['https://static.wikia.nocookie.net/silly-cat/images/4/4f/Wire_Cat.png','https://image.petmd.com/files/styles/978x550/public/2024-06/hip-dysplasia-in-dogs.jpg', 'https://t4.ftcdn.net/jpg/01/77/47/67/360_F_177476718_VWfYMWCzK32bfPI308wZljGHvAUYSJcn.jpg', 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Brookfield_zoo_fg06.jpg/640px-Brookfield_zoo_fg06.jpg'];


class HomePage extends StatelessWidget {
  const HomePage({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Каталог',  textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35), ),
      actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreatePage()), 
              );
              
            }, style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 143, 218, 255), foregroundColor: const Color.fromARGB(255, 0, 0, 0)),
            child: const Text('Редактирование товаров', style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 62, 61, 61)),
            ),
          ),
        ],
      ),
      
       
    
      body: ListView.builder(
        itemCount: titleNotes.length,
        itemBuilder: (BuildContext context, int index) {
      return  ItemNote(title: titleNotes[index], data: data[index], picture: picture[index]);
       
      
    },),
    );
  }
}