import 'package:flutter/material.dart';

import 'package:pks3/pages/note_page.dart';



class ItemNote extends StatelessWidget {
  const ItemNote({super.key, required this.title, required this.data, required this.picture});


  final String title;
  final String data;
  final String picture;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  NotePage(picture: picture, data: data)),
          ), 
          child: Container(
            decoration: BoxDecoration(color: const Color.fromARGB(255, 143, 218, 255), borderRadius: BorderRadius.circular(16.0)),  
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.4,
            child:  Center(
              child: Column (
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: const TextStyle(color: Color.fromARGB(255, 62, 61, 61), fontSize: 24),
                 
                  ),
                  Image.asset(picture, width: 260, height: 180, fit: BoxFit.fill,),
                   
                  Padding( 
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(width: 200, height: 40,
                      child: TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>  NotePage(picture: picture, data: data)));    
                            
                      },   style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 238, 235, 235), foregroundColor: const Color.fromARGB(255, 0, 0, 0)),
                      
                      child: const Text('Подробнее', style: TextStyle(color: Color.fromARGB(255, 62, 61, 61), height: 0) )),
                    ),
                  )
                ],
              ),
            ),
            
          ),
        ),
      );
  }
}