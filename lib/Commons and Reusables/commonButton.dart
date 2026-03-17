
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingButton extends StatefulWidget {
  Function? onPressed;
  bool loading;
  String title;
  bool? disable;
  Color? buttonColor;
  Widget? icon;
  BorderRadiusGeometry? borderRadius;
  double? height;
  Color? titleColor;
  LoadingButton({
    this.onPressed,
    this.loading = false,
    this.title = 'Done',
    this.disable = false,
    this.buttonColor = Colors.amber,
    this.icon,
    this.borderRadius,
    this.height,
    this.titleColor,
  });
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
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal:4),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          // ignore: sort_child_properties_last
          child: ElevatedButton(
        style:  ElevatedButton.styleFrom(
            backgroundColor: widget.buttonColor,
            elevation: 2,
            shadowColor: widget.buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
            )),
        onPressed: widget.disable! ? null : (){
          if(!widget.loading) widget.onPressed!();
        },
        child: widget.loading ? Container(
            child: const Center(child: CircularProgressIndicator( color: Colors.white,strokeWidth: 3,)),width: 25,height: 25,
          ):Container(
                  width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.title.tr,
                        style: TextStyle(fontSize: 18, color: widget.titleColor ?? Colors.white,fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                      if (widget.icon != null) ...[
                        const SizedBox(width: 8),
                        widget.icon!,
                      ]
                    ],
                  ),
                ),
        ),height: widget.height ?? 45,width: Get.width,
      ));
  }
}