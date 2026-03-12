
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingButton extends StatefulWidget {
  Function? onPressed;
  bool loading;
  String title;
  bool? disable;
  Color? buttonColor;
  LoadingButton({this.onPressed,this.loading = false,this.title = 'Done',this.disable = false,this.buttonColor = Colors.amber});
  @override
  LoadingButtonState createState() => LoadingButtonState();
}

class LoadingButtonState extends State<LoadingButton> {
 bool isAnimating = true;

 @override
 initState(){
   super.initState();
 }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 20,horizontal:4),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          // ignore: sort_child_properties_last
          child: ElevatedButton(
        style:  ElevatedButton.styleFrom(backgroundColor: widget.buttonColor,elevation: 2,shadowColor: widget.buttonColor,shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10))),
        onPressed: widget.disable! ? null : (){
          if(!widget.loading) widget.onPressed!();
        },
        child: widget.loading ? Container(
            child: const Center(child: CircularProgressIndicator( color: Colors.white,strokeWidth: 3,)),width: 25,height: 25,
          ):Container(
                  width: double.maxFinite,
                  child: Text(
                    widget.title.tr,
                    style: const TextStyle(fontSize: 16, color: Colors.white,fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
        ),height:45,width: Get.width,
      ));
  }
}