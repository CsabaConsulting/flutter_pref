// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'service/pref_service.dart';

class PrefRadio<T> extends StatefulWidget {
  const PrefRadio({
    this.title,
    @required this.value,
    @required this.pref,
    Key key,
    this.subtitle,
    this.selected = false,
    this.ignoreTileTap = false,
    this.onSelect,
    this.disabled = false,
    this.leading,
  })  : assert(value != null),
        assert(pref != null),
        super(key: key);

  final Widget title;

  final Widget subtitle;

  final T value;

  final String pref;

  final bool selected;

  final Function onSelect;

  final bool ignoreTileTap;

  final bool disabled;

  final Widget leading;

  @override
  _PrefRadioState createState() => _PrefRadioState<T>();
}

class _PrefRadioState<T> extends State<PrefRadio<T>> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    PrefService.of(context).onNotify(widget.pref, _onNotify);
  }

  @override
  void deactivate() {
    super.deactivate();
    PrefService.of(context).onNotifyRemove(widget.pref, _onNotify);
  }

  void _onNotify() {
    setState(() {});
  }

  void _onChange(T value) {
    PrefService.of(context).set(widget.pref, value);

    if (widget.onSelect != null) {
      widget.onSelect();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: widget.title,
      leading: widget.leading,
      subtitle: widget.subtitle,
      trailing: Radio<T>(
        value: widget.value,
        groupValue: PrefService.of(context).get(widget.pref),
        onChanged: widget.disabled ? null : (T val) => _onChange(widget.value),
      ),
      onTap: (widget.ignoreTileTap || widget.disabled)
          ? null
          : () => _onChange(widget.value),
    );
  }
}
