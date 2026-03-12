import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show TextInputFormatter;

class TextFormFieldWidget extends StatefulWidget {
  final TextInputType textInputType;
  final String? labelText;
  final bool requiredPadding;
  final Function? validator;
  final Function? onSaved;
  final Function? onSubmitted;
  final suffixIcon;
  final prefixIcon;
  dynamic? initialValue;
  TextEditingController? controller;
  Function? onChanged;
  Function? onBlur;
  bool enabled;
  bool autofocus;
  TextInputAction textInputAction;
  int maxLines;
  int minLines;
  final List<TextInputFormatter>? inputFormatters;
  String? textFieldTitle;
  String? textFIeldHint;

  TextFormFieldWidget({
    Key? key,
    this.textInputType = TextInputType.text,
    @required this.labelText,
    this.requiredPadding = false,
    this.validator,
    this.suffixIcon = null,
    this.onSaved,
    this.initialValue = null,
    this.prefixIcon = null,
    this.enabled = true,
    this.controller,
    this.onChanged,
    this.autofocus = false,
    this.onBlur,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted = null,
    this.minLines = 1,
    this.maxLines = 1,
    this.inputFormatters,
    this.textFIeldHint,
    this.textFieldTitle
  }) : super(key: key);

  @override
  _TextFormFieldWidgetState createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  final textFieldController = TextEditingController();

  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    textFieldController.text =
        widget.initialValue != null ? widget.initialValue.toString() : '';
    _focusNode.addListener(() {
      if (_focusNode.hasFocus == false) {
        if (widget.onBlur != null) widget.onBlur!(textFieldController.text);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.textFieldTitle == null ? SizedBox() :  Text('${widget.textFieldTitle.toString()}',style: commonTextStyle(fontType: 'H4',fontWeight: FontWeight.w700),),
        SizedBox(height: 5,),
        Container(
          child: TextFormField(
            focusNode: _focusNode,
            controller: widget.controller != null ? widget.controller : textFieldController,
            keyboardType: widget.textInputType,
            autocorrect: false,
            autofocus: widget.autofocus,
            enabled: widget.enabled,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            inputFormatters: widget.inputFormatters ?? [],
            cursorColor: Colors.black,
            cursorWidth: 2,
            // initialValue: widget.initialValue != null ? widget.initialValue.toString():null,
            decoration: InputDecoration(
              isDense: false,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              prefixIcon: widget.prefixIcon != null ? widget.prefixIcon : null,
              suffixIcon: widget.suffixIcon != null ? widget.suffixIcon : null,
              contentPadding: EdgeInsets.fromLTRB(12.0, 23.0, 20.0, 13.0),
              hintText: widget.labelText,
              filled: true,
              fillColor: Colors.grey.shade50,
              hintStyle: TextStyle(fontSize: 14,color: Colors.grey),
              errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1),borderRadius: BorderRadius.circular(18.0),),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300, width: 1),borderRadius: BorderRadius.circular(18.0),),
              border: OutlineInputBorder(borderSide: BorderSide(color: HexColor.fromHex('#D9D9D9')!, width: 1,),borderRadius: BorderRadius.circular(18.0),),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: HexColor.fromHex('#D9D9D9')!,width: 1,),borderRadius: BorderRadius.circular(18.0),),
            ),
            textInputAction: widget.textInputAction,
            onFieldSubmitted: (v) => widget.onSubmitted != null ? widget.onSubmitted!(v) : null,
            onSaved: (value) => widget.onSaved != null ? widget.onSaved!(value) : null,
            onChanged: (value) => widget.onChanged != null ? widget.onChanged!(value) : null,
            validator: (value) => widget.validator != null ? widget.validator!(value) : null,
          ),
        ),
        SizedBox(height: 7,),
        widget.textFIeldHint == null ? SizedBox() : Text('Hint',style: commonTextStyle(fontType: 'H4',fontWeight: FontWeight.w700),),
      ],
    );
  }
}
