import 'package:flutter/material.dart';

class LiveViewLoading extends StatelessWidget {
  const LiveViewLoading({
    super.key,
    this.onLeave,
  });

  final VoidCallback? onLeave;

  @override
  Widget build(BuildContext context) {
    // FIXME: textos
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircularProgressIndicator.adaptive(),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: onLeave,
          child: Text('Cancelar'),
        ),
      ],
    );
  }
}
