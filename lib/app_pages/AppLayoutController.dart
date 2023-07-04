import 'package:flutter/material.dart';
import 'package:fresco/app_pages/CreatePostPage.dart';
import './Notification_page.dart';
import 'HomePage.dart';
import 'OurProfilePage.dart';

// ignore: camel_case_types
class AppLayout extends StatefulWidget {
  final int authorisedUser;
  const AppLayout({Key? key, required this.authorisedUser}) : super(key: key);

  @override
  State<AppLayout> createState() =>
      _AppLayoutState(authorisedUser: authorisedUser);
}

class _AppLayoutState extends State<AppLayout> {
  final int authorisedUser;
  _AppLayoutState({required this.authorisedUser});
  int currentIndex = 0;
  PageController pageController = PageController(initialPage: 0);
  final bottomNavigationBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.home_outlined,
        // color: Color.fromARGB(255, 255, 255, 255),
        size: 28,
      ),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(right: 25.0),
        child: Icon(
          Icons.favorite_outline,
          // color: Color.fromARGB(255, 255, 255, 255),
          size: 28,
        ),
      ),
      label: 'Favourites',
    ),
    const BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(left: 25.0),
        child: Icon(
          Icons.notifications_outlined,
          // color: Color.fromARGB(255, 255, 255, 255),
          size: 28,
        ),
      ),
      label: 'Notifications',
    ),
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.person_outlined,
        // color: Color.fromARGB(255, 255, 255, 255),
        size: 28,
      ),
      label: 'Itz me',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            onPageChanged: (newIndex) {
              setState(() {
                currentIndex = newIndex;
              });
            },
            children: [
              Home_page(
                authorisedUser: authorisedUser,
              ),
              const NotificationPage(),
              const NotificationPage(),
              Our_profile_page(
                authorisedUser: authorisedUser,
              ),
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 50,
        height: 50,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreatePost(
                    authorisedUser: authorisedUser,
                  ),
                ),
              );
            },
            tooltip: 'Click to create',
            elevation: 8.0,
            child: const Icon(
              Icons.add,
              color: Color.fromARGB(255, 65, 53, 133),
              size: 32,
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        color: Theme.of(context).primaryColor.withAlpha(255),
        elevation: 10,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: const Color.fromARGB(255, 41, 27, 121),
          unselectedItemColor: const Color.fromARGB(255, 158, 158, 158),
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor.withAlpha(0),
          currentIndex: currentIndex,
          items: bottomNavigationBarItems,
          onTap: ((index) {
            pageController.animateToPage(index,
                duration: const Duration(milliseconds: 100),
                curve: Curves.ease);
          }),
        ),
      ),
    );
  }
}

// Widget buildBottomSheet(BuildContext context) {
//   return Column(
//     mainAxisSize: MainAxisSize.max,
//     children: <Widget>[
//       const SizedBox(
//         height: 20,
//       ),
//       ListTile(
//         leading: const Icon(Icons.file_copy),
//         title: const Text('Share a Word of knowledge'),
//         onTap: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (context) => const Text_post(),
//             ),
//           );
//         },
//       ),
//       ListTile(
//         leading: const Icon(Icons.photo),
//         title: const Text('Share a Static visual'),
//         onTap: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (context) => const Add_post(),
//             ),
//           );
//         },
//       ),
//       ListTile(
//         leading: const Icon(Icons.videocam),
//         title: const Text('Share a virtual '),
//         onTap: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (context) => const Add_post(),
//             ),
//           );
//         },
//       ),
//       ListTile(
//         leading: const Icon(Icons.music_note),
//         title: const Text('Grab the focus '),
//         onTap: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (context) => const Music_post(),
//             ),
//           );
//         },
//       ),
//     ],
//   );
// }

//class for mp3 files
// class Music_post extends StatefulWidget {
//   const Music_post({super.key});

//   @override
//   State<Music_post> createState() => _Music_postState();
// }

// class _Music_postState extends State<Music_post> {
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold();
//   }
// }

// class for adding images and videos
// class Add_post extends StatefulWidget {
//   const Add_post({super.key});

//   @override
//   State<Add_post> createState() => _Add_postState();
// }

