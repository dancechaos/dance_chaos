// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:dance_chaos/app/core/keys.dart';
import 'package:dance_chaos/models/dance_profile.dart';
import 'package:dance_chaos/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dance_chaos/app/entity/utility.dart';

class DanceProfileItem extends StatefulWidget {
  static const String NO_DANCE_CODE = '';

  final DismissDirectionCallback onDismissed;
  final GestureTapCallback onTap;
  final ValueChanged<String> onDropdownChanged;
  final ValueChanged<RangeValues> onRangeChanged;
  final ValueChanged<double> onLevelChanged;
  final Profile profile;
  final DanceProfile danceProfile;
  final Map<dynamic, dynamic> menuItemsMap;

  DanceProfileItem({
    Key key,
    @required this.onDismissed,
    @required this.onTap,
    @required this.onDropdownChanged,
    @required this.onLevelChanged,
    @required this.onRangeChanged,
    @required this.profile,
    @required this.danceProfile,
    @required this.menuItemsMap,
  }) : super(key: key);

  @override
  _DanceProfileItemState createState() {
    return _DanceProfileItemState();
  }

}

  /// This is the private State class that goes with MyStatefulWidget.
  class _DanceProfileItemState extends State<DanceProfileItem> {

  String _danceCode;
  RangeValues _currentRangeValues;
  double _level;

  static RangeValues DEFAULT_RANGE_VALUES = RangeValues(Range.MIN_FROM.toDouble(), Range.MAX_TO.toDouble());

  _DanceProfileItemState() : super();

  @override
  void initState() {
    super.initState();

    _currentRangeValues = DEFAULT_RANGE_VALUES;
    if (widget.danceProfile.range != null)
      _currentRangeValues = RangeValues(widget.danceProfile.range.from.toDouble(), widget.danceProfile.range.to.toDouble());

    _level = widget.danceProfile.level == null ? 5.0 : widget.danceProfile.level.toDouble();

    _danceCode = widget.danceProfile.danceCode;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Dismissible(
      key: ArchSampleKeys.danceProfileItem(widget.danceProfile.id),
      onDismissed: widget.onDismissed,
      child: ListTile(
          key: ArchSampleKeys.danceProfileTile(widget.danceProfile.id),
          onTap: widget.onTap,
//           leading:
//           Container(
//             width: 40,//MediaQuery.of(context).size.width,
// //            height: 90,
//             child: Column(
//               children: <Widget>[
//                 Container(
//                   width: 40,
//                   height: 29,
//                   child: Text(
//                     'Level: $_level',
//                     key: ArchSampleKeys.danceProfileLevelText(widget.danceProfile.id),
//                     style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.redAccent),
//                   ),
//                 ),
//                 Container(
//                   width: 40,
//                   height: 28,
//                   child:                 Text(
//                     'Range: from ${_currentRangeValues.start}, to: ${_currentRangeValues.end}',
//                     key: ArchSampleKeys.danceProfileRangeText(widget.danceProfile.id),
//                     style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.blueAccent),
//                   ),
//                 ),
//               ],
//             ),
//           ),
      title:
        DropdownButton<String>(
          key: ArchSampleKeys.danceProfileDropdown(widget.danceProfile.id),
          value: widget.menuItemsMap[_danceCode] == null ? '' : _danceCode,
          icon: Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: textTheme.headline5,
          underline: Container(
            height: 2,
            color: textTheme.headline5.decorationColor,
          ),
          onChanged: (value) {
            setState(() {
              _danceCode = value;
            });
            widget.onDropdownChanged(value);
          },
          items: dropdownMenuItems(),
        ),
        subtitle:
        Column(
          key: ArchSampleKeys.danceProfileColumn(widget.danceProfile.id),
            children: <Widget>[
              SliderTheme(
                key: ArchSampleKeys.danceProfileLevelTheme(widget.danceProfile.id),
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.red,
                  inactiveTrackColor: Colors.red,
                  // trackShape: RectangularSliderTrackShape(),
                  // trackHeight: 0.0,
                  thumbColor: Colors.redAccent,
                  // thumbShape: MyThumbShape(),
                  activeTickMarkColor: Colors.transparent,
                  inactiveTickMarkColor: Colors.transparent,
                  valueIndicatorTextStyle: Theme.of(context).textTheme.subtitle1,
                  // overlayColor: Colors.red.withAlpha(32),
                  // overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                ),
                child: Slider(
                  key: ArchSampleKeys.danceProfileLevel(widget.danceProfile.id),
                  value: _level,
                  min: Range.MIN_FROM.toDouble(),
                  max: Range.MAX_TO.toDouble(),
                  divisions: Range.MAX_TO - Range.MIN_FROM,
                  label: _level.round().toString(),
                  // onChanged: widget.onRangeChanged,
                  onChanged: (double value) {
                    setState(() {
                      _level = value;
                    });
                  },
                  onChangeEnd: (double value) {
                    widget.onLevelChanged(value);
                  },
                ),
              ),
          SliderTheme(
            key: ArchSampleKeys.danceProfileRangeTheme(widget.danceProfile.id),
                data: SliderTheme.of(context).copyWith(
                  // activeTrackColor: Colors.transparent,
                  // inactiveTrackColor: Colors.transparent,
                  // trackShape: RectangularSliderTrackShape(),
                  // trackHeight: 4.0,
                  thumbColor: Colors.blueAccent,
                  thumbShape: RoundSliderThumbShape(),
                  // activeTickMarkColor: Colors.transparent,
                  // inactiveTickMarkColor: Colors.transparent,
                  // overlayColor: Colors.red.withAlpha(32),
                  // overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                ),
                child: RangeSlider(
                  key: ArchSampleKeys.danceProfileRange(widget.danceProfile.id),
                  values: _currentRangeValues,
                  min: Range.MIN_FROM.toDouble(),
                  max: Range.MAX_TO.toDouble(),
                  divisions: Range.MAX_TO - Range.MIN_FROM,
                  labels: RangeLabels(
                    _currentRangeValues.start.round().toString(),
                    _currentRangeValues.end.round().toString(),
                  ),
                  // onChanged: widget.onRangeChanged,
                  onChanged: (RangeValues values) {
                    setState(() {
                      _currentRangeValues = values;
                    });
                  },
                  onChangeEnd:  (RangeValues values) {
                    widget.onRangeChanged(values);
                  },
                ),
              ),
              const Divider(
                color: Colors.black,
                height: 20,
                thickness: 5,
                indent: 20,
                endIndent: 0,
              ),
             ]
        ),
        trailing: Container(
          width: 20,//MediaQuery.of(context).size.width,
          child: IconButton(
            key: ArchSampleKeys.danceProfileDeleteButton(widget.danceProfile.id),
            icon: Icon(Icons.delete),
            onPressed: () {
              widget.onDismissed(DismissDirection.horizontal);
            },
          ),
        ),
        // Text(
        //   'test', //todo.note,
        //   key: ArchSampleKeys.danceProfileItemNote(danceProfile.id),
        //   maxLines: 1,
        //   overflow: TextOverflow.ellipsis,
        //   style: Theme.of(context).textTheme.subtitle1,
        // ),
      ),
    );
  }

  List<DropdownMenuItem<String>> dropdownMenuItems() {
    List<DropdownMenuItem<String>> dropdownMenuItems = List.empty(growable: true);
    widget.menuItemsMap.forEach((key, value) {
      dropdownMenuItems.add(DropdownMenuItem(
        value: key,
        child: Text(value)
      ));
    });
    return dropdownMenuItems;
  }

}

