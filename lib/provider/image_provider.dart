import 'package:flutter/material.dart';

class ImageProviders extends ChangeNotifier {
  //--2056

  List<String> _imgPaths = [
    "https://images.unsplash.com/photo-1584473457406-6240486418e9?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8Z3JvY2VyaWVzfGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1579113800032-c38bd7635818?ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8Z3JvY2VyaWVzfGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1506617564039-2f3b650b7010?ixid=MnwxMjA3fDB8MHxzZWFyY2h8N3x8Z3JvY2VyaWVzfGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1571211905393-6de67ff8fb61?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTR8fGdyb2Nlcmllc3xlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1553531889-56cc480ac5cb?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTJ8fGdyb2Nlcmllc3xlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1537130508986-20f4fd870b4e?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTV8fGdyb2Nlcmllc3xlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1582803824122-f25becf36ad8?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjR8fGdyb2Nlcmllc3xlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1614695639449-b305bfe37142?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mjh8fGdyb2Nlcmllc3xlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1584680226833-0d680d0a0794?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mjl8fGdyb2Nlcmllc3xlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1614907634002-65ac4cb74acb?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mzl8fGdyb2Nlcmllc3xlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1544816155-12df9643f363?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MzR8fGdyb2Nlcmllc3xlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1607289763628-c966b7e1ab90?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDF8fGdyb2Nlcmllc3xlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1574722772656-8839e6ef7a12?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDB8fGdyb2Nlcmllc3xlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1598906443921-9b6a62087872?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDJ8fGdyb2Nlcmllc3xlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1549482210-0cbdc7e4a1b4?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nzh8fGdyb2Nlcmllc3xlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1545186182-9faaf78480b8?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NzN8fGdyb2Nlcmllc3xlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1576181456177-2b99ac0aa1ef?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NzF8fGdyb2Nlcmllc3xlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1514792368985-f80e9d482a02?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NjR8fGdyb2Nlcmllc3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1581059474347-833e80d81ba8?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Njh8fGdyb2Nlcmllc3xlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1595275522477-c3ce3ca9714b?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NjB8fGdyb2Nlcmllc3xlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1593047725920-43a0f206b593?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NTh8fGdyb2Nlcmllc3xlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1564941547258-273e19e5d4bf?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NjN8fGdyb2Nlcmllc3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1603189863791-8154cbb04e13?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NTd8fGdyb2Nlcmllc3xlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1580913428735-bd3c269d6a82?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NTl8fGdyb2Nlcmllc3xlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1518735869015-566a18eae4be?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NTJ8fGdyb2Nlcmllc3xlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1598357850625-6264d49ace9f?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NTZ8fGdyb2Nlcmllc3xlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1568983521157-e70347fac5fe?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NTN8fGdyb2Nlcmllc3xlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
  ];

  String getRandomImage() {
    // var num = randomBetween(0, _imgPaths.length - 1);
    return _imgPaths[10];
  }
}
