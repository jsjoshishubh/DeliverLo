import 'package:flutter/material.dart';

Future<T?> showCommonBottomSheet<T>({
   @required BuildContext? context,
   @required Widget? child,
   bool noViewInsetsPadding = false,
   bool isScrollControlled = true,
   bool isDismissible = true,
   final shape,
   double elevation = 1,
   Color backgroundColor =  Colors.white,
   bool enableDrag = true,
   double maxWidth = 400,
   String type = 'MENU'
 }) {

  getModalWidth(){
    switch(type.toUpperCase()){
      case 'MENU':
        return 350.0;
      case 'LIST':
        return 600.0;
      case 'COMMON':
        return 660.0;
      case 'FORM':
      case 'CREATE':
        return 800.0;
      case 'INPUT':
        return 450.0;
      case 'CUSTOM':
        return maxWidth;
      default:
        return 300.0;
      
    }
  }

   return showModalBottomSheet<T>(
     isDismissible: isDismissible,
     context: context!,
     isScrollControlled: isScrollControlled,
     elevation: elevation,
     backgroundColor: backgroundColor,
     enableDrag: enableDrag,
     constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top),
     shape: shape != null ? shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(
              top: const Radius.circular(30),
            )),
     builder: (BuildContext context) {
       return  Container(child: child, 
       padding: noViewInsetsPadding == true ? EdgeInsets.zero : EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,)
        );
     },
   );
 }

 Future showCommonDraggableScrollableBottomSheet<T>({
   @required BuildContext? context,
   @required Widget? child,
   double initialChildSize = 0.88,
   double maxChildSize = 0.88,
   bool expand = true,
 }){
  return showCommonBottomSheet(context: context, child: DraggableScrollableSheet(
        initialChildSize: initialChildSize,
        expand: expand,
        maxChildSize: maxChildSize,
        builder: (BuildContext context, ScrollController scrollController){
          return child!;
        }));
 }