
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiRoutes {

  static final String baseURL = "https://pixabay.com/api/";

  static final String apiKey = dotenv.env['PIXABAY_API_KEY']!;


  static final images = "";
}