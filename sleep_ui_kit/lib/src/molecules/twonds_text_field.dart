import 'package:flutter/material.dart';

class TwonDSTextField extends StatefulWidget {
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool isPassword;
  final bool onFocus;

  const TwonDSTextField({
    super.key,
    required this.hint,
    required this.icon,
    required this.controller,
    this.isPassword = false,
    this.onFocus = false
  });

  @override
  State<TwonDSTextField> createState() => _TwonTextFieldState();
}

class _TwonTextFieldState extends State<TwonDSTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      autofocus: widget.onFocus,
      style: TextStyle(color: colorScheme.onSurface),
      decoration: InputDecoration(
        filled: true,
        fillColor: colorScheme.onSurface.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        hintText: widget.hint,
        hintStyle: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.5)),
        prefixIcon: Icon(widget.icon, color: colorScheme.primary),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
    );
  }
}