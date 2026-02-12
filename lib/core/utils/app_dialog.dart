import 'package:flutter/material.dart';

class AppDialog {
  static void showLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black54, 
    builder: (_) => const _LoadingDialog(),
  );
}


  static void hideLoading(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  static void showError({
    required BuildContext context,
    required String message,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _ErrorDialog(message: message),
    );
  }
}

class _LoadingDialog extends StatelessWidget {
  const _LoadingDialog();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Color(0xffFFFFFF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: Color(0xff5F33E1),
          ),
        ),
      ),
    );
  }
}

class _ErrorDialog extends StatelessWidget {
  final String message;

  const _ErrorDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 40),
              const SizedBox(height: 12),
              Text(message),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); 
                  },
                  child: const Text("OK"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
