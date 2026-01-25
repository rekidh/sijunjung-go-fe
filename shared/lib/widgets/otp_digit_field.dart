import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpDigitField extends StatefulWidget {
  final int length;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;

  const OtpDigitField({
    super.key,
    this.length = 4,
    this.onChanged,
    this.onCompleted,
  });

  @override
  State<OtpDigitField> createState() => _OtpDigitFieldState();
}

class _OtpDigitFieldState extends State<OtpDigitField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (index) => TextEditingController());
    _focusNodes = List.generate(widget.length, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    // Combine all text
    String code = _controllers.map((c) => c.text).join();
    if (widget.onChanged != null) {
      widget.onChanged!(code);
    }

    if (value.isNotEmpty) {
      // Move to next field if not last
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Last field filled
        _focusNodes[index].unfocus();
        if (widget.onCompleted != null) {
          widget.onCompleted!(code);
        }
      }
    } else {
      // Move to previous field if empty (and backspacing handled mostly by keyboard logic, 
      // but standard onChanged with empty string usually implies deletion)
       if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (index) {
        return Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(
              color: _focusNodes[index].hasFocus ? const Color(0xFF55B6E7) : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'SofiaPro',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF55B6E7),
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              counterText: '', // Hide counter
            ),
            onChanged: (value) => _onChanged(value, index),
          ),
        );
      }),
    );
  }
}
