import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'OurColors.dart';

class PdfLoader extends StatefulWidget {
  String type;

  PdfLoader({Key? key, required this.type}) : super(key: key);
  @override
  _PdfLoader createState() => _PdfLoader();
}

class _PdfLoader extends State<PdfLoader> {
  late Image pdf;

  List<Color> colo = [
    blues[0],
    azure[0],
    taupe[1],
    azure[1],
    azure[2],
    taupe[1],
    taupe[2],
    taupe[2],
    taupe[2],
  ];

  @override
  void initState() {
    super.initState();
    pdf = Image(image: AssetImage('lib/Img/pot2fleur.png'));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(pdf.image, context);
  }

  Widget _build() {
    switch (widget.type) {
      case "LBGCircle":
        return (LoadingBouncingGrid.circle(
          size: 200,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                child: RotatedBox(
              quarterTurns: 2,
              child: ColorFiltered(
                  child: pdf,
                  colorFilter: ColorFilter.mode(colo[index], BlendMode.srcIn)),
            ));
          },
        ));
      case "LBLCircle":
        return (LoadingBumpingLine.circle(
            size: 200,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: ColorFiltered(
                    child: pdf,
                    colorFilter:
                        ColorFilter.mode(colo[index], BlendMode.srcIn)),
              );
            }));
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return (_build());
  }
}
