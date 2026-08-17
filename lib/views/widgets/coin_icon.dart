import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CoinIcon extends StatelessWidget {
  const CoinIcon({
    required this.iconUrl,
    required this.symbol,
    this.size = 40,
    super.key,
  });

  final String iconUrl;
  final String symbol;
  final double size;

  @override
  Widget build(BuildContext context) {
    final iconSize = size.w;
    final url = iconUrl.trim();

    if (url.isEmpty) {
      return _buildFallback(iconSize);
    }

    return SizedBox(
      width: iconSize,
      height: iconSize,
      child: _isSvg(url)
          ? _buildSvgImage(url, iconSize)
          : _buildRasterImage(url, iconSize),
    );
  }

  Widget _buildSvgImage(String url, double iconSize) {
    return SvgPicture.network(
      url,
      width: iconSize,
      height: iconSize,
      fit: BoxFit.contain,
      placeholderBuilder: (_) {
        return _buildLoading(iconSize);
      },
      errorBuilder:
          (BuildContext context, Object error, StackTrace stackTrace) {
            return _buildFallback(iconSize);
          },
    );
  }

  Widget _buildRasterImage(String url, double iconSize) {
    return Image.network(
      url,
      width: iconSize,
      height: iconSize,
      fit: BoxFit.contain,

      // แสดงระหว่างโหลด PNG/JPG
      loadingBuilder:
          (
            BuildContext context,
            Widget child,
            ImageChunkEvent? loadingProgress,
          ) {
            if (loadingProgress == null) {
              return child;
            }

            return _buildLoading(iconSize);
          },

      // แสดงเมื่อโหลดหรือ Decode รูปไม่สำเร็จ
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) {
            return _buildFallback(iconSize);
          },
    );
  }

  Widget _buildLoading(double iconSize) {
    return Center(
      child: SizedBox(
        width: iconSize * 0.5,
        height: iconSize * 0.5,
        child: const CupertinoActivityIndicator(),
      ),
    );
  }

  Widget _buildFallback(double iconSize) {
    return Container(
      width: iconSize,
      height: iconSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFE7E1E9),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFD8CFDC)),
      ),
      child: Text(
        _firstCharacter,
        style: TextStyle(
          color: const Color(0xFF5F5265),
          fontSize: iconSize * 0.38,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  bool _isSvg(String url) {
    final uri = Uri.tryParse(url);

    // ใช้ path เพื่อไม่ให้ Query Parameters มีผล
    // เช่น coin.svg?version=1
    final path = uri?.path.toLowerCase() ?? url.toLowerCase();

    return path.endsWith('.svg');
  }

  String get _firstCharacter {
    final value = symbol.trim();

    if (value.isEmpty) {
      return '?';
    }

    return value.substring(0, 1).toUpperCase();
  }
}