// class _Add_postState extends State<Add_post> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 31, 21, 87),
//         elevation: 0,
//         title: const Padding(
//           padding: EdgeInsets.only(left: 70),
//           child: Text("New post"),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Stack(
//           children: [
//             Container(
//               height: 350,
//               color: const Color.fromARGB(255, 31, 21, 87),
//             ),
//             Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(
//                     left: 30,
//                     right: 30,
//                     top: 10,
//                   ),
//                   child: TextFormField(
//                     keyboardType: TextInputType.visiblePassword,
//                     maxLines: 1,
//                     style: const TextStyle(
//                       color: Color.fromARGB(255, 255, 255, 255),
//                       fontSize: 20,
//                       fontWeight: FontWeight.normal,
//                       fontFamily: "Roboto",
//                     ),
//                     cursorColor: const Color.fromARGB(255, 255, 255, 255),
//                     decoration: const InputDecoration(
//                       labelText: 'Give a title',
//                       labelStyle: TextStyle(
//                         color: Color.fromARGB(255, 255, 255, 255),
//                         fontWeight: FontWeight.w100,
//                         fontFamily: "Roboto",
//                       ),
//                       enabledBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Colors.white,
//                         ),
//                       ),
//                       focusedBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(
//                     left: 30,
//                     right: 30,
//                     top: 5,
//                   ),
//                   child: TextFormField(
//                     keyboardType: TextInputType.visiblePassword,
//                     maxLines: 2,
//                     style: const TextStyle(
//                       color: Color.fromARGB(
//                         255,
//                         255,
//                         255,
//                         255,
//                       ),
//                       fontSize: 20,
//                       fontWeight: FontWeight.normal,
//                       fontFamily: "Roboto",
//                     ),
//                     cursorColor: const Color.fromARGB(
//                       255,
//                       255,
//                       255,
//                       255,
//                     ),
//                     decoration: const InputDecoration(
//                       labelText: 'description',
//                       labelStyle: TextStyle(
//                         color: Color.fromARGB(
//                           255,
//                           255,
//                           255,
//                           255,
//                         ),
//                         fontWeight: FontWeight.w100,
//                         fontFamily: "Roboto",
//                       ),
//                       enabledBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Colors.white,
//                         ),
//                       ),
//                       focusedBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 20, bottom: 20),
//                   child: Center(
//                     child: Card(
//                       elevation: 5,
//                       clipBehavior: Clip.hardEdge,
//                       child: Stack(
//                         children: [
//                           InkWell(
//                             splashColor: Colors.blue.withAlpha(30),
//                             onTap: () {
//                               debugPrint('Card tapped.');
//                             },
//                             child: const SizedBox(
//                               width: 300,
//                               height: 400,
//                               child: Center(child: Text('browse ')),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 250),
//                             child: IconButton(
//                               onPressed: () {},
//                               icon: const Icon(
//                                 Icons.delete,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Center(
//                   child: SizedBox(
//                     width: 300,
//                     child: TextButton(
//                       style: TextButton.styleFrom(
//                         primary: const Color.fromARGB(255, 255, 255, 255),
//                         elevation: 2,
//                         backgroundColor: const Color.fromARGB(255, 31, 21, 87),
//                       ),
//                       child: const Text("Post"),
//                       onPressed: () {/* ... */},
//                     ),
//                   ),
//                 ),
//                 Center(
//                   child: SizedBox(
//                     width: 300,
//                     child: TextButton(
//                       style: TextButton.styleFrom(
//                         primary: const Color.fromARGB(255, 255, 255, 255),
//                         elevation: 2,
//                         backgroundColor: const Color.fromARGB(255, 31, 21, 87),
//                       ),
//                       child: const Text("Cancel"),
//                       onPressed: () {/* ... */},
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class Text_post extends StatefulWidget {
//   const Text_post({super.key});

//   @override
//   State<Text_post> createState() => _Text_postState();
// }

// class _Text_postState extends State<Text_post> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 31, 21, 87),
//         elevation: 0,
//         title: const Padding(
//           padding: EdgeInsets.only(left: 70),
//           child: Text("New post"),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Stack(
//           children: [
//             Container(
//               height: 350,
//               color: const Color.fromARGB(255, 31, 21, 87),
//             ),
//             Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(
//                     left: 30,
//                     right: 30,
//                     top: 10,
//                   ),
//                   child: TextFormField(
//                     keyboardType: TextInputType.visiblePassword,
//                     maxLines: 1,
//                     style: const TextStyle(
//                       color: Color.fromARGB(255, 255, 255, 255),
//                       fontSize: 20,
//                       fontWeight: FontWeight.normal,
//                       fontFamily: "Roboto",
//                     ),
//                     cursorColor: const Color.fromARGB(255, 255, 255, 255),
//                     decoration: const InputDecoration(
//                       labelText: 'Give a title',
//                       labelStyle: TextStyle(
//                         color: Color.fromARGB(255, 255, 255, 255),
//                         fontWeight: FontWeight.w100,
//                         fontFamily: "Roboto",
//                       ),
//                       enabledBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(color: Colors.white),
//                       ),
//                       focusedBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(
//                     left: 30,
//                     right: 30,
//                     top: 10,
//                   ),
//                   child: Card(
//                     child: TextFormField(
//                       keyboardType: TextInputType.visiblePassword,
//                       maxLines: 16,
//                       style: const TextStyle(
//                         color: Color.fromARGB(255, 31, 21, 87),
//                         fontSize: 20,
//                         fontWeight: FontWeight.normal,
//                         fontFamily: "Roboto",
//                       ),
//                       cursorColor: const Color.fromARGB(255, 31, 21, 87),
//                       decoration: const InputDecoration(
//                         labelText: 'description',
//                         labelStyle: TextStyle(
//                           color: Color.fromARGB(255, 31, 21, 87),
//                           fontWeight: FontWeight.w100,
//                           fontFamily: "Roboto",
//                         ),
//                         enabledBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(
//                             color: Color.fromARGB(255, 31, 21, 87),
//                           ),
//                         ),
//                         focusedBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(
//                             color: Color.fromARGB(255, 31, 21, 87),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Center(
//                   child: SizedBox(
//                     width: 300,
//                     child: TextButton(
//                       style: TextButton.styleFrom(
//                         primary: const Color.fromARGB(255, 255, 255, 255),
//                         elevation: 2,
//                         backgroundColor: const Color.fromARGB(255, 31, 21, 87),
//                       ),
//                       child: const Text("Post"),
//                       onPressed: () {/* ... */},
//                     ),
//                   ),
//                 ),
//                 Center(
//                   child: SizedBox(
//                     width: 300,
//                     child: TextButton(
//                       style: TextButton.styleFrom(
//                         primary: const Color.fromARGB(255, 255, 255, 255),
//                         elevation: 2,
//                         backgroundColor: const Color.fromARGB(255, 31, 21, 87),
//                       ),
//                       child: const Text("Cancel"),
//                       onPressed: () {/* ... */},
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
