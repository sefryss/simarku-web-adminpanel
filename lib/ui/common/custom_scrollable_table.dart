// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// // import 'package:scrollable_table_view/src/utils.dart';
// import 'package:ebookadminpanel/util/responsive.dart';
//
// import '../../theme/color_scheme.dart';
// import 'common.dart';
//
// class CustomScrollableTableView extends StatefulWidget {
//   const CustomScrollableTableView({
//     Key? key,
//     required this.rows,
//     required this.columns,
//     this.headerHeight = 40,
//     this.rowDividerHeight = 1.0,
//     this.paginationController,
//   }) : super(key: key);
//
//   /// Column widgets displayed in the table header.
//   final List<TableViewColumn> columns;
//
//   /// Row widgets displayed in the content area of the table.
//   final List<TableViewRow> rows;
//
//   /// The height of the table header.
//   final double headerHeight;
//
//   /// The height of the row divider
//   final double rowDividerHeight;
//
//   /// Handles pagination
//   final PaginationController? paginationController;
//
//   @override
//   State<CustomScrollableTableView> createState() =>
//       _CustomScrollableTableViewState();
// }
//
// class _CustomScrollableTableViewState extends State<CustomScrollableTableView> {
//   final _horizontalScrollController = ScrollController();
//   final _verticalScrollController1 = ScrollController();
//   final _verticalScrollController2 = ScrollController();
//
//   final double _horizontalScrollViewPadding = 0;
//
//   List<TableViewRow> _getPaginatedRows(int? page) {
//     page ??= widget.paginationController!.currentPage;
//
//     if (page < 1) {
//       debugPrint("page cannot be less than 1, got $page");
//       return [];
//     }
//
//     if (page > widget.paginationController!.pageCount) {
//       debugPrint(
//           "page $page is out of range!!! ${widget.paginationController!.pageCount} pages available");
//       return [];
//     }
//
//     int to = page * widget.paginationController!.rowsPerPage;
//     int from = to - widget.paginationController!.rowsPerPage;
//
//     if (to > widget.rows.length) {
//       to = widget.rows.length;
//     }
//
//     return widget.rows.getRange(from, to).toList();
//   }
//
//   void _resetVerticalPosition() {
//     /// Whenever a new page is navigated to,
//     /// we set the scroll back to the top
//     _verticalScrollController1.jumpTo(0.0);
//   }
//
//   void _updateVerticalPosition1() {
//     _verticalScrollController1
//         .jumpTo(_verticalScrollController2.position.pixels);
//   }
//
//   void _updateVerticalPosition2() {
//     _verticalScrollController2
//         .jumpTo(_verticalScrollController1.position.pixels);
//   }
//
//   /// Combined height of the table rows plus their dividers
//   ///
//   /// We use this to enable effective vertical scrolling
//   double get _contentHeight {
//     var height = 0.0;
//
//     List<TableViewRow> rows = widget.paginationController == null
//         ? widget.rows
//         : _getPaginatedRows(null);
//
//     for (var row in rows) {
//       height += row.height + widget.rowDividerHeight;
//     }
//
//     return height;
//   }
//
//
//   @override
//   void initState() {
//     _verticalScrollController1.addListener(_updateVerticalPosition2);
//     _verticalScrollController2.addListener(_updateVerticalPosition1);
//
//     if (widget.paginationController != null) {
//       widget.paginationController!.addListener(_resetVerticalPosition);
//     }
//
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _verticalScrollController1.removeListener(_updateVerticalPosition2);
//     _verticalScrollController2.removeListener(_updateVerticalPosition1);
//
//     _horizontalScrollController.dispose();
//     _verticalScrollController1.dispose();
//     _verticalScrollController2.dispose();
//
//     if (widget.paginationController != null) {
//       widget.paginationController!.removeListener(_resetVerticalPosition);
//     }
//
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (widget.paginationController != null &&
//         widget.paginationController!.rowCount != widget.rows.length) {
//       throw FlutterError(
//           "failed assertion: widget.paginationController!.recordCount != widget.rows.length");
//     }
//
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return Container(
//           decoration: getDefaultDecoration(
//               bgColor: getCardColor(context), radius: 0),
//           width: constraints.maxWidth,
//           height: constraints.maxHeight,
//           child: Row(
//             children: [
//               Expanded(
//                 child: Scrollbar(
//                   controller: _horizontalScrollController,
//                   thumbVisibility: true,
//                   child: SingleChildScrollView(
//                     padding: EdgeInsets.symmetric(
//                         vertical: _horizontalScrollViewPadding, horizontal: 0),
//                     controller: _horizontalScrollController,
//                     scrollDirection: Axis.horizontal,
//                     child: Container(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Container(
//                                 decoration: getDefaultDecoration(
//                                     bgColor: getReportColor(context), radius: 0),
//
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: widget.columns,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Expanded(
//                             child: ScrollConfiguration(
//                               behavior: ScrollConfiguration.of(context)
//                                   .copyWith(scrollbars: true),
//                               child: SingleChildScrollView(
//                                 scrollDirection: Axis.vertical,
//
//                                 child: widget.paginationController == null
//                                     ? Column(
//                                         children: widget.rows,
//                                       )
//                                     : ValueListenableBuilder(
//                                         valueListenable:
//                                             widget.paginationController!,
//                                         builder: (context, int page, _) {
//                                           return Column(
//                                             children: _getPaginatedRows(page),
//                                           );
//                                         },
//                                       ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 width: 0,
//                 height: double.infinity,
//
//                 /// Padding will allow for [_verticalScrollController1] and [_verticalScrollController2]
//                 /// to have the same maxScrollExtent. This ensures that a user can scroll to the end of
//                 /// the vertical [SingleChildScrollView]. We achieve this by ensuring that the [ScrollBar]
//                 /// thumb of [_verticalScrollController2] below starts around the same vertical space as
//                 /// the vertical [SingleChildScrollView].
//                 ///
//                 /// The padding is hence achieved by adding the table header height, the vertical padding
//                 /// of the horizontal [SingleChildScrollView] and the row divider height within the header.
//                 padding: EdgeInsets.only(
//                   top: widget.headerHeight +
//                       (_horizontalScrollViewPadding * 2) +
//                       widget.rowDividerHeight,
//                 ),
//                 child: Align(
//                   alignment: Alignment.topCenter,
//                   child: Scrollbar(
//                     controller: _verticalScrollController2,
//                     thumbVisibility: true,
//                     child: SingleChildScrollView(
//                       controller: _verticalScrollController2,
//                       scrollDirection: Axis.vertical,
//                       child: widget.paginationController == null
//                           ? SizedBox(
//                               width: 10,
//                               height: _contentHeight,
//                             )
//                           : ValueListenableBuilder(
//
//                               /// We listen to page changes so us to update
//                               /// the content height. This is especially useful
//                               /// for the last page which may have less rows
//                               /// as compared with previous pages. This will allow
//                               /// us to appropriately update the length of the
//                               /// scrollbar thumb
//                               valueListenable: widget.paginationController!,
//                               builder: (context, value, child) {
//                                 return SizedBox(
//                                   width: 10,
//                                   height: _contentHeight,
//                                 );
//                               }),
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
//
// class TableViewColumn extends StatelessWidget {
//   const TableViewColumn({
//     Key? key,
//     this.width,
//     this.height,
//     required this.label,
//     this.labelFontSize = 14,
//     this.minWidth = 80,
//   }) : super(key: key);
//
//   /// The width of the column.
//   /// If the [width] is not provided, a width is calculated
//   /// based on the contents of the column. If the calculated
//   /// width is less than the [minWidth], then the [minWidth]
//   /// is applied
//   final double? width;
//
//   /// Column height.
//   ///
//   /// Kindly note that the table header also has a height, which
//   /// means that this height will not have a visual effect outside
//   /// of the table header
//   final double? height;
//
//   /// A string to act as the label for the column
//   final String label;
//
//   /// Font size of the label
//   final double labelFontSize;
//
//   /// The minimum width of the column. This is applied if the provided
//   /// or calculated width is less.
//   final double minWidth;
//
//   // Returns the effective width of the column
//   double getWidth() {
//     return width ?? max((0.7 * labelFontSize) * label.length, minWidth);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double padding =   15.h
//     ;
//     double w = width ??
//         max((0.7 * getResizeFont(context, 70)) * label.length, minWidth);
//
//     if (Responsive.isDesktop(context)) {
//       w = MediaQuery.of(context).size.width / 4.5;
//
//       if (label == 'Id') {
//         w = 100.w;
//       }
//     }else{
//       w = MediaQuery.of(context).size.width / 2;
//     }
//
//     return Container(
//
//       width: w,
//       alignment: Alignment.centerLeft,
//
//       child: Stack(
//         children: [
//           Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               getVerticalSpace(context, (padding / 4)),
//
//               getMaxLineFont(context, label, 50, getFontColor(context), 1,
//                       fontWeight: FontWeight.w500, textAlign: TextAlign.start)
//                   .paddingOnly(
//                 left: padding,
//                 top: (padding / 2),
//                 bottom: (padding / 2),
//               ),
//               getVerticalSpace(context, (padding / 4)),
//
//
//             ],
//           ),
//
//         ],
//       ),
//     );
//   }
// }
//
// class TableViewRow extends StatelessWidget {
//   const TableViewRow({
//     Key? key,
//     required this.cells,
//     this.height = 40,
//     this.onTap,
//   }) : super(key: key);
//
//   /// Cells within the row.
//   ///
//   /// [cells.length] must be equal to the number of columns
//   /// provided.
//   final List<TableViewCell> cells;
//
//   /// Row height
//   final double height;
//
//   /// Will be called any time a user taps a row
//   final void Function()? onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     var tableView =
//         context.findAncestorWidgetOfExactType<CustomScrollableTableView>();
//     var tableViewState =
//         context.findAncestorStateOfType<_CustomScrollableTableViewState>();
//
//     assert(tableView != null && tableViewState != null);
//
//     var columns = tableView!.columns;
//
//     double w = MediaQuery.of(context).size.width / 2;
//
//     w = (w * 4);
//
//     if (Responsive.isDesktop(context)) {
//       w = MediaQuery.of(context).size.width / 4.5;
//
//       w = (w * 3) + 200.w;
//     }
//
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.max,
//         children: [
//           Row(
//             children: Utils.map(cells, (index, cell) {
//               double w = columns[index].getWidth();
//
//               if (Responsive.isDesktop(context)) {
//                 w = MediaQuery.of(context).size.width / 4.5;
//
//                 if (index == 0) {
//                   w = 100.w;
//                 }
//               }else{
//                 w = MediaQuery.of(context).size.width / 2;
//               }
//
//               /// [SizedBox] below acts as a parent to each of the cells.
//               /// Its width ensures that all cells in a column have the
//               /// same width as the respective [TableViewColumn]
//               return Container(
//                 color:getCardColor(context),
//                 width: w,
//                 height: 200.h,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//
//                     Expanded(child: Column(
//                       children: [
//                         Expanded(child: Container(
//                           child: cell,
//                           alignment: Alignment.centerLeft,
//                         ),),
//                         Container(
//                           height: 1,
//                           width: w,
//                           color: getBorderColor(context),
//                         ),
//                       ],
//                     )),
//
//
//
//                   ],
//                 ),
//               );
//             }),
//           ),
//
//
//
//
//         ],
//       ),
//     );
//   }
// }
//
// class TableViewCell extends StatelessWidget {
//   const TableViewCell({
//     Key? key,
//     this.child,
//   }) : super(key: key);
//
//   /// Child of the cell
//   final Widget? child;
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       child: Center(
//         child: child,
//       ),
//     );
//   }
// }
//
// class PaginationController extends ValueNotifier<int> {
//   PaginationController({
//     required this.rowsPerPage,
//     required this.rowCount,
//   }) : super(1);
//
//   final int rowsPerPage;
//   final int rowCount;
//
//   int get pageCount {
//     return (rowCount / rowsPerPage).ceil();
//   }
//
//   int get currentPage {
//     return value;
//   }
//
//   void next() {
//     if (value < pageCount) {
//       value++;
//     }
//   }
//
//   void previous() {
//     if (value > 1) {
//       value--;
//     }
//   }
//
//   void jumpTo(int page) {
//     if (page > 0 && page <= pageCount) {
//       value = page;
//     }
//   }
// }
