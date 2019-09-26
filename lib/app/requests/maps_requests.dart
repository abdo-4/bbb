import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
const apiKey = "AIzaSyBhDflq5iJrXIcKpeq0IzLQPQpOboX91lY";

class MapsServices{
    Future<String> getRouteCoordinates(LatLng l1, LatLng l2)async{
      String url = "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$apiKey";
      http.Response response = await http.get(url);
      Map values = jsonDecode(response.body);
      return values["routes"][0]["overview_polyline"]["points"];
    }
}

class OSMServices {
 
  String url;
	List<String> route;

  static final String CAR = "motorcar";
	static final String BICYCLE = "bicycle";
	static final String WALKING = "foot";

	/**
	 * 
	 * @param from
	 *            where the user is
	 * @param to
	 *            where the user wants to go
	 * @param vehicle
	 *            one of the vehicle constants (CAR, BICYCLE or WALKING)
	 * @param context
	 *            reference to caller (used to get the name and version
	 *            number of the program to add the user agent in network ops)
	 * @return an ArrayList containing Strings of the format "latE6,longE6" (E6
	 *         means times by 1000000 so we are dealing with ints, not floats as
	 *         floats run slowly on phones)
	 */

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * org.opensatnav.services.Router#getRoute(org.andnav.osm.util.GeoPoint,
	 * org.andnav.osm.util.GeoPoint, java.lang.String, android.content.Context)
	 */
	Future<dynamic> getRoute(LatLng from, LatLng to, String vehicle) async{
		route = new List<String>();
    if(vehicle == null) vehicle = CAR;
		try {
			url = "www.yournavigation.org/api/1.0/gosmore.php?" + "flat=" + from.latitude.toString()
					+ "&" + "flon=" + from.longitude.toString() + "&" + "tlat="
					+ to.latitude.toString() + "&" + "tlon=" + to.longitude.toString() + "&" + "v="
					+ vehicle + "&" + "fast=1&layer=mapnik";
          http.Response response = await http.get(url);
          var values = jsonDecode(response.body);
          print("############ Routes: " + values.toString());
          return values;
		} catch (e) {
			print("### getRoute: Error:" + e.toString());
		}
  }


/*
query line segment points list:

http://www.yournavigation.org/?

flat=43.783789012276&flon=23.962432754029&wlat=43.777654065181&wlon=23.949043166627&tlat=43.783603114038&tlon=23.944923293579&v=motorcar&fast=1&layer=mapnik

http://www.yournavigation.org/api/1.0/gosmore.php?

format=geojson&flat=43.783789012276&flon=23.962432754029&wlat=43.783789012276&wlon=23.962432754029&wlat=43.786616143407&wlon=23.949944388856&wlat=43.788041276628&wlon=23.94485

8920563&wlat=43.78630632734&wlon=23.944880378236&wlat=43.785175485072&wlon=23.944987666596&tlat=43.783603114038&tlon=23.944923293579&instructions=1&v=motorcar&fast=1&layer=mapnik

geojson output:

{
  "type": "LineString",
  "crs": {
    "type": "name",
    "properties": {
      "name": "urn:ogc:def:crs:OGC:1.3:CRS84"
    }
  },
  "coordinates":
  [
[23.962294, 43.783758]
,[23.962081, 43.784251]
,[23.961903, 43.7847]
,[23.96172, 43.785079]
,[23.96033, 43.785255]
,[23.95899, 43.785423]
,[23.957635, 43.785582]
,[23.956295, 43.785739]
,[23.954981, 43.785904]
,[23.953653, 43.78607]
,[23.95101, 43.786399]
,[23.949422, 43.786577]
,[23.948818, 43.786659]
,[23.946707, 43.787162]
,[23.944743, 43.787612]
,[23.944369, 43.787703]
,[23.943982, 43.787854]
,[23.94366, 43.788119]
,[23.94418, 43.786906]
,[23.944556, 43.785937]
,[23.944695, 43.785374]
,[23.944681, 43.784849]
,[23.944653, 43.784171]
,[23.944663, 43.783536]
,[23.944895, 43.783502]
  ],  "properties": {
    "distance": "2.20977",
    "description": "Continue on Danube Bike Trail. Follow the road for 1.0 mi.<br>Turn sharp left. Follow the road for 0.3 mi.<br>Turn left. Follow the road for 0.0 mi.<br>Continue on fini.<br>",
    "traveltime": "297"
    }
}


*/

	Future<List<String>> getRouteBySegment(List<LatLng> points, String vehicle) async{
		route = new List<String>();
    if(vehicle == null) vehicle = CAR;
		try {
      String pointStr= "format=geojson&flat=" + points[0].latitude.toString() + "&flon=" + points[0].longitude.toString();
      for(int i =1;i< points.length -1;i++){
        pointStr+= "&wlat=" + points[i].latitude.toString() + "&wlon=" + points[i].longitude.toString();
      }
      pointStr+= "&tlat=" + points[points.length -1].latitude.toString() + "&tlon=" + points[points.length -1].longitude.toString();

			url = "www.yournavigation.org/api/1.0/gosmore.php?" + pointStr + "&" + "v="
					+ vehicle + "&instructions=1&fast=1&layer=mapnik";
          http.Response response = await http.get(url);
          List<String> values = jsonDecode(response.body);
          print("############ getRouteBySegment: " + values.toString());
          return values;
		} catch (e) {
			print("### getRouteBySegment: Error:" + e.toString());
		}
  }

//import 'package:geolocator/geolocator.dart';
//double distanceInMeters = await Geolocator().distanceBetween(52.2165157, 6.9437819, 52.3546274, 4.8285838);


}