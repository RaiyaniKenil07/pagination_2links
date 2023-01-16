import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scrollController = ScrollController();
  bool isLoadingMore = false;
  List posts = [];
  int num = 0;

  void initState() {
    scrollController.addListener(_scrollListener);
    super.initState();
    fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
      ),
      body: ListView.builder(
          physics: BouncingScrollPhysics(),
          controller: scrollController,
          itemCount: isLoadingMore ? posts.length + 1 : posts.length,
          itemBuilder: (context, index) {
            if (index < posts.length) {
              final post = posts[index];
              final title = post["id"];
              // final description = post["title"];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0.5),
                child: Card(
                  color: Colors.white,
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text("${index + 1}"),
                    ),
                    title: Text(
                      "$title",
                      maxLines: 1,
                    ),
                    // subtitle: Text(
                    //   "$description",
                    //   maxLines: 1,
                    // ),
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Future<void> fetchPosts() async {
    final url = "https://billberryinfosys.com/Demo/${num}.json";
    final uri = Uri.parse(url);
    final responce = await http.get(uri);
    if (responce.statusCode == 200) {
      final json = jsonDecode(responce.body) as List;
      setState(() {
        num++;
        posts = posts + json;
      });
    } else {
      print("Unexpected responce");
    }
  }

  Future<void> _scrollListener() async {
    if (isLoadingMore) return;
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      num = num + 1;
      fetchPosts();
      setState(() {
        isLoadingMore = true;
      });
      fetchPosts();
      setState(() {
        isLoadingMore = false;
      });
    }
  }
}
