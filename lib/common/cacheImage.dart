import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../service/apiConstant.dart';
import '../utils/color.dart';

Widget cacheImage({
  required String image,
  required double radius,
  required double height,
  required double width,
}) {
  return Container(
      alignment: Alignment.center,
      height: height,
      width: width,
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        // color: Colors.white,
        // shape: BoxShape.circle,
        borderRadius: BorderRadius.all(
          Radius.circular(
            radius,
          ),
        ),
        border: Border.all(width: 3, color: primary),
      ),
      child: CachedNetworkImage(
        imageUrl: image,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.fill,
            ),
          ),
        ),
        placeholder: (context, url) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(
                radius,
              ),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          decoration: BoxDecoration(
            // color: Colors.white,
            image: DecorationImage(
                image: NetworkImage(placeHolder), fit: BoxFit.fill),
            borderRadius: BorderRadius.all(
              Radius.circular(
                radius,
              ),
            ),
          ),
        ),
      ));
}
/*
Widget cacheImageNormal({
  required String image,
  required double radius,
  required double height,
  required double width,
}) {
  return kIsWeb
      ? Container(
          alignment: Alignment.center,
          height: height,
          width: width,
          // padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(
                radius,
              ),
            ),
            image: DecorationImage(
              image: NetworkImage((Apis.IMAGE_BASE_URL == image || image == '')
                  ? Apis.PLACE_HOlDER_URL
                  : image),
              fit: BoxFit.fill,
            ),
          ),
          */ /*child: FadeInImage.assetNetwork(
            placeholder: "assets/image/placeholder.png",
            image:(Apis.IMAGE_BASE_URL==image)?Apis.PLACE_HOlDER_URL: image,
            fit: BoxFit.fill,
          )*/ /*
        )
      : Container(
          alignment: Alignment.center,
          height: height,
          width: width,
          // padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(
                radius,
              ),
            ),
            border: Border.all(width: 0.2, color: grey.withOpacity(0.1)),
          ),
          child: CachedNetworkImage(
            imageUrl: image,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                image: DecorationImage(
                  image: imageProvider,
                ),
              ),
            ),
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: grey.withOpacity(0.2),
              highlightColor: grey.withOpacity(0.1),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        radius,
                      ),
                    ),
                    gradient: shadowGradient),
              ),
            ),
            errorWidget: (context, url, error) => Shimmer.fromColors(
              baseColor: grey.withOpacity(0.1),
              highlightColor: grey.withOpacity(0.02),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                      image: AssetImage('assets/images/placeHolder.png')),
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      radius,
                    ),
                  ),
                  gradient: shadowGradient,
                ),
              ),
            ),
          ));
}*/
/*
Widget cacheBannerImage({
  required String image,
  required double radius,
}) {
  return AspectRatio(
    aspectRatio: 10 / 4,
    child: Container(
        alignment: Alignment.center,
        // padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(
                radius,
              ),
            ),
            border: Border.all(width: 0.2, color: grey.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: grey.withOpacity(0.2),
                blurRadius: 2.0,
              )
            ]),
        child: CachedNetworkImage(
          imageUrl: image,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.fill,
              ),
            ),
          ),
          placeholder: (context, url) => Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      radius,
                    ),
                  ),
                  ),
            ),
          ),
          errorWidget: (context, url, error) => Shimmer.fromColors(
            baseColor: grey.withOpacity(0.3),
            highlightColor: grey.withOpacity(0.1),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    radius,
                  ),
                ),
                gradient: shadowGradient,
              ),
            ),
          ),
        )),
  );
}*/

Widget cacheImages({
  required String image,
  required double radius,
  required double height,
  required double width,
}) {
  return Container(
      alignment: Alignment.center,
      height: height,
      width: width,
      // padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(
            radius,
          ),
        ),
      ),
      child: CachedNetworkImage(
        imageUrl: image,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            // border: Border.all(width: 1, color: grey.withOpacity(0.2)),
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.fill,
            ),
          ),
        ),
        placeholder: (context, url) => Container(
          decoration: BoxDecoration(
            // border: Border.all(width: 1, color: grey.withOpacity(0.2)),
            color: grey,
            borderRadius: BorderRadius.all(
              Radius.circular(
                radius,
              ),
            ),
            image: DecorationImage(
              image: NetworkImage(
                  'https://www.svgrepo.com/show/508699/landscape-placeholder.svg'),
              fit: BoxFit.fill,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          decoration: BoxDecoration(
            // border: Border.all(width: 1, color: grey.withOpacity(0.2)),
            color: grey,
            borderRadius: BorderRadius.all(
              Radius.circular(
                radius,
              ),
            ),
            image: DecorationImage(
              image: NetworkImage(
                  'https://www.svgrepo.com/show/508699/landscape-placeholder.svg'),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ));
}

Widget cacheImageBG({
  required String image,
  required double radius,
  required double height,
  required double width,
}) {
  return Container(
      alignment: Alignment.center,
      height: height,
      width: width,
      // padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(
            radius,
          ),
        ),
      ),
      child: CachedNetworkImage(
        imageUrl: image,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            // border: Border.all(width: 1, color: grey.withOpacity(0.2)),
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.fill,
            ),
          ),
        ),
        placeholder: (context, url) => Container(
          decoration: BoxDecoration(
            // border: Border.all(width: 1, color: grey.withOpacity(0.2)),
            color: grey,
            borderRadius: BorderRadius.all(
              Radius.circular(
                radius,
              ),
            ),
            image: DecorationImage(
              image: AssetImage("assets/proBG.png"),
              fit: BoxFit.fill,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          decoration: BoxDecoration(
            // border: Border.all(width: 1, color: grey.withOpacity(0.2)),
            color: grey,
            borderRadius: BorderRadius.all(
              Radius.circular(
                radius,
              ),
            ),
            image: DecorationImage(
              image: AssetImage("assets/proBG.png"),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ));
}

Widget cacheLevelBG({
  required String image,
  required double radius,
  required double height,
  required double width,
}) {
  return Container(
      alignment: Alignment.center,
      height: height,
      width: width,
      // padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(
            radius,
          ),
        ),
      ),
      child: CachedNetworkImage(
        imageUrl: image,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            // border: Border.all(width: 1, color: grey.withOpacity(0.2)),
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.fill,
            ),
          ),
        ),
        placeholder: (context, url) => Container(
          decoration: BoxDecoration(
            // border: Border.all(width: 1, color: grey.withOpacity(0.2)),
            color: grey,
            borderRadius: BorderRadius.all(
              Radius.circular(
                radius,
              ),
            ),
            image: DecorationImage(
              image: AssetImage("assets/proBG.png"),
              fit: BoxFit.fill,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          decoration: BoxDecoration(
            // border: Border.all(width: 1, color: grey.withOpacity(0.2)),
            color: grey,
            borderRadius: BorderRadius.all(
              Radius.circular(
                radius,
              ),
            ),
            image: DecorationImage(
              image: AssetImage("assets/proBG.png"),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ));
}
