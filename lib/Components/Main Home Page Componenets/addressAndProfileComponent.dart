import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Routes/app_routes.dart';

class MainHomeAddressAndProfileComponent extends StatefulWidget {
  const MainHomeAddressAndProfileComponent({super.key});

  @override
  State<MainHomeAddressAndProfileComponent> createState() => MainHome_AddressAndProfileComponentState();
}

class MainHome_AddressAndProfileComponentState extends State<MainHomeAddressAndProfileComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFF2E2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.location_on_outlined,
                      color: Color(0xFFE9A14B),
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'DELIVER TO',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF6F7682),
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: const [
                            Text(
                              '123 Maple St, San Francisco',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 22 / 1.6,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF151A2D),
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(0xFF98A1B0),
                              size: 22,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () => Get.toNamed(Routes.PROFILE),
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE9A14B),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}