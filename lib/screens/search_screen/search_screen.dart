// import 'package:dio/dio.dart';
// import "package:flutter/material.dart";
// import 'package:like_button/like_button.dart';
// import '../../components/tabView.dart';
// import '../../constants.dart';
// import '../../models/course.dart';
// import '../../models/organization.dart';
// import '../../models/set.dart';
// import '../../models/setCategory.dart';
// import '../../screens/courses_screen/courses_screen.dart';
// import '../../screens/subjects_screen/subjects_screen.dart';
// import '../../screens/organization_screen/organization_screen.dart';
// import '../../screens/set_screen/set_screen.dart';
// import '../../utilities/api.dart';
// import '../../utilities/auth.dart';
// import '../../utilities/globals.dart';
// import 'package:provider/provider.dart';

// class SearchScreen extends StatefulWidget {
//   SearchScreen({Key? key}) : super(key: key);
//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen>
//     with SingleTickerProviderStateMixin {
//   final _searchController = TextEditingController();
//   List<Set> _filteredSets = [];
//   List<SetCategory> _filteredCategories = [];
//   List<Organization> _filteredOrganizations = [];
//   List<Course> _filteredCourses = [];
//   static List<String> tabs = ["All", "Courses", "Subjects", "Sets", "Company"];
//   bool _loading = false;
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = new TabController(length: tabs.length, vsync: this);
//   }

//   @override
//   void dispose() {
//     // Clean up the controller when the widget is disposed.
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currProvider = Provider.of<Auth>(context, listen: true);
//     TextStyle style = new TextStyle(
//         fontSize: 16, color: PRIMARY_DARK, fontFamily: 'Montserrat');

//     TextStyle labelStyle = new TextStyle(
//         fontSize: 16,
//         color: currProvider.darkTheme ? Colors.white : PRIMARY_DARK,
//         fontFamily: 'Montserrat',
//         fontWeight: FontWeight.bold);

//     // Input field for search
//     final TextField? searchField = TextField(
//       controller: _searchController,
//       textInputAction: TextInputAction.search,
//       obscureText: false,
//       style: style.copyWith(
//           color: Provider.of<Auth>(context, listen: false).darkTheme
//               ? Colors.white
//               : PRIMARY_DARK),
//       decoration: InputDecoration(
//           hintText: "Search",
//           contentPadding:
//               new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
//           fillColor: Provider.of<Auth>(context, listen: true).darkTheme
//               ? PRIMARY_DARK
//               : Colors.white,
//           filled: true,
//           prefixIcon: Icon(
//             Icons.search,
//             color: PRIMARY_BLUE,
//             size: 18,
//           ),
//           focusColor: PRIMARY_BLUE,
//           border: OutlineInputBorder(borderSide: BorderSide.none)),
//       onSubmitted: (String text) async {
//         setState(() {
//           _loading = true;
//         });
//         if (text.isEmpty) {
//           setState(() {
//             _filteredSets = [];
//             _filteredCategories = [];
//             _filteredOrganizations = [];
//             _loading = false;
//           });
//         } else {
//           Response response =
//               await dio().get("/search/courses/q=" + text.trim().toLowerCase());
//           setState(() {
//             _filteredCourses = response.data
//                 .map<Course>((data) => Course.fromJson(data))
//                 .toList();
//           });
//           response =
//               await dio().get("/set/categories/q=" + text.trim().toLowerCase());
//           setState(() {
//             _filteredCategories = response.data
//                 .map<SetCategory>((data) => SetCategory.fromJson(data))
//                 .toList();
//           });
//           response = await dio().get("/sets/q=" + text.trim().toLowerCase());
//           setState(() {
//             _filteredSets =
//                 response.data.map<Set>((data) => Set.fromJson(data)).toList();
//           });
//           response =
//               await dio().get("/organizations/q=" + text.trim().toLowerCase());
//           setState(() {
//             _filteredOrganizations = response.data
//                 .map<Organization>((data) => Organization.fromJson(data))
//                 .toList();
//             _loading = false;
//           });
//         }
//       },
//     );

