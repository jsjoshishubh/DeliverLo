import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:deliverylo/Views/Food%20Main%20Home/Search_Deligate_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class HomePageAddressAndSearchAndProfileComponenet extends StatefulWidget {
  final VoidCallback? onAddressTap;
  final VoidCallback? onSearchTap;
  final ValueChanged<bool>? onVegModeChanged;
  final String deliveryTime;
  final String distance;
  final String addressLabel;
  final String searchPlaceholder;
  final bool vegMode;
  final bool showVegMode;

  const HomePageAddressAndSearchAndProfileComponenet({
    super.key,
    this.onAddressTap,
    this.onSearchTap,
    this.onVegModeChanged,
    this.deliveryTime = '10 minutes',
    this.distance = '1.2 km',
    this.addressLabel = '',
    this.searchPlaceholder = "Search 'Biryani'",  
    this.vegMode = true,
    this.showVegMode = true,
  });


  @override
  State<HomePageAddressAndSearchAndProfileComponenet> createState() => _HomePageAddressAndSearchAndProfileComponenetState();
}

class _HomePageAddressAndSearchAndProfileComponenetState extends State<HomePageAddressAndSearchAndProfileComponenet> {
  late bool _vegMode;

  @override
  void initState() {
    super.initState();
    _vegMode = widget.vegMode;
  }

  @override
  void didUpdateWidget(covariant HomePageAddressAndSearchAndProfileComponenet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.vegMode != widget.vegMode) {
      _vegMode = widget.vegMode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 55,left: 20,right: 20),
      child: Column(
        children: [
          InkWell(
            onTap: () => widget.onAddressTap?.call(),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //  Row(
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   children: [
                        //     Text('10 minutes',style: commonTextStyle(fontSize:18,fontWeight: FontWeight.w700,fontColor: Colors.white),),
                        //     SizedBox(width: 10,),
                        //     _DistanceBadge(distance: widget.distance,),
                        //   ],
                        // ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(widget.addressLabel.toString().split('-').first,style:  commonTextStyle(fontSize:18,fontWeight: FontWeight.w700,fontColor: Colors.white),),
                            Icon(Icons.arrow_drop_down_rounded,color: Colors.white,size: 25,)
                          ],
                        ),
                        SizedBox(height: 5,),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.78,
                          child: Text(
                            widget.addressLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: commonTextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            
            ),
          ),
          InkWell(
            onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SearchDeligatePage(searchQuery: '',))),
            child: Container(
              margin: EdgeInsets.only(top: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                    margin: EdgeInsets.only(top: 3),
                    padding: EdgeInsets.symmetric(vertical:11),
                    decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(220)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 15,),
                            Icon(Icons.search,color: greyFontColor.withValues(alpha: 0.8),),
                            SizedBox(width: 10,),
                            Text(widget.searchPlaceholder,style: commonTextStyle(fontColor:greyFontColor.withValues(alpha: 0.4),fontSize: 16, fontWeight: FontWeight.w400),),
                          ],
                        ),
                        SizedBox(width: 20,),
                        Padding(
                          padding: const EdgeInsets.only(right:16.0),
                          child: Icon(Icons.mic,color:greyFontColor.withValues(alpha: 0.8),),
                        ),
                      ],
                    ),
                  ),),
                  if (widget.showVegMode) ...[
                    SizedBox(width: 20),
                    _VegModeToggle(onChanged: (value) {
                      setState(() {
                        _vegMode = value;
                      });
                    },
                    value: _vegMode,
                    
                    ),
                  ],
                ],
              ),
            ),
          )
         
        ],
      ),
    );
  }
}

class _DistanceBadge extends StatelessWidget {
  const _DistanceBadge({required this.distance});

  final String distance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 5, top: 3,bottom: 3,right: 10),
      decoration: BoxDecoration(
        color: HexColor.fromHex('#FFFFFF').withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.bolt, color: Colors.white, size: 14),
          Text(
            distance,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Figma: lighter red circle #F05050 with white person silhouette
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color:HexColor.fromHex('#FFFFFF').withValues(alpha: 0.3),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.person,
        color: Colors.white,
        size: 24,
      ),
    );
  }
}

class _VegModeToggle extends StatelessWidget {
  const _VegModeToggle({
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Veg Mode', style: commonTextStyle(fontColor: Colors.white,fontSize: 12,fontWeight: FontWeight.w600,),),
        SizedBox(height: 8),
        FlutterSwitch(
          width: 50.0,
          height: 21.0,
          toggleSize:16.0,
          value: value,
          borderRadius: 30.0,
          padding: 2.0,
          activeColor: HexColor.fromHex('#FFFFFF'),
          activeToggleColor: HexColor.fromHex('#009E4F'),
          inactiveColor: Colors.white,
          inactiveToggleColor: HexColor.fromHex('#BD0D0E'),
          onToggle: (val) {
            onChanged(val);
          },
        ),
      ],
    );
  }
}