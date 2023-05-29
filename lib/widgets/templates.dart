import 'package:asra_app_new/utils/colors.dart';
import 'package:asra_app_new/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TopImageTemplateWidget extends StatelessWidget {
  final Image? image;
  final double radius;
  final Widget? child;
  const TopImageTemplateWidget({
    this.image,
    this.radius = Dimensions.radius * 3,
    this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Image.asset(
                'assets/imgs/bg.png',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
              ),
              Positioned(
                width: MediaQuery.of(context).size.width,
                top: MediaQuery.of(context).size.height * 0.2,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.8,
                  decoration: BoxDecoration(
                    color: CustomColor.accentColor,
                    borderRadius: BorderRadius.circular(Dimensions.radius * 3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.marginSize).copyWith(bottom: Dimensions.marginSize * 2),
                    child:
                        //  DraggableScrollableSheet(
                        //   expand: false,
                        //   builder: (context, controller) =>
                        SingleChildScrollView(
                      // padding: const EdgeInsets.only(bottom: Dimensions.marginSize),
                      // controller: controller,
                      child: child,
                    ),
                    // ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopImageEtchedWidget extends StatelessWidget {
  final Widget? top;
  final Widget? child;
  const TopImageEtchedWidget({
    this.top,
    this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height * 0.5;
    final h2 = h - 60;
    return Scaffold(
      backgroundColor: CustomColor.primaryColor,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                SvgPicture.string(
                  '''
                    <svg viewBox="0 0 $w $h" 
                        xmlns="http://www.w3.org/2000/svg">
                      <path d="M0,0 L$w,0 L$w,$h L0,$h2" fill="#000"></path>
                    </svg>
                  ''',
                  colorFilter: const ColorFilter.mode(
                    CustomColor.accentColor,
                    BlendMode.srcIn,
                  ),
                ),
                if (top != null)
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: top!,
                    ),
                  ),
              ],
            ),
            if (child != null) child!,
          ],
        ),
      ),
    );
  }
}
