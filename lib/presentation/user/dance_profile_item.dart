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
  static RangeValues DEFAULT_RANGE_VALUES = RangeValues(Range.MIN_FROM.toDouble(), Range.MAX_TO.toDouble());
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
    RangeValues _currentRangeValues = DEFAULT_RANGE_VALUES;
    if (danceProfile.range != null)
      _currentRangeValues = RangeValues(danceProfile.range.from.toDouble(), danceProfile.range.to.toDouble());

    double _level = danceProfile.level == null ? 5.0 : danceProfile.level.toDouble();

    String _danceCode = danceProfile.danceCode;

    return _DanceProfileItemState(_danceCode, _level, _currentRangeValues);
  }
}

  /// This is the private State class that goes with MyStatefulWidget.
  class _DanceProfileItemState extends State<DanceProfileItem> {

  _DanceProfileItemState(this._danceCode, this._level, this._currentRangeValues) : super();

  @override
  void initState() {
    super.initState();
  }

  String _danceCode;
  RangeValues _currentRangeValues;
  double _level;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;



    // if (menuItemsMap[danceProfile.danceCode] == null) {
    //   _danceCode = NO_DANCE_CODE;
    // }



    return Dismissible(
      key: ArchSampleKeys.danceProfileItem(widget.danceProfile.id),
      onDismissed: widget.onDismissed,
      child: ListTile(
        onTap: widget.onTap,
          title:
        DropdownButton<String>(
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
        //   leading:
        // Hero(
        //   tag: '${danceProfile.id}__heroTag',
        //   child: Container(
        //     width: 20,//MediaQuery.of(context).size.width,
        //     child: Text(
        //       'test', //todo.task,
        //       key: ArchSampleKeys.danceProfileItemTask(danceProfile.id),
        //       style: Theme.of(context).textTheme.headline6,
        //     ),
        //   ),
        // ),
        subtitle:
        Column(
            children: <Widget>[
              SliderTheme(
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
                    widget.onLevelChanged(value);
                  },
                ),
              ),
          SliderTheme(
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
        )
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

