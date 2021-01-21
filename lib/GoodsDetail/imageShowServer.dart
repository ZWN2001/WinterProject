import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageShowServerWidget extends StatefulWidget {

  final int initialIndex;
  final List<dynamic> photoList;
  final PageController pageController;
  String string;

  ImageShowServerWidget({this.initialIndex, this.photoList})
  : pageController = PageController(initialPage: initialIndex);

  @override
  _ImageShowServerWidgetState createState() => _ImageShowServerWidgetState();
}

class _ImageShowServerWidgetState extends State<ImageShowServerWidget> {
  int currentIndex;

  void initState() {
    currentIndex = widget.initialIndex;
    super.initState();
  }

  //图片切换
  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
   return Container(
     child: Stack(
       children:<Widget> [
         Positioned(
             child: PhotoViewGallery.builder(
                 scrollPhysics: const ClampingScrollPhysics(),
                 onPageChanged: onPageChanged,
                 itemCount: widget.photoList.length,
                 pageController: widget.pageController,
                 builder: (BuildContext context, int index){
                   return PhotoViewGalleryPageOptions(
                     imageProvider: NetworkImage(widget.photoList[index]),
                     initialScale: PhotoViewComputedScale.contained,
                   );
                 })),
         Positioned(
             left: 10,
             top: 60,
             child: GestureDetector(
               child: Row(
                 children:<Widget> [
                   Icon(
                     Icons.close,
                     color: Colors.white,
                   ),
                 ],
               ),
               onTap: () {
                 Navigator.pop(context);
               },
             )),
         Positioned(
             right: 10,
             bottom: 60,
             child: Row(
               children:<Widget> [
                 Text('${currentIndex + 1}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w300
                 ),),
                 Text('/',
                     style: TextStyle(
                         color: Colors.white,
                         fontSize: 18,
                         decoration: TextDecoration.none,
                         fontWeight: FontWeight.w300)),
                 Text('${widget.photoList.length}',
                     style: TextStyle(
                         color: Colors.white,
                         fontSize: 18,
                         decoration: TextDecoration.none,
                         fontWeight: FontWeight.w300))
               ],
             ))
       ],
     ),
   );
  }

}