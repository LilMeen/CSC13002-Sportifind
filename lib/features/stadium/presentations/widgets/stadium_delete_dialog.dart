import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';

class StadiumDeleteDialog extends StatefulWidget {
  final String content;
  final VoidCallback onDelete;

  const StadiumDeleteDialog({
    super.key,
    required this.content,
    required this.onDelete,
  });

  @override
  State<StadiumDeleteDialog> createState() => _StadiumDeleteDialogState();
}

class _StadiumDeleteDialogState extends State<StadiumDeleteDialog> {
  bool isDeleting = false;

  void _handleDelete() {
    setState(() {
      isDeleting = true;
    });

    widget.onDelete();
    
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: Color.fromARGB(255, 255, 126, 126),
              child: Icon(
                Icons.delete_outline,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Are you sure?",
              style: SportifindTheme.titleDeleteStadium,
            ),
            const SizedBox(height: 16),
            Text(
              widget.content,
              textAlign: TextAlign.center,
              style: SportifindTheme.textDeleteDialog,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 33),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(
                          width: 1,
                          color: Colors.grey,
                        )),
                  ),
                  child: Text("No", style: SportifindTheme.textDeleteDialog),
                ),
                TextButton(
                  onPressed: isDeleting ? null : _handleDelete,
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                    backgroundColor: const Color.fromARGB(255, 255, 126, 126),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: isDeleting
                      ? const SizedBox(
                          width: 25.5,
                          height: 25.5,
                          child: CircularProgressIndicator(
                            backgroundColor: Color.fromARGB(255, 255, 126, 126),
                            color: Colors.white,
                          ),
                        )
                      : Text("Yes", style: SportifindTheme.textDeleteDialog.copyWith(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
