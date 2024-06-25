import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:untitled1/product_view_model.dart';
import 'cus_seekbar_clipper.dart';

class CusExtendContainer extends StatefulWidget {
  final List<CusExtendController> controllers;
  final Function(int index, int itemIndex) onIncrease;
  final Function(int index, int itemIndex) onDecrease;
  final CusExtendStackController controller;
  final Function(int index) onItemTap;

  const CusExtendContainer({
    super.key,
    required this.controller,
    required this.controllers,
    required this.onItemTap,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  State<CusExtendContainer> createState() => _CusExtendContainerState();
}

class CusExtendStackController {
  bool canExpand = false;
}

_calTotalListViewHeight(List<CusExtendController> controllers) {
  double totalListViewHeight = 0.0;
  for (int i = 0; i <= controllers.length - 1; i++) {
    if (controllers[i].isExpanded) {
      totalListViewHeight += i == 0
          ? controllers[i].calExpandedHeight() + controllers[i].titleHeight + 29
          : i == 6
              ? controllers[i].calExpandedHeight() +
                  controllers[i].titleHeight -
                  100
              : controllers[i].calExpandedHeight() +
                  controllers[i].titleHeight -
                  39;
    } else {
      switch (i) {
        case 0:
          totalListViewHeight += controllers[i].titleHeight;
          break;
        case 6:
          totalListViewHeight += controllers[i].titleHeight - 58;
          break;
        default:
          totalListViewHeight += controllers[i].titleHeight - 100 + 29;
          break;
      }
    }
  }
  return totalListViewHeight;
}

_findOutIndexOfExpanded(List<CusExtendController> controllers) {
  for (int i = 0; i < controllers.length; i++) {
    if (controllers[i].isExpanded) {
      return i;
    }
  }
  return -1;
}

class _CusExtendContainerState extends State<CusExtendContainer> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Opacity(
            opacity: 0.0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: _calTotalListViewHeight(
                widget.controllers,
              ),
              curve: Curves.easeInOut,
            ),
          ),
          ...List.generate(
            widget.controllers.length,
            (index) {
              int expandedIndex = _findOutIndexOfExpanded(widget.controllers);
              return AnimatedPositioned(
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 500),
                left: 0,
                right: 0,
                top: expandedIndex == -1
                    ? widget.controller.canExpand
                        ? index * 100
                        : index * 30
                    : index > expandedIndex
                        ? widget.controllers[expandedIndex]
                                .calExpandedHeight() +
                            index * 100 +
                            29
                        : index * 100,
                bottom: 0,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          //给Stack给定一个高度
                          Opacity(
                            opacity: 0.0,
                            child: AnimatedContainer(
                                curve: Curves.easeInOut,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                duration: const Duration(milliseconds: 500),
                                height: !widget.controllers[index].isExpanded
                                    ? 0
                                    : widget.controllers[index]
                                            .calExpandedHeight() +
                                        widget.controllers[index].titleHeight -
                                        50),
                          ),
                          //内容
                          AnimatedPositioned(
                            curve: Curves.easeInOut,
                            duration: const Duration(milliseconds: 500),
                            //Top 与标题直接的距离
                            top: widget.controllers[index].titleHeight - 50,
                            right: 0,
                            left: 0,
                            bottom:
                                widget.controllers[index].isExpanded ? 0 : 50,
                            child: Container(
                              margin: EdgeInsets.only(
                                left: 21,
                                right: 21,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xffFFFFFF),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xff858585).withOpacity(
                                      0.26,
                                    ),
                                    blurRadius: 10,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: _buildItemView(
                                  index,
                                  widget.controllers[index].index,
                                  widget.controllers[index]
                                      .calItemTotalHeight()),
                            ),
                          ),
                          CusAnimatedTransformTitle(
                            controller: widget.controllers[index],
                            onItemClick: (index) {
                              widget.onItemTap.call(index);
                            },
                            stackController: widget.controller,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  _buildItemView(int controllerIndex, int index, double itemTotalHeight) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          SizedBox(
            height: 70,
          ),
          SizedBox(
            height: itemTotalHeight,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    _buildExpendedItemView(controllerIndex, index),
                    index !=
                            widget.controllers[controllerIndex].allProducts
                                    .length -
                                1
                        ? SizedBox(
                            height: 49,
                          )
                        : Container(
                            height: 45,
                          )
                  ],
                );
              },
              itemCount: widget.controllers[controllerIndex].allProducts.length,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  void showItemOfProductTopSheet(BuildContext context, int index,
      ProductViewModel productViewModel) async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 500),
      barrierLabel: MaterialLocalizations.of(context).dialogLabel,
      barrierColor: Colors.black.withOpacity(0.7),
      pageBuilder: (context, _, __) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(statusBarColor: Colors.white),
          child: SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: EdgeInsets.only(bottom: 49, left: 0, right: 0),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(
                        30,
                      ),
                    ),
                    color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                      child: Text(
                        textAlign: TextAlign.center,
                        productViewModel.productName,
                        style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 39,
                      ),
                      child: Divider(
                        color: const Color(0xffD9DADC).withOpacity(0.7),
                        thickness: 1,
                        height: 1,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        '供應商:${productViewModel.supplierName}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 13,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          '貨品編號：${productViewModel.productCode}',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                        Text(
                          '單位 : ${productViewModel.qualityInfo}',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ).drive(
            Tween<Offset>(
              begin: const Offset(0, -1.0),
              end: Offset.zero,
            ),
          ),
          child: child,
        );
      },
    );
  }

  _buildExpendedItemView(int controllerIndex, int index) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 14),
      width: double.infinity,
      height: 76,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showItemOfProductTopSheet(
                            context,
                            index,
                            widget.controllers[controllerIndex]
                                .allProducts[index]);
                      },
                      child: Text(
                        widget.controllers[controllerIndex].allProducts[index]
                            .productName,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                          color: widget.controllers[controllerIndex]
                                  .allProducts[index].canOrderCart
                              ? const Color(
                                  0xff1F1F1F,
                                )
                              : Colors.red,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 66,
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            widget.controllers[controllerIndex]
                                .allProducts[index].supplierName,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 22,
                              color: widget.controllers[controllerIndex]
                                      .allProducts[index].canOrderCart
                                  ? const Color(
                                      0xff1F1F1F,
                                    )
                                  : Colors.red,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 26,
                        ),
                        SizedBox(
                          width: 110,
                          child: Text(
                            widget.controllers[controllerIndex]
                                .allProducts[index].qualityInfo,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: widget.controllers[controllerIndex]
                                      .allProducts[index].canOrderCart
                                  ? const Color(
                                      0xff1F1F1F,
                                    )
                                  : Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(
                        0xffEAEAEA,
                      ),
                      borderRadius: BorderRadius.circular(
                        20,
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                    clipper: SeekBarClipper(
                        selectNum: widget.controllers[controllerIndex]
                            .allProducts[index].selectedCount,
                        num: widget.controllers[controllerIndex]
                            .allProducts[index].count,
                        radius: 20),
                    child: Container(
                      width: double.infinity,
                      height: 5,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(
                              0xff06B217,
                            ),
                            Color(0xff0DE022),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CusExtendController {
  CusExtendController({required this.date, required this.index});

  double titleHeight = 170;

  //获取标题+内容的总高度 //用于设置Stack中的高度
  double calExpandedHeight() {
    double itemTotalHeight = 0.0;
    for (int i = 0; i < allProducts.length; i++) {
      itemTotalHeight += calculateExpendedItemViewHeight(i, this);
    }
    double expandedHeight = calculateExpendedViewHeight(this) + itemTotalHeight;
    return expandedHeight;
  }

  double calItemTotalHeight() {
    double itemTotalHeight = 0.0;
    for (int i = 0; i < allProducts.length; i++) {
      itemTotalHeight += calculateExpendedItemViewHeight(i, this);
    }
    return itemTotalHeight;
  }

  double calculateExpendedViewHeight(CusExtendController controller) {
    double totalHeight = 0.0;
    if (controller.allProducts.isNotEmpty) {
      totalHeight += 70;
    } else {
      totalHeight += 85;
    }
    return totalHeight;
  }

  double calculateExpendedItemViewHeight(
      int index, CusExtendController controller) {
    if (index == controller.allProducts.length - 1) {
      return 76 + 45;
    } else {
      return 76 + 49;
    }
  }

  bool isExpanded = false;
  List<ProductViewModel> allProducts = [];

  canExpand() {
    return allProducts.isNotEmpty;
  }

  DateTime date;
  int index;
}

class CusAnimatedTransformTitle extends StatefulWidget {
  const CusAnimatedTransformTitle({
    super.key,
    required this.controller,
    required this.stackController,
    required this.onItemClick,
  });

  final CusExtendController controller;
  final Function(int index) onItemClick;
  final CusExtendStackController stackController;

  @override
  State<CusAnimatedTransformTitle> createState() =>
      _CusAnimatedTransformTitleState();
}

class _CusAnimatedTransformTitleState extends State<CusAnimatedTransformTitle> {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(
          begin: widget.controller.isExpanded ? 0.40 : -0.40,
          end: widget.controller.isExpanded ? -0.40 : 0.40),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(value),
          alignment: FractionalOffset.center,
          child: Container(
            height: widget.controller.titleHeight,
            margin: EdgeInsets.only(
              left: 21,
              right: 21,
            ),
            decoration: BoxDecoration(
              color: const Color(0xffFFFFFF),
              borderRadius: BorderRadius.circular(
                20,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff858585).withOpacity(
                    0.26,
                  ),
                  offset: Offset(
                    5,
                    5,
                  ),
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                if (widget.stackController.canExpand) {
                  widget.onItemClick.call(widget.controller.index);
                }
              },
              child: Container(
                height: 85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                  gradient: const LinearGradient(
                    colors: [
                      Color(
                        0xff645DDB,
                      ),
                      Color(0xff8B55FE)
                    ],
                  ),
                ),
                padding: EdgeInsets.all(
                  widget.controller.isExpanded ? 2 : 1,
                ),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        19,
                      ),
                      color: const Color(0xffFFFFFF)),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          '${DateFormat.MMMd("zh_CN").format(widget.controller.date)} / ${DateFormat('EEEE', "zh_CN").format(widget.controller.date)}',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 20.51,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 34.6,
                        top: 0,
                        bottom: 0,
                        child: AnimatedRotation(
                          curve: Curves.easeInOut,
                          turns: widget.controller.isExpanded ? 0 : 0.5,
                          duration: const Duration(milliseconds: 500),
                          child: Icon(
                            Icons.keyboard_arrow_up,
                            color: Colors.black,
                            size: 28.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