//     Widget getSetCard(Set set) {
//       return GestureDetector(
//           onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     settings: RouteSettings(name: "Set"),
//                     builder: (context) => SetScreen(id: set.id)),
//               ),
//           child: Container(
//               width: MediaQuery.of(context).size.width,
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
//                 child: Card(
//                   color: Provider.of<Auth>(context, listen: false).darkTheme
//                       ? PRIMARY_DARK
//                       : Colors.white,
//                   elevation: 10,
//                   child: Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: Stack(
//                       children: <Widget>[
//                         Row(
//                           children: <Widget>[
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     width: MediaQuery.of(context).size.width,
//                                     child: Text(
//                                       set.title,
//                                       style: style.copyWith(
//                                           fontWeight: FontWeight.bold,
//                                           color: Provider.of<Auth>(context,
//                                                       listen: false)
//                                                   .darkTheme
//                                               ? Colors.white
//                                               : PRIMARY_DARK),
//                                     ),
//                                   ),
//                                   Container(
//                                       padding: EdgeInsets.symmetric(
//                                           horizontal: 5, vertical: 2),
//                                       decoration: BoxDecoration(
//                                           color: PRIMARY_BLUE.withOpacity(0.1),
//                                           borderRadius:
//                                               BorderRadius.circular(10.0)),
//                                       margin: EdgeInsets.only(top: 12.0),
//                                       child: Text(
//                                         set.category != null
//                                             ? set.category!.title
//                                             : "No subject",
//                                         style: TextStyle(
//                                             fontSize: 12,
//                                             color: PRIMARY_BLUE,
//                                             fontWeight: FontWeight.bold),
//                                       )),
//                                   SizedBox(
//                                     height: 20,
//                                   ),
//                                   set.category != null || set.publisher != null
//                                       ? Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                           children: [
//                                             Padding(
//                                               padding: const EdgeInsets.only(
//                                                   right: 8.0),
//                                               child: Container(
//                                                   width: 22.0,
//                                                   height: 22.0,
//                                                   decoration: new BoxDecoration(
//                                                       shape: BoxShape.circle,
//                                                       image: new DecorationImage(
//                                                           fit: BoxFit.cover,
//                                                           image: NetworkImage(
//                                                               set.publisher !=
//                                                                       null
//                                                                   ? set
//                                                                       .publisher!
//                                                                       .avatar
//                                                                   : set
//                                                                       .category!
//                                                                       .publisher
//                                                                       .avatar)))),
//                                             ),
//                                             Text(
//                                                 set.publisher != null
//                                                     ? set.publisher!.name
//                                                     : set.category!.publisher
//                                                         .name,
//                                                 style: style.copyWith(
//                                                     fontSize: 10,
//                                                     fontWeight: FontWeight.bold,
//                                                     color: Provider.of<Auth>(
//                                                                 context,
//                                                                 listen: false)
//                                                             .darkTheme
//                                                         ? LIGHT_GREY
//                                                         : PRIMARY_GREY))
//                                           ],
//                                         )
//                                       : Container()
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         Positioned(
//                             right: 0,
//                             child: LikeButton(
//                                 size: 22,
//                                 circleColor: CircleColor(
//                                     start: Color(0xff00ddff),
//                                     end: Color(0xff0099cc)),
//                                 bubblesColor: BubblesColor(
//                                   dotPrimaryColor: Color(0xff33b5e5),
//                                   dotSecondaryColor: Color(0xff0099cc),
//                                 ),
//                                 likeBuilder: (bool isLiked) {
//                                   return Icon(isLiked ? Icons.close : Icons.add,
//                                       color:
//                                           isLiked ? Colors.red : Colors.grey);
//                                 },
//                                 isLiked:
//                                     currProvider.user!.followedSets.isNotEmpty
//                                         ? currProvider.user!.followedSets
//                                             .map((set) => set!.id)
//                                             .contains(set.id)
//                                         : false,
//                                 onTap: (isLiked) {
//                                   return onFollowSet(context, isLiked, set.id);
//                                 }))
//                       ],
//                     ),
//                   ),
//                 ),
//               )));
//     }

//     Widget getCategoryCard(SetCategory cat) {
//       return GestureDetector(
//           onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     settings: RouteSettings(name: "Category"),
//                     builder: (context) => SubjectsScreen(id: cat.id)),
//               ),
//           child: Container(
//               width: MediaQuery.of(context).size.width,
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
//                 child: Card(
//                   color: Provider.of<Auth>(context, listen: false).darkTheme
//                       ? PRIMARY_DARK
//                       : Colors.white,
//                   elevation: 10,
//                   child: Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: Stack(
//                       children: <Widget>[
//                         Row(
//                           children: <Widget>[
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     width:
//                                         MediaQuery.of(context).size.width - 100,
//                                     child: Text(
//                                       cat.title,
//                                       style: style.copyWith(
//                                           fontWeight: FontWeight.bold,
//                                           color: Provider.of<Auth>(context,
//                                                       listen: false)
//                                                   .darkTheme
//                                               ? Colors.white
//                                               : PRIMARY_DARK),
//                                     ),
//                                   ),
//                                   Container(
//                                       padding: EdgeInsets.symmetric(
//                                           horizontal: 5, vertical: 2),
//                                       decoration: BoxDecoration(
//                                           color: PRIMARY_BLUE.withOpacity(0.1),
//                                           borderRadius:
//                                               BorderRadius.circular(10.0)),
//                                       margin: EdgeInsets.only(top: 12.0),
//                                       child: Text(
//                                         (cat.sets == null
//                                                 ? "0"
//                                                 : cat.sets!.length.toString()) +
//                                             " sets",
//                                         style: TextStyle(
//                                             fontSize: 12,
//                                             color: PRIMARY_BLUE,
//                                             fontWeight: FontWeight.bold),
//                                       )),
//                                   SizedBox(
//                                     height: 20,
//                                   ),
//                                   Text("Code: " + cat.code,
//                                       style: style.copyWith(
//                                           fontSize: 10,
//                                           fontWeight: FontWeight.bold,
//                                           color: Provider.of<Auth>(context,
//                                                       listen: false)
//                                                   .darkTheme
//                                               ? LIGHT_GREY
//                                               : PRIMARY_GREY))
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         Positioned(
//                             right: 0,
//                             child: LikeButton(
//                                 size: 22,
//                                 circleColor: CircleColor(
//                                     start: Color(0xff00ddff),
//                                     end: Color(0xff0099cc)),
//                                 bubblesColor: BubblesColor(
//                                   dotPrimaryColor: Color(0xff33b5e5),
//                                   dotSecondaryColor: Color(0xff0099cc),
//                                 ),
//                                 likeBuilder: (bool isLiked) {
//                                   return Icon(isLiked ? Icons.close : Icons.add,
//                                       color:
//                                           isLiked ? Colors.red : Colors.grey);
//                                 },
//                                 isLiked: currProvider
//                                         .user!.followedSetCategories.isNotEmpty
//                                     ? currProvider.user!.followedSetCategories
//                                         .map((set) => set!.id)
//                                         .contains(cat.id)
//                                     : false,
//                                 onTap: (isLiked) {
//                                   return onFollow(context, isLiked, cat.id);
//                                 }))
//                       ],
//                     ),
//                   ),
//                 ),
//               )));
//     }

//     Widget getCourseCard(Course course) {
//       return GestureDetector(
//           onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     settings: RouteSettings(name: "Course"),
//                     builder: (context) => CoursesScreen(id: course.id)),
//               ),
//           child: Container(
//               width: MediaQuery.of(context).size.width,
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
//                 child: Card(
//                   color: Provider.of<Auth>(context, listen: false).darkTheme
//                       ? PRIMARY_DARK
//                       : Colors.white,
//                   elevation: 10,
//                   child: Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: Stack(
//                       children: <Widget>[
//                         Row(
//                           children: <Widget>[
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     width:
//                                         MediaQuery.of(context).size.width - 100,
//                                     child: Text(
//                                       course.title,
//                                       style: style.copyWith(
//                                           fontWeight: FontWeight.bold,
//                                           color: Provider.of<Auth>(context,
//                                                       listen: false)
//                                                   .darkTheme
//                                               ? Colors.white
//                                               : PRIMARY_DARK),
//                                     ),
//                                   ),
//                                   Container(
//                                       padding: EdgeInsets.symmetric(
//                                           horizontal: 5, vertical: 2),
//                                       decoration: BoxDecoration(
//                                           color: PRIMARY_BLUE.withOpacity(0.1),
//                                           borderRadius:
//                                               BorderRadius.circular(10.0)),
//                                       margin: EdgeInsets.only(top: 12.0),
//                                       child: Text(
//                                         (course.subjects == null
//                                                 ? "0"
//                                                 : course.subjects!.length
//                                                     .toString()) +
//                                             " subjects",
//                                         style: TextStyle(
//                                             fontSize: 12,
//                                             color: PRIMARY_BLUE,
//                                             fontWeight: FontWeight.bold),
//                                       )),
//                                   SizedBox(
//                                     height: 20,
//                                   ),
//                                   Text("Code: " + course.code,
//                                       style: style.copyWith(
//                                           fontSize: 10,
//                                           fontWeight: FontWeight.bold,
//                                           color: Provider.of<Auth>(context,
//                                                       listen: false)
//                                                   .darkTheme
//                                               ? LIGHT_GREY
//                                               : PRIMARY_GREY))
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         Positioned(
//                             right: 0,
//                             child: LikeButton(
//                                 size: 22,
//                                 circleColor: CircleColor(
//                                     start: Color(0xff00ddff),
//                                     end: Color(0xff0099cc)),
//                                 bubblesColor: BubblesColor(
//                                   dotPrimaryColor: Color(0xff33b5e5),
//                                   dotSecondaryColor: Color(0xff0099cc),
//                                 ),
//                                 likeBuilder: (bool isLiked) {
//                                   return Icon(isLiked ? Icons.close : Icons.add,
//                                       color:
//                                           isLiked ? Colors.red : Colors.grey);
//                                 },
//                                 isLiked: currProvider
//                                         .user!.followedCourses.isNotEmpty
//                                     ? currProvider.user!.followedCourses
//                                         .map((set) => set!.id)
//                                         .contains(course.id)
//                                     : false,
//                                 onTap: (isLiked) {
//                                   return onFollowCourse(
//                                       context, isLiked, course.id);
//                                 }))
//                       ],
//                     ),
//                   ),
//                 ),
//               )));
//     }

//     Widget getOrganizationCard(Organization organization) {
//       return GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                   settings: RouteSettings(name: "Organization"),
//                   builder: (context) =>
//                       OrganizationScreen(id: organization.userId)),
//             );
//           },
//           child: Container(
//               width: MediaQuery.of(context).size.width,
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
//                 child: Card(
//                   color: Provider.of<Auth>(context, listen: false).darkTheme
//                       ? PRIMARY_DARK
//                       : Colors.white,
//                   elevation: 10,
//                   child: Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: Stack(
//                       children: <Widget>[
//                         Row(
//                           children: <Widget>[
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     width:
//                                         MediaQuery.of(context).size.width - 100,
//                                     child: Text(
//                                       organization.name,
//                                       style: style.copyWith(
//                                           fontWeight: FontWeight.bold,
//                                           color: Provider.of<Auth>(context,
//                                                       listen: false)
//                                                   .darkTheme
//                                               ? Colors.white
//                                               : PRIMARY_DARK),
//                                     ),
//                                   ),
//                                   Container(
//                                       padding: EdgeInsets.symmetric(
//                                           horizontal: 5, vertical: 2),
//                                       decoration: BoxDecoration(
//                                           color: PRIMARY_BLUE.withOpacity(0.1),
//                                           borderRadius:
//                                               BorderRadius.circular(10.0)),
//                                       margin: EdgeInsets.only(top: 12.0),
//                                       child: Text(
//                                         organization.location,
//                                         style: TextStyle(
//                                             fontSize: 12,
//                                             color: PRIMARY_BLUE,
//                                             fontWeight: FontWeight.bold),
//                                       )),
//                                   SizedBox(
//                                     height: 20,
//                                   ),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: [
//                                       Padding(
//                                         padding:
//                                             const EdgeInsets.only(right: 8.0),
//                                         child: Container(
//                                             width: 22.0,
//                                             height: 22.0,
//                                             decoration: new BoxDecoration(
//                                                 shape: BoxShape.circle,
//                                                 image: new DecorationImage(
//                                                     fit: BoxFit.cover,
//                                                     image: NetworkImage(
//                                                         organization.logo)))),
//                                       ),
//                                       Text(organization.email,
//                                           style: style.copyWith(
//                                               fontSize: 10,
//                                               fontWeight: FontWeight.bold,
//                                               color: Provider.of<Auth>(context,
//                                                           listen: false)
//                                                       .darkTheme
//                                                   ? LIGHT_GREY
//                                                   : PRIMARY_GREY))
//                                     ],
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               )));
//     }

