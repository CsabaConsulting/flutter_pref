import 'package:flutter/material.dart';
import 'package:preferences/preference_service.dart';

class CheckboxPreference extends StatefulWidget {
  final String title;
  final String desc;
  final String localKey;
  final bool defaultVal;
  final bool ignoreTileTap;

  final bool resetOnException;

  final Function onEnable;
  final Function onDisable;
  final Function onChange;

  CheckboxPreference(this.title, this.localKey,
      {this.desc,
      this.defaultVal = false,
      this.ignoreTileTap = false,
      this.resetOnException = true,
      this.onEnable,
      this.onDisable,
      this.onChange});

  _CheckboxPreferenceState createState() => _CheckboxPreferenceState();
}

class _CheckboxPreferenceState extends State<CheckboxPreference> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      subtitle: widget.desc == null ? null : Text(widget.desc),
      trailing: Checkbox(
        value: PrefService.getBool(widget.localKey) ?? widget.defaultVal,
        onChanged: (val) => val ? onEnable() : onDisable(),
      ),
      onTap: widget.ignoreTileTap
          ? null
          : () => (PrefService.getBool(widget.localKey) ?? widget.defaultVal)
              ? onDisable()
              : onEnable(),
    );
  }

  onEnable() async {
    setState(() => PrefService.setBool(widget.localKey, true));
    if (widget.onChange != null) widget.onChange();
    if (widget.onEnable != null)
      try {
        await widget.onEnable();
      } catch (e) {
        if (widget.resetOnException)
          setState(() => PrefService.setBool(widget.localKey, false));
        PrefService.showError(context, e.message);
      }
  }

  onDisable() async {
    setState(() => PrefService.setBool(widget.localKey, false));
    if (widget.onChange != null) widget.onChange();
    if (widget.onDisable != null)
      try {
        await widget.onDisable();
      } catch (e) {
        if (widget.resetOnException)
          setState(() => PrefService.setBool(widget.localKey, true));
        PrefService.showError(context, e.message);
      }
  }
}
