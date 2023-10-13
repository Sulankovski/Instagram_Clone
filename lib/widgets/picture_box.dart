import 'package:flutter/material.dart';
import 'package:instagram_clone/widgets/picture_zoom.dart';

class PictureBox extends StatelessWidget {
  final String picture;
  final double height;
  final double width;
  final bool? ispost;
  final BoxFit fit;

  const PictureBox({
    super.key, 
    required this.picture,
    required this.height,  
    required this.width,
    required this.ispost,
    required this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return MediaQuery(data: MediaQuery.of(context),
      child: ispost == false 
        ? Image.asset(
          picture,
          height: MediaQuery.of(context).size.height*height,
          width: MediaQuery.of(context).size.width*width,
          fit: fit,
        )
        : SizedBox(
          height: MediaQuery.of(context).size.height*height,
          width: double.infinity,
          child: PictureZoom(
            picture: Image(
              image: NetworkImage(
                picture,
              ),
              fit: fit,
            ),
          ),
        ),
    );
  }
}