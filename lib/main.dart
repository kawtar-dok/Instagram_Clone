import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/providers/user_provider.dart';
import 'package:instagram_clone_flutter/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone_flutter/responsive/responsive_layout.dart';
import 'package:instagram_clone_flutter/responsive/web_screen_layout.dart';
import 'package:instagram_clone_flutter/screens/login_screen.dart';
import 'package:instagram_clone_flutter/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  //3- Setting Up Firebase
  WidgetsFlutterBinding.ensureInitialized();
  //this is for the web app
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDAwsUgCqPEziSfBEUQLdcmcNvhNSeoURU',
        appId: '1:520660730900:web:e5c0b1c0f4be13ca479301',
        messagingSenderId: '520660730900',
        projectId: 'instagram-flutter-clone-b225c',
        storageBucket: "instagram-flutter-clone-b225c.appspot.com",
      ),
    );
  } else {
    //this for android wla ios ki initializihom
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram by kali',
        //m adding the theme to my app i used a dark theme its gonnaa give us all the features built by flutter in dark
        //so it will use all the colors of dark
        theme: ThemeData.dark().copyWith(
          //i did turn the scaffoolbgcolor to mobile bg color
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),

        //1- Setup & Theming the App :
        // why scaffold i did wrap the home with a scaffold so that we see a good output and not a container type output
        //my app has turned a fully dark mode
        //i wanna change the color like i wannt it to look a bit diffrent
        //i did grab the color for my app

        //2 - Building Responsive Layout Widget
        //create a responsive layout whenever our screen size of the browser extends a certain width it should display you know a web screen  layout
        //and if not then it will display a mobile screen layout
        //home: Scaffold(body: Text('Lets build instagram')),
        //   home: const ResponsiveLayout(
        //  webScreenLayout: WebScreenLayout(),
        //mobileScreenLayout: MobileScreenLayout(),

        //6-Persisting Auth State : approch d authentication with firebase
        //so here i must store a unique identifier in the app memory
        //then again get it from the app memory then check if the user with the uid is
        //authenticated or not so we have a lot of requette joggling
        //but lucky us we have firebase that provides us with multiple methods
        //so here i did used a stram builder cuz firebase return that
        home: StreamBuilder(
          //to check if the authentication state iis there or not
          //this authstatchange works ghere mnin the useer signed up wla signed out
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            //yep hna kan testew
            if (snapshot.connectionState == ConnectionState.active) {
              // Checking if the snapshot has any data or not
              if (snapshot.hasData) {
                // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
                //there is no datathe connection dart but no data
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            // hna mazal ma derna hta connection
            // means connection to future hasnt been made yet
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
