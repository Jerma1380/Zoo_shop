import 'package:flutter/material.dart';
import 'package:pks3/components/item_note.dart';


final List<String> titleNotes = <String>['Кот','Собака', 'Попугай', 'Аллигатор'];
final List<String> data = <String>['Хороший серый кот, очень воспитанный и вежливый. Иногда может странно смотреть на вас.','Добрая собака, всегда в хорошем настроении, но иногда грызет обувь.', 'Умный попугай, умеет говорить и иногда даже петь.', 'Купите аллигатора, пожалуйста...'];
final List<String> picture = <String>['lib/materials/Wire_Cat.png','lib/materials/dog.jpg', 'lib/materials/Bird.jpg', 'lib/materials/croc.jpg'];


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Каталог',  textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35), ),
      ),
      body: ListView.builder(
        itemCount: titleNotes.length,
        itemBuilder: (BuildContext context, int index) {
      return  ItemNote(title: titleNotes[index], data: data[index], picture: picture[index]);
      
      
      
    },),
    );
  }
}