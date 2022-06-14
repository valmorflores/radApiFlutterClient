import 'package:cached_network_image/cached_network_image.dart';
import '/core/constants/kcache.dart';
import '/utils/progress_bar/progress_bar.dart';
import 'package:flutter/material.dart';

class WidgetStaffAvatar extends StatelessWidget {
  String urlImage;
  GestureTapCallback? onTap;
  GestureTapCallback? onLongPress;
  double? width;
  double? height;
  BoxShape shape;

  WidgetStaffAvatar({
    Key? key,
    required this.urlImage,
    this.onTap,
    this.onLongPress,
    required this.shape,
    width,
    height,
  }) {}

  @override
  Widget build(BuildContext context) {
    width = (width == null) ? 100.0 : width;
    height = (height == null) ? 100.0 : height;
    return render();
  }

  render() {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: _image(urlImage, shape),
    );
  }

  _image(String _image, _shape) {
    //debugPrint('f7477 - $_image');
    Icon _icon = Icon(Icons.photo);
    return CachedNetworkImage(
      placeholder: (context, url) => progressBar(context),
      imageUrl: _image,
      fit: BoxFit.cover,
      maxWidthDiskCache: kMaxWidthDiaskCachedImages,
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: _shape,
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      errorWidget: (BuildContext context, url, error) {
        return _icon;
      },
    );
  }
}
