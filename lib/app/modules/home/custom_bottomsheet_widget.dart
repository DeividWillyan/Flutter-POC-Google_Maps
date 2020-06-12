import 'package:flutter/material.dart';

import 'package:poc_maps/app/utils/custom_bottom_sheet.dart' as custom_bs;
import 'package:flutter_modular/flutter_modular.dart';

class CustomBottomSheetWidget {
  static Future<T> showBottom<T>({
    @required Widget title,
    @required Widget content,
  }) {
    assert(content != null, 'Content is required');
    assert(title != null, 'Title is required');
    return custom_bs.showModalBottomSheet<T>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20.0),
                  topRight: const Radius.circular(20.0),
                ),
              ),
              child: Wrap(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 26),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: title),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Theme.of(context).primaryColor,
                            size: 28,
                          ),
                          onPressed: () => Modular.to.pop(),
                        )
                      ],
                    ),
                  ),
                  content
                ],
              ),
            ),
          ),
        );
      },
      isScrollControlled: true,
    );
  }
}
