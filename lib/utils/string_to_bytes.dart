import 'dart:typed_data';

class StringToBytes {
  static Uint8List transform(String text) {
    final sb = StringBuffer();
    sb.write(_toHexString(_fromHexString(text)));
    sb.write(' ');
    sb.write(_toHexString('\r\n'.codeUnits));
    final msg = sb.toString();
    final data = _fromHexString(msg);
    return Uint8List.fromList(data);
  }

  static List<int> _fromHexString(String s) {
    final result = <int>[];
    int b = 0;
    int nibble = 0;

    for (int i = 0; i < s.length; i++) {
      final c = s.codeUnitAt(i);
      int? value;

      if (c >= '0'.codeUnitAt(0) && c <= '9'.codeUnitAt(0)) {
        value = c - '0'.codeUnitAt(0);
      } else if (c >= 'A'.codeUnitAt(0) && c <= 'F'.codeUnitAt(0)) {
        value = c - 'A'.codeUnitAt(0) + 10;
      } else if (c >= 'a'.codeUnitAt(0) && c <= 'f'.codeUnitAt(0)) {
        value = c - 'a'.codeUnitAt(0) + 10;
      }

      if (value != null) {
        b = b * 16 + value;
        nibble++;
        if (nibble == 2) {
          result.add(b);
          b = 0;
          nibble = 0;
        }
      }
    }

    if (nibble > 0) {
      result.add(b);
    }

    return result;
  }

  static String _toHexString(List<int> bytes, {int begin = 0, int? end}) {
    final sb = StringBuffer();
    end ??= bytes.length;
    for (int pos = begin; pos < end; pos++) {
      if (sb.length > 0) sb.write(' ');
      int value = bytes[pos] & 0xff;
      int high = value ~/ 16;
      int low = value % 16;

      sb.writeCharCode(
        high >= 10
            ? ('A'.codeUnitAt(0) + high - 10)
            : ('0'.codeUnitAt(0) + high),
      );
      sb.writeCharCode(
        low >= 10 ? ('A'.codeUnitAt(0) + low - 10) : ('0'.codeUnitAt(0) + low),
      );
    }
    return sb.toString();
  }
}
