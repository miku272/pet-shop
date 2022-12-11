import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../size_config.dart';
import '../app_styles.dart';
import '../widgets/pet_container.dart';

import './pet_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    List<String> dogs = [
      'dog_marly.png',
      'dog_marly02.png',
      'dog_cocoa.png',
      'dog_walt.png',
    ];

    List<String> cats = [
      'cat_alyx.png',
      'cat_brook.png',
      'cat_marly.png',
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: white,
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? SvgPicture.asset('assets/home_selected.svg')
                : SvgPicture.asset('assets/home_unselected.svg'),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1
                ? SvgPicture.asset('assets/cart_selected.svg')
                : SvgPicture.asset('assets/cart_unselected.svg'),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 2
                ? SvgPicture.asset('assets/profile_selected.svg')
                : SvgPicture.asset('assets/profile_unselected.svg'),
            label: 'Profile',
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 10),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: paddingHorizontal),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SvgPicture.asset(
                    'assets/nav_icon.svg',
                    width: 18,
                  ),
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: orange,
                    backgroundImage: NetworkImage(
                        'https://cdn3d.iconscout.com/3d/premium/thumb/man-avatar-6299539-5187871.png'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Image.asset(
                      'assets/images/welcome_message.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    left: SizeConfig.blockSizeHorizontal! * 38,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Text(
                              textAlign: TextAlign.left,
                              'Hello ',
                              style: sourceSansProLight.copyWith(
                                  fontSize:
                                      SizeConfig.blockSizeHorizontal! * 5.5,
                                  color: black),
                            ),
                            Text(
                              textAlign: TextAlign.left,
                              'User 👋',
                              style: sourceSansProMedium.copyWith(
                                  fontSize:
                                      SizeConfig.blockSizeHorizontal! * 5.5,
                                  color: black),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          textAlign: TextAlign.left,
                          'Ready for an amazing and lucky experience 🐈 🐕',
                          style: sourceSansProRegular.copyWith(
                            fontSize: SizeConfig.blockSizeHorizontal! * 3.5,
                            color: black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: paddingHorizontal),
              child: Text(
                'Dogs 🐕',
                style: sourceSansProBold.copyWith(
                  fontSize: SizeConfig.blockSizeHorizontal! * 5.5,
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 170,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dogs.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, PetDetailScreen.routeName);
                  },
                  child: PetContainer(
                    totalLength: dogs.length,
                    index: index,
                    petImage: 'assets/images/${dogs[index]}',
                    petName: 'Charlie',
                    petBreed: 'Marly',
                    postingDate: '17 Nov 2022',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: paddingHorizontal),
              child: Text(
                'Cats 🐈',
                style: sourceSansProBold.copyWith(
                  fontSize: SizeConfig.blockSizeHorizontal! * 5.5,
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 170,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: cats.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, PetDetailScreen.routeName);
                  },
                  child: PetContainer(
                    totalLength: cats.length,
                    index: index,
                    petImage: 'assets/images/${cats[index]}',
                    petName: 'Golden',
                    petBreed: 'Alyx',
                    postingDate: '21 Nov 2022',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
