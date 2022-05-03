import 'package:flutter/material.dart';
import 'package:appwrite_incidence_supervisor/presentation/resources/values_manager.dart';

class TextFormWidget extends StatelessWidget {
  final TextEditingController _textEditingController;
  final String _hintText;
  final String _labelText;
  final String? _error;
  final bool obscureText;
  final String? assetPre;
  final String? assetSuf;

  const TextFormWidget(
      this._textEditingController, this._hintText, this._labelText, this._error,
      {Key? key, this.obscureText = false, this.assetPre, this.assetSuf})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      controller: _textEditingController,
      decoration: InputDecoration(
          prefixIcon: assetPre != null
              ? Padding(
                  padding: const EdgeInsets.all(AppPadding.p12),
                  child: ImageIcon(
                    AssetImage(assetPre!),
                    size: AppSize.s10,
                  ),
                )
              : null,
          suffixIcon: assetSuf != null
              ? ImageIcon(
                  AssetImage(assetSuf!),
                  size: AppSize.s10,
                )
              : null,
          hintText: _hintText,
          labelText: _labelText,
          errorText: _error),
    );
  }
}
