import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

/// Description section with heading, body text, and expandable "Read more" toggle.
class GroceryDescriptionSection extends StatefulWidget {
  const GroceryDescriptionSection({
    super.key,
    this.title = 'Description',
    this.text,
    this.maxLines = 3,
  });

  final String title;
  final String? text;
  final int maxLines;

  static const String _defaultText =
      'Creamy, buttery, and rich in healthy fats, our organic avocados are hand-picked at peak ripeness. Perfect for guacamole, salads, or spreading on toast. Sourced directly from sustainable farms.';

  @override
  State<GroceryDescriptionSection> createState() =>
      _GroceryDescriptionSectionState();
}

class _GroceryDescriptionSectionState extends State<GroceryDescriptionSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final text = widget.text ?? GroceryDescriptionSection._defaultText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: commonTextStyle(
            fontSize: 18,
            fontColor: blackFontColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.only(right: 38.0),
          child: Text(
            text,
            textAlign: TextAlign.left,
            style: commonTextStyle(
              fontSize: 14,
              fontColor: greyFontColor,
              fontWeight: FontWeight.w400,
            ),
            maxLines: _expanded ? null : widget.maxLines,
            overflow: _expanded ? null : TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _expanded ? 'Read less' : 'Read more',
                style: commonTextStyle(
                  fontSize: 16,
                  fontColor: const Color(0xFF4CAF50),
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                size: 20,
                color: const Color(0xFF4CAF50),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
