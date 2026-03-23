import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class HomePageCatagoryComponent extends StatefulWidget {
  const HomePageCatagoryComponent({super.key});

  @override
  State<HomePageCatagoryComponent> createState() => HomePage_CatagoryComponentState();
}

class HomePage_CatagoryComponentState extends State<HomePageCatagoryComponent> {

  List catogerys = [
    {'title': 'All','image':'Assets/Extras/ct_1.png'},
    {'title': 'Cusinies','image':'Assets/Extras/ct_2.png'},
    {'title': 'Healthy','image':'Assets/Extras/ct_3.png'},
    {'title': 'Offers','image':'Assets/Extras/ct_4.png'},
    {'title': 'Cusinies','image':'Assets/Extras/ct_2.png'},
    {'title': 'Offers','image':'Assets/Extras/ct_4.png'},
  ];

  int currentIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      width:Get.width/1,
      margin: EdgeInsets.only(left: 15,right: 20,top: 20),
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: catogerys.length,
        itemBuilder: (context, index){
          final item  = catogerys[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical:5.0,horizontal: 8),
            child: Column(
              children: [
                InkWell(
                  onTap: (){
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  child: Container(
                    width: 50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(item["image"],scale: 4,),
                        SizedBox(height: 8,),
                        Text(item['title'],style: commonTextStyle(fontWeight: FontWeight.w500,fontSize: 12,fontColor: Colors.white),),
                      ],
                    ),
                  ),
                ),
                if( currentIndex == index)...[
                  SizedBox(height: 5,),
                  Container(
                    height: 1,
                    width: 40,
                    color: Colors.white,
                  )
                ]
               
              ],
            ),
          );
        }
      ),
    );
  }
}