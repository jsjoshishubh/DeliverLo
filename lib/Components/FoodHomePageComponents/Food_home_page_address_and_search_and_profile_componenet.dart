import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
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
      padding: EdgeInsets.only(top: 70,left: 20,right: 20),
      child: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('10 minutes',style: commonTextStyle(fontSize:24,fontWeight: FontWeight.w700,fontColor: Colors.white),),
                          SizedBox(width: 10,),
                          _DistanceBadge(distance: widget.distance,),
                        ],
                      ),
                      InkWell(
                        onTap: () => widget.onAddressTap?.call(),
                        child: Container(
                          padding: EdgeInsets.only(top: 1),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.55,
                                child: Text(
                                  widget.addressLabel,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: commonTextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontColor: Colors.white,
                                  ),
                                ),
                              ),
                              Icon(Icons.arrow_drop_down,color: Colors.white,size: 25,)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:2.0),
                  child: _ProfileIcon(),
                )
              ],
            ),

          ),
          Container(
            margin: EdgeInsets.only(top: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                  margin: EdgeInsets.only(top: 3),
                  padding: EdgeInsets.symmetric(vertical:11),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(220)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 15,),
                          Icon(Icons.search,color: HexColor.fromHex('#9CA3AF'),),
                          SizedBox(width: 15,),
                          Text(widget.searchPlaceholder,style: commonTextStyle(fontColor: HexColor.fromHex('#9CA3AF'),fontSize: 16, fontWeight: FontWeight.w400),),
                        ],
                      ),
                      SizedBox(width: 20,),
                      Padding(
                        padding: const EdgeInsets.only(right:16.0),
                        child: Icon(Icons.mic,color: HexColor.fromHex('#9CA3AF'),),
                      ),
                    ],
                  ),
                ),),
                if (widget.showVegMode) ...[
                  SizedBox(width: 10),
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
        Text(
          'Veg Mode',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
          ),
        ),
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