/// IconPicker
/// Author Rebar Ahmad
/// https://github.com/Ahmadre
/// rebar.ahmad@gmail.com

import 'package:flutter/material.dart';
import 'icons.dart';
import 'searchBar.dart';
import '../Models/IconPack.dart';
import '../Helpers/ColorBrightness.dart';

class IconPicker extends StatefulWidget {
  final List<IconPack>? iconPack;
  final Map<String, IconData>? customIconPack;
  final double? iconSize;
  final Color? iconColor;
  final String? noResultsText;
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;
  final Color? backgroundColor;
  final bool? showTooltips;

  static late Function reload;
  static Map<String, IconData> iconMap = {};

  const IconPicker({
    Key? key,
    required this.iconPack,
    required this.iconSize,
    required this.noResultsText,
    required this.backgroundColor,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.iconColor,
    this.showTooltips,
    this.customIconPack,
  }) : super(key: key);

  @override
  _IconPickerState createState() => _IconPickerState();
}

class _IconPickerState extends State<IconPicker> {
  @override
  void initState() {
    super.initState();
    if (widget.customIconPack != null)
      IconPicker.iconMap.addAll(widget.customIconPack ?? {});

    if (widget.iconPack != null)
      for (var pack in widget.iconPack!) {
        IconPicker.iconMap.addAll(IconManager.getSelectedPack(pack));
      }
    IconPicker.reload = reload;
  }

  reload() {
    setState(() {});
  }

  Widget _getListEmptyMsg() => Container(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: RichText(
            text: TextSpan(
              text: widget.noResultsText! + ' ',
              style: TextStyle(
                color: ColorBrightness(widget.backgroundColor!).isLight()
                    ? Colors.black
                    : Colors.white,
              ),
              children: [
                TextSpan(
                  text: SearchBar.searchTextController.text,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ColorBrightness(widget.backgroundColor!).isLight()
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Stack(
        children: <Widget>[
          if (IconPicker.iconMap.length == 0)
            _getListEmptyMsg()
          else
            Positioned.fill(
              child: GridView.builder(
                  itemCount: IconPicker.iconMap.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    childAspectRatio: 1 / 1,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    maxCrossAxisExtent:
                        widget.iconSize != null ? widget.iconSize! + 10 : 50,
                  ),
                  itemBuilder: (context, index) {
                    var item = IconPicker.iconMap.entries.elementAt(index);

                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context, item.value),
                        child: widget.showTooltips!
                            ? Tooltip(
                                message: item.key,
                                child: Icon(
                                  item.value,
                                  size: widget.iconSize,
                                  color: widget.iconColor,
                                ),
                              )
                            : Icon(
                                item.value,
                                size: widget.iconSize,
                                color: widget.iconColor,
                              ),
                      ),
                    );
                  }),
            ),
        ],
      ),
    );
  }
}
