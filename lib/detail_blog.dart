import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class DetailBlogPage extends StatefulWidget {
  final int id;

  DetailBlogPage({required this.id});

  @override
  _DetailBlogPageState createState() => _DetailBlogPageState();
}

class _DetailBlogPageState extends State<DetailBlogPage> {
  Map<String, dynamic> blogData = {};

  @override
  void initState() {
    super.initState();
    fetchBlogData();
  }

  Future<void> fetchBlogData() async {
    try {
      final url = Uri.parse('https://api.spaceflightnewsapi.net/v4/blogs/${widget.id}/');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          blogData = jsonDecode(response.body);
        });
      } else {
        throw Exception('Failed to load blog data');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(blogData['title'] ?? 'Blog Detail'),
      ),
      body: blogData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                blogData['image_url'] ?? '',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: Icon(Icons.broken_image, size: 50),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              Text(
                blogData['title'] ?? '',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                blogData['news_site'] ?? 'Unknown Source',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                'Published at: ${blogData['published_at'] ?? ''}',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(height: 16),
              Text(blogData['summary'] ?? ''),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _launchURL(blogData['url'] ?? '');
                },
                child: Text('Read More'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}