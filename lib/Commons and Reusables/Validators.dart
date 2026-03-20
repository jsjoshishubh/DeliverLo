import 'dart:developer';

import 'package:flutter/material.dart';


Pattern emailRegx = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
Pattern websiteRegx = r'(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})';
Pattern digitRegx = r'^([0-9]*[.])?[0-9]+$';
Pattern formulaFieldRegx = r"field\('([a-zA-z0-9\_\s]+)'\)";
Pattern strongPasswordRegx = r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$";
Pattern upiIdRegex = r"[a-zA-Z0-9.\-_]{2,49}@[a-zA-Z._]{2,16}";

class AppFieldValidator{
  static emptyText(value, label) {
    if (value == null || value.isEmpty) {
      return label.toString();
    }
    return null;
  }

  static formEmptyText(value, label) {
    if (value == null || value.isEmpty) {
      return "Please enter ${label}.";
    }
    return null;
  }
  
  static emailValidation(text) {
    if (text.isEmpty) {
      return 'Please enter email address';
    } else if (text.isNotEmpty) {
      Pattern? pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp? regex = RegExp(pattern.toString());
      if (!regex.hasMatch(text)) {
        return "Please enter valid email address";
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static emailmobileFiledValidation(text) {
    if (text.length == 0) {
      return 'Please enter mobile no. / email address';
    } else {
      if (text.contains(new RegExp(r'[a-zA-Z]'))) {
        return emailValidation(text);
      } else if (!text.contains(new RegExp(r'[a-zA-Z]'))) {
        if (text.length < 10 || text.length > 10) {
          return 'Please enter valid mobile no.';
        } else {
          return null;
        }
      }
      return null;
    }
  }

  static loginPasswordValidation(text) {
    if (text.isEmpty) {
      return 'Please enter password';
    } else {
      return null;
    }
  }

  static passwordValidation(text,{newPass}) {
    RegExp regex = new RegExp(strongPasswordRegx.toString());
    if (text.isEmpty) {
      return newPass ? 'Please enter new password' : 'Please enter password';
    } else if (!regex.hasMatch(text)) {
      return 'Please enter strong password.';
    } else {
      return null;
    }
  }
  static emptyArrayValidation(v,label){
   if(v == null || (v != null && v.length == 0)){
     return 'Please select ${label}.';
   }
   return null;
 }

  static confirmpasswordValidation(confirmpassword, password) {
    print('pass --- ${password}');
     RegExp regex = new RegExp(strongPasswordRegx.toString());
    if (confirmpassword.isEmpty) {
      return 'Please enter confirm password';
    }else if (!regex.hasMatch(confirmpassword)) {
      return 'Please enter strong password';
    } else if (password != confirmpassword) {
      return "Confirm password is not same";
    } else {
      return null;
    }
  }

  static phoneValidation(text) {
    if (text.isEmpty) {
      return 'Please enter mobile no.';
    } else if (text.contains(new RegExp(r'[a-zA-Z]')) ||
        text.length < 10 ||
        text.length > 10) {
      return 'Please enter valid mobile no.';
    } else {
      return null;
    }
  }

 static emptyEditText(text){
   if (text.isEmpty) {
     return false;
   }

   else {
     return true;
   }
 }

static ifscCode(v){
    if(v.isEmpty || v == null){
      return 'please enter ifsc code';
    }else if(v.isNotEmpty){
   RegExp regex = new RegExp(r'^[A-Za-z]{4}[a-zA-Z0-9]{7}$');
   if(!regex.hasMatch(v.toString().toUpperCase())){
    return 'Please enter valid ifsc code';
   }else {
    return null;
   }
   }else{
    return null;
   }
  }
static upiId(v){
    if(v.isEmpty || v == null){
      return 'please enter upi id';
    }else if(v.isNotEmpty){
   RegExp regex = new RegExp(r"[a-zA-Z0-9.\-_]{2,49}@[a-zA-Z._]{2,16}");
   if(!regex.hasMatch(v.toString().toUpperCase())){
    return 'Please enter valid upi id';
   }else {
    return null;
   }
   }else{
    return null;
   }
  }

static panNumber(v){
    if(v.isEmpty || v == null){
      return 'please enter pan number';
    }else if(v.isNotEmpty){
   RegExp regex = new RegExp(r'([A-Z]){5}([0-9]){4}([A-Z]){1}?$');
   RegExp caps =  RegExp(r'[A-Z]{2}');
   if(!regex.hasMatch(v.toString().toUpperCase())){
      if(!caps.hasMatch(v.toString())){
      return 'All charectors should be in capital';
    }
    return 'Please enter valid pan number';
   }else {
    return null;
   }
   }else{
    return null;
   }
  }

  static numberValidation(text, label) {
    if (text.isEmpty) {
      return  'Please enter ${label}. (Only Numbers)';
    } else {
      RegExp regex =  RegExp(digitRegx.toString());
      if (!regex.hasMatch(text)) {
        return  'please enter valid ${label}.';
      } else {
        return null;
      }
    }
  }
}

