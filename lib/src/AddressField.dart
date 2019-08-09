import 'package:flutter/widgets.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';


abstract class AddressFieldBone implements FieldBone<String> {
  String get apiKey;
}


class AddressFieldSkeleton extends FieldSkeleton<String> implements AddressFieldBone {
  final String apiKey;

  AddressFieldSkeleton({
    String value,
    List<FieldValidator<String>> validators,
    @required this.apiKey,
  }): assert (apiKey != null), super(
    value: value,
    validators: validators??[TextFieldValidator.undefined],
  );
}


class AddressFieldShell extends StatefulWidget implements FocusShell {
  final AddressFieldBone bone;

  @override
  final MapFocusBone mapFocusBone;
  @override
  final FocusNode focusNode;

  final FieldErrorTranslator nosy;

  const AddressFieldShell({Key key,
    @required this.bone,
    this.mapFocusBone, this.focusNode,
    this.nosy: byPassNoisy,
  }) :
        assert(bone != null),
        assert(nosy != null), super(key: key);

  @override
  _AddressFieldShellState createState() => _AddressFieldShellState();
}

class _AddressFieldShellState extends State<AddressFieldShell> with FocusShellStateMixin {
  RepositoryBlocBase _repositoryBloc = RepositoryBlocBase.of();
  TextEditingController _controller;

  String _value;

  @override
  void initState() {
    super.initState();
    _value = widget.bone.value;
    _controller = TextEditingController(text: _value);
  }

  @override
  void didUpdateWidget(AddressFieldShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_value != widget.bone.value) {
      _value = widget.bone.value;
      _controller.text = _value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return PlacesAutocompleteFormField(
      //initialValue: _value,
      controller: _controller,
      apiKey: widget.bone.apiKey,
      validator: (address) => widget.nosy(widget.bone.validator(address))?.text,
      onSaved: widget.bone.onSaved,
      language: _repositoryBloc.locale.languageCode,
    );
  }
}