//     Widget getPage(String type) {
//       List dataList = type == "COURSES"
//           ? _filteredCourses
//           : type == "SUBJECTS"
//               ? _filteredCategories
//               : type == "SETS"
//                   ? _filteredSets
//                   : _filteredOrganizations;

//       return _loading
//           ? SizedBox(
//               height: MediaQuery.of(context).size.height,
//               child: Center(
//                   child: CircularProgressIndicator(
//                 color: PRIMARY_BLUE,
//               )),
//             )
//           : (type == "ALL" &&
//                       _filteredCourses.isEmpty &&
//                       _filteredCategories.isEmpty &&
//                       _filteredSets.isEmpty &&
//                       _filteredOrganizations.isEmpty) ||
//                   (type != "ALL" && dataList.isEmpty)
//               ? Container(
//                   height: MediaQuery.of(context).size.height,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         _searchController.text.isEmpty
//                             ? "Enter a topic or keyword"
//                             : "No search results found!",
//                         style: style.copyWith(
//                             color: Provider.of<Auth>(context, listen: false)
//                                     .darkTheme
//                                 ? PRIMARY_GREY
//                                 : LIGHT_GREY),
//                       ),
//                       SizedBox(
//                         height: 15,
//                       ),
//                       Text(
//                         _searchController.text.isEmpty
//                             ? "Hint: The more specific, the better!"
//                             : "Please try again!",
//                         style: style.copyWith(
//                             color: Provider.of<Auth>(context, listen: false)
//                                     .darkTheme
//                                 ? PRIMARY_GREY
//                                 : LIGHT_GREY),
//                       )
//                     ],
//                   ),
//                 )
//               : type != "ALL"
//                   ? SingleChildScrollView(
//                       padding: EdgeInsets.only(bottom: 10),
//                       child: Column(
//                         children: dataList.map((data) {
//                           return type == "COURSES"
//                               ? getCourseCard(data)
//                               : type == "SUBJECTS"
//                                   ? getCategoryCard(data)
//                                   : type == "SETS"
//                                       ? getSetCard(data)
//                                       : getOrganizationCard(data);
//                         }).toList(),
//                       ))
//                   : SingleChildScrollView(
//                       padding: EdgeInsets.only(bottom: 10),
//                       child: Column(
//                         children: [
//                           _filteredCourses.isNotEmpty
//                               ? Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Container(
//                                       width: MediaQuery.of(context).size.width,
//                                       height: 50,
//                                       padding: EdgeInsets.only(
//                                           left: 20, right: 20, top: 20),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           Text("Courses", style: labelStyle),
//                                           Flexible(
//                                             child: TextButton(
//                                                 onPressed: () {
//                                                   setState(() {
//                                                     _loading = true;
//                                                   });
//                                                   _tabController.animateTo(
//                                                       (_tabController.index +
//                                                               1) %
//                                                           2);
//                                                   setState(() {
//                                                     _loading = false;
//                                                   });
//                                                 },
//                                                 style: TextButton.styleFrom(
//                                                     padding: EdgeInsets.zero,
//                                                     textStyle: TextStyle(
//                                                         fontFamily:
//                                                             "Montserrat")),
//                                                 child: Text("View all")),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                     Column(
//                                         children: _filteredCourses
//                                             .take(3)
//                                             .map((data) {
//                                       return getCourseCard(data);
//                                     }).toList())
//                                   ],
//                                 )
//                               : Container(),
//                           _filteredCategories.isNotEmpty
//                               ? Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Container(
//                                       width: MediaQuery.of(context).size.width,
//                                       height: 50,
//                                       padding: EdgeInsets.only(
//                                           left: 20, right: 20, top: 20),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           Text("Subjects", style: labelStyle),
//                                           Flexible(
//                                             child: TextButton(
//                                                 onPressed: () {
//                                                   setState(() {
//                                                     _loading = true;
//                                                   });
//                                                   _tabController.animateTo(
//                                                       (_tabController.index +
//                                                               2) %
//                                                           3);
//                                                   setState(() {
//                                                     _loading = false;
//                                                   });
//                                                 },
//                                                 style: TextButton.styleFrom(
//                                                     padding: EdgeInsets.zero,
//                                                     textStyle: TextStyle(
//                                                         fontFamily:
//                                                             "Montserrat")),
//                                                 child: Text("View all")),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                     Column(
//                                         children: _filteredCategories
//                                             .take(3)
//                                             .map((data) {
//                                       return getCategoryCard(data);
//                                     }).toList())
//                                   ],
//                                 )
//                               : Container(),
//                           _filteredSets.isNotEmpty
//                               ? Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Container(
//                                       width: MediaQuery.of(context).size.width,
//                                       height: 50,
//                                       padding: EdgeInsets.only(
//                                           left: 20, right: 20, top: 20),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           Text("Sets", style: labelStyle),
//                                           Flexible(
//                                             child: TextButton(
//                                                 onPressed: () {
//                                                   setState(() {
//                                                     _loading = true;
//                                                   });
//                                                   _tabController.animateTo(
//                                                       (_tabController.index +
//                                                               3) %
//                                                           4);
//                                                   setState(() {
//                                                     _loading = false;
//                                                   });
//                                                 },
//                                                 style: TextButton.styleFrom(
//                                                     padding: EdgeInsets.zero,
//                                                     textStyle: TextStyle(
//                                                         fontFamily:
//                                                             "Montserrat")),
//                                                 child: Text("View all")),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                     Column(
//                                         children:
//                                             _filteredSets.take(3).map((data) {
//                                       return getSetCard(data);
//                                     }).toList())
//                                   ],
//                                 )
//                               : Container(),
//                           _filteredOrganizations.isNotEmpty
//                               ? Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Container(
//                                       width: MediaQuery.of(context).size.width,
//                                       height: 50,
//                                       padding: EdgeInsets.only(
//                                           left: 20, right: 20, top: 20),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           Text("Companies", style: labelStyle),
//                                           Flexible(
//                                             child: TextButton(
//                                                 onPressed: () {
//                                                   setState(() {
//                                                     _loading = true;
//                                                   });
//                                                   _tabController.animateTo(
//                                                       (_tabController.index +
//                                                               4) %
//                                                           5);
//                                                   setState(() {
//                                                     _loading = false;
//                                                   });
//                                                 },
//                                                 style: TextButton.styleFrom(
//                                                     padding: EdgeInsets.zero,
//                                                     textStyle: TextStyle(
//                                                         fontFamily:
//                                                             "Montserrat")),
//                                                 child: Text("View all")),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                     Column(
//                                         children: _filteredOrganizations
//                                             .take(3)
//                                             .map((data) {
//                                       return getOrganizationCard(data);
//                                     }).toList())
//                                   ],
//                                 )
//                               : Container()
//                         ],
//                       ));
//     }

//     List<Widget> getDataList() {
//       List<Widget> list = [];
//       tabs.forEach((tab) => list.add(getPage(tab.toUpperCase())));
//       return list;
//     }

//     return Scaffold(
//         body: TabBarComponent(
//             forceFit: true,
//             tabs: tabs,
//             dataList: getDataList(),
//             searchField: searchField,
//             tabController: _tabController));
//     // Scaffold(
//     //   body: Container(
//     //       width: MediaQuery.of(context).size.width,
//     //       child: Column(
//     //         children: <Widget>[
//     //           Container(
//     //               color: PRIMARY_BLUE,
//     //               margin: EdgeInsets.only(bottom: 10),
//     //               padding: EdgeInsets.fromLTRB(20, 60, 20, 20),
//     //               child: searchField),
//     //           Expanded(
//     //               child: ),
//     //         ],
//     //       )));
//   }
// }
