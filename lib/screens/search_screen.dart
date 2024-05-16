import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel/utils/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({Key? key}) : super(key: key);

//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   final TextEditingController searchController = TextEditingController();
//   bool isShowUser = false;

//   @override
//   void dispose() {
//     super.dispose();
//     searchController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: mobileBackgroundColor,
//         title: TextFormField(
//           controller: searchController,
//           decoration: const InputDecoration(labelText: 'Search for a user'),
//           onFieldSubmitted: (String _) {
//             setState(() {
//               isShowUser = true;
//             });
//           },
//         ),
//       ),
//       body: isShowUser
//           ? FutureBuilder<QuerySnapshot>(
//               future: FirebaseFirestore.instance
//                   .collection('users')
//                   .where(
//                     'username',
//                     isGreaterThanOrEqualTo: searchController.text,
//                   )
//                   .where(
//                     'username',
//                     isLessThan: searchController.text + 'z',
//                   )
//                   .get(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }

//                 final docs = snapshot.data!.docs;

//                 return ListView.builder(
//                   itemCount: docs.length,
//                   itemBuilder: (context, index) {
//                     final data = docs[index].data() as Map<String, dynamic>;

//                     return ListTile(
//                       leading: CircleAvatar(
//                         backgroundImage: data.containsKey('photoUrl') && data['photoUrl'] != null
//                             ? NetworkImage(data['photoUrl'])
//                             : null,
//                         child: data.containsKey('photoUrl') && data['photoUrl'] != null
//                             ? null
//                             : Text(
//                                 data['username'] != null && data['username'].isNotEmpty
//                                     ? data['username'][0].toUpperCase()
//                                     : '?',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                         backgroundColor: Colors.grey,
//                       ),
//                       title: Text(data['username'] ?? 'No username'),
//                     );
//                   },
//                 );
//               },
//             )
//           : FutureBuilder<QuerySnapshot>(
//               future: FirebaseFirestore.instance.collection('posts').get(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 return MasonryGridView.count(
//                   crossAxisCount: 3,
//                   itemCount: snapshot.data!.docs.length,
//                   itemBuilder: (context, index) => Image.network(
//                     snapshot.data!.docs[index]['postUrl'],
//                     fit: BoxFit.cover,
//                   ),
//                   mainAxisSpacing: 8,
//                   crossAxisSpacing: 8,
//                 );
//               },
//             ),
//     );
//   }
// }


class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUser = false;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      if (searchController.text.isEmpty) {
        setState(() {
          isShowUser = false;
        });
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: searchController,
          decoration: const InputDecoration(labelText: 'Search for a user'),
          onFieldSubmitted: (String _) {
            setState(() {
              isShowUser = searchController.text.isNotEmpty;
            });
          },
        ),
      ),
      body: isShowUser
          ? FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where(
                    'username',
                    isGreaterThanOrEqualTo: searchController.text,
                  )
                  .where(
                    'username',
                    isLessThan: searchController.text + 'z',
                  )
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: data.containsKey('photoUrl') && data['photoUrl'] != null
                            ? NetworkImage(data['photoUrl'])
                            : null,
                        child: data.containsKey('photoUrl') && data['photoUrl'] != null
                            ? null
                            : Text(
                                data['username'] != null && data['username'].isNotEmpty
                                    ? data['username'][0].toUpperCase()
                                    : '?',
                                style: const TextStyle(color: Colors.white),
                              ),
                        backgroundColor: Colors.grey,
                      ),
                      title: Text(data['username'] ?? 'No username'),
                    );
                  },
                );
              },
            )
          : FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                return MasonryGridView.count(
                  crossAxisCount: 3,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => Image.network(
                    snapshot.data!.docs[index]['postUrl'],
                    fit: BoxFit.cover,
                  ),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                );
              },
            ),
    );
  }
}



