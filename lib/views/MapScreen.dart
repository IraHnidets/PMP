import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'GroupScheduleScreen.dart';
class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  LatLng? _currentLocation;
  Location _location = Location();
  int _currentNavIndex = 4;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    final locData = await _location.getLocation();
    setState(() {
      _currentLocation = LatLng(locData.latitude!, locData.longitude!);
    });
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentNavIndex,
      onTap: (index) {
        setState(() {
          _currentNavIndex = index;
        });

        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/NotesCategoriesScreen');
            break;
          case 1:
            Navigator.pushNamed(context, '/RemindersScreen');
            break;
          case 2:
            _navigateToGroupSchedule(context, "ПЗ-31");
            break;
          case 3:
            Navigator.pushNamed(context, '/CalendarScreen');
            break;
          case 4:
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.note), label: "Нотатки"),
        BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Нагадування"),
        BottomNavigationBarItem(icon: Icon(Icons.schedule), label: "Розклад"),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Календар"),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: "Карта"),
      ],
      selectedItemColor: Colors.purple,
      unselectedItemColor: Colors.black,
      type: BottomNavigationBarType.fixed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Карта"),
        backgroundColor: const Color(0xFF526FAA),
      ),
      body: _currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentLocation!,
          zoom: 16,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (controller) => _mapController = controller,
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }
  void _navigateToGroupSchedule(BuildContext context, String groupName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupScheduleScreen(groupName: groupName),
      ),
    );
  }
}
