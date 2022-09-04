import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kid_garden_app/data/network/BaseApiService.dart';
import 'package:kid_garden_app/domain/Media.dart';
import 'package:kid_garden_app/presentation/general_components/units/cards.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoPreview extends StatefulWidget {
  PageController pageController;
  BoxDecoration backgroundDecoration;
  Function(int) onPageChanged;

  List<Media> galleryItems;

  PhotoPreview(
      {Key? key,
      required this.galleryItems,
      required this.pageController,
      required this.onPageChanged,
      required this.backgroundDecoration})
      : super(key: key);

  @override
  State<PhotoPreview> createState() => _PhotoPreviewState();
}

class _PhotoPreviewState extends State<PhotoPreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        leading: roundedClickableWithIcon(
            icon: Icon(Icons.cancel_outlined,color: Colors.white,size: 25,),
            size: 40,
            onClicked: () {
              Navigator.pop(context);
            }),
      ),
      body: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider:
                NetworkImage(domain + widget.galleryItems[index].url),
            initialScale: PhotoViewComputedScale.contained * 0.8,
            heroAttributes: PhotoViewHeroAttributes(
                tag: widget.galleryItems[index].id,
                transitionOnUserGestures: false),
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 1.8,
            basePosition: Alignment.center,
          );
        },
        itemCount: widget.galleryItems.length,
        loadingBuilder: (context, event) => Container(
          color: Colors.black,
          child: Center(
            child: SizedBox(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                value: event == null
                    ? 0
                    : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
              ),
            ),
          ),
        ),
        backgroundDecoration: widget.backgroundDecoration,
        pageController: widget.pageController,
        onPageChanged: widget.onPageChanged,
      ),
    );
  }
}
