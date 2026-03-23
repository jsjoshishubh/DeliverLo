import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class HomePageCatagoryComponent extends StatefulWidget {
  final List<Map<String, String>>? categories;

  const HomePageCatagoryComponent({super.key, this.categories});

  @override
  State<HomePageCatagoryComponent> createState() => HomePage_CatagoryComponentState();
}

class HomePage_CatagoryComponentState extends State<HomePageCatagoryComponent> {

  final List<Map<String, String>> _defaultCategories = [
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
      margin: EdgeInsets.only(left: 15,right: 20,top: 18),
      child: Builder(builder: (context) {
        final categories = (widget.categories != null && widget.categories!.isNotEmpty)
            ? widget.categories!
            : _defaultCategories;
        return ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index){
            final item  = categories[index];
            final image = item["image"] ?? 'Assets/Extras/ct_1.png';
            return Padding(
              padding: const EdgeInsets.symmetric(vertical:5.0,horizontal: 5),
              child: Column(
                children: [
                  InkWell(
                    onTap: (){
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    child: Container(
                      width: 70,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(image,scale: 4,),
                          SizedBox(height: 8,),
                          Text(
                            item['title'] ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: commonTextStyle(fontWeight: FontWeight.w500,fontSize: 12,fontColor: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if( currentIndex == index)...[
                    SizedBox(height: 8,),
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
        );
      }),
    );
  }
}