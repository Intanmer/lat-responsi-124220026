import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  final int id;

  DetailPage({required this.id});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic> articleData = {};

  @override
  void initState() {
    super.initState();
    fetchArticleData();
  }

  Future<void> fetchArticleData() async {
    try {
      final url = Uri.parse('https://api.spaceflightnewsapi.net/v4/articles/${widget.id}/');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          articleData = jsonDecode(response.body);
        });
      } else {
        throw Exception('Failed to load article data');
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
        title: Text(articleData['title'] ?? 'News Detail'),
      ),
      body: articleData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                articleData['image_url'] ?? '',
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
                articleData['title'] ?? '',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                articleData['news_site'] ?? 'Unknown Source',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                'Published at: ${articleData['published_at'] ?? ''}',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(height: 16),
              Text(articleData['summary'] ?? ''),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _launchURL(articleData['url'] ?? '');
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