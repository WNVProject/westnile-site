if (0 == "0") //because javascript comparison types...
{
    function initMap() {
        var locations = [
            ['Hettinger', 46.0013946, -102.6368239],
            ['Valley City #1', 46.9233129, -98.0031547],
            ['Ft. Totten', 47.979999, -98.992901],
            ['Maddock', 47.962509, -99.530133],
            ['Medora', 46.9139028, -103.5243536],
            ['Bottineau', 48.82723, -100.445698],
            ['Bowman', 46.1830618, -103.3949061],
            ['Bowbells', 48.803083, -102.246001],
            ['Bismarck #1', 46.8083268, -100.7837392],
            ['Bismarck #1 W', 46.8083268, -100.7837392],
            ['Casselton', 46.9005292, -97.2111999],
            ['Fargo #1', 46.8771863, -96.7898034],
            ['Langdon', 48.760001, -98.368173],
            ['Oakes', 46.138579, -98.090379],
            ['Crosby', 48.9141998, -103.2949095],
            ['Manning', 47.230005, -102.770349],
            ['New Hradec', 46.999456, -102.884348],
            ['New Rockford', 47.679999, -99.137895],
            ['Linton', 46.2666567, -100.2328916],
            ['Hazelton', 46.484713, -100.279557],
            ['Carrington', 47.44972, -99.126223],
            ['Beach', 46.9180689, -104.0043728],
            ['Grand Forks #1', 47.9252568, -97.0328547],
            ['Elgin', 46.403896, -101.845979],
            ['Carson', 46.417784, -101.564865],
            ['Cooperstown', 47.444438, -98.123984],
            ['Mott', 46.372503, -102.327106],
            ['Steele', 46.854707, -99.915938],
            ['Lake Isabel', 46.820218, -99.752716],
            ['Camp Grassick', 46.809801, -99.747662],
            ['LaMoure', 46.357192, -98.294543],
            ['Langdon', 48.760001, -98.368173],
            ['Napoleon', 46.508313, -99.77122],
            ['Washburn', 47.28916, -101.029035],
            ['Towner', 48.345833, -100.405412],
            ['Ashley', 46.034141, -99.371503],
            ['Watford City', 47.802241, -103.283247],
            ['Deep Wtr Creek', 47.726897, -102.188712],
            ['Beulah', 47.2633403, -101.7779462],
            ['Hazen', 47.294448, -101.622665],
            ['Almont', 46.72528, -101.502644],
            ['Hebron', 46.9324415, -102.0319833],
            ['Mandan #1 PW', 46.82666, -100.889576],
            ['New Town', 47.9808483, -102.4901804],
            ['Stanley', 48.3172, -102.3905],
            ['McVille', 47.763884, -98.177321],
            ['Center', 47.1163849, -101.299594],
            ['Hanover', 47.111388 - 101.42654],
            ['Hannover', 47.111388, -101.42654],
            ['Drayton', 48.571096, -97.177848],
            ['Pembina', 48.966377, -97.243676],
            ['Rugby', 48.368888, -99.996246],
            ['Devils Lake #1', 48.112779, -98.8651202],
            ['Enderlin', 46.623028, -97.601486],
            ['Lisbon', 46.441634, -97.68121],
            ['Mouse River', 48.573686, -100.590456],
            ['Mohall', 48.763356, -101.513217],
            ['Wahpeton #1', 46.265237, -96.605907],
            ['Belcourt', 48.839171, -99.744869],
            ['Rolla', 48.857784, -99.617922],
            ['Forman', 46.107742, -97.636486],
            ['Martin', 47.826667, -100.115131],
            ['Ft. Yates', 46.086941, -100.630127],
            ['Amidon', 46.482233, -103.321847],
            ['Marmath', 46.295006, -103.920762],
            ['Belfield', 46.8852906, -103.1996219],
            ['Dickinson #1', 46.8791756, -102.7896242],
            ['Dickinson #1 City', 46.7959, -102.7896242],
            ['Finely', 47.514158, -97.835925],
            ['Jamestown #1', 46.9105438, -98.7084357],
            ['Cando', 48.486668, -99.209859],
            ['Hillsboro', 47.403868, -97.062031],
            ['Grafton', 48.412211, -97.410634],
            ['Minot #1', 48.2405652, -101.3129402],
            ['Minot Oak Park(1)', 48.2405652, -101.3129402],
            ['Minot Chirs (3)', 48.2329668, -101.3755906],
            ['Harvey', 47.769723, -99.935404],
            ['Tioga', 48.397244, -102.938238],
            ['Willison #1', 48.1469683, -103.6179745]
        ];
        var bismarck = { lat: 46.8083, lng: -100.7837 }
        var bounds = new google.maps.LatLngBounds();
        var map = new google.maps.Map(document.getElementById('map'), { zoom: 7, center: bismarck, zoomControl: true, scaleControl: false, disableDefaultUI: true });
        for (var i = 0; i < locations.length; i++) {
            var position = new google.maps.LatLng(locations[i][1], locations[i][2]);
            bounds.extend(position);
            var marker = new google.maps.Marker({ position: position, map: map, title: locations[i][0] });
        }

        map.data.loadGeoJson('http://polygons.openstreetmap.fr/get_geojson.py?id=1740282&params=0');

        /*
        var bermudaTriangleCoords = [
            new google.maps.LatLng(45.934161, -104.043698),
            new google.maps.LatLng(49.0000, -104.091361),
            new google.maps.LatLng(49.0000, -97.259560),
            new google.maps.LatLng(45.963506, -96.558843)
            

            
        ];    
        var bermudaTriangle = new google.maps.Polygon({
            paths: bermudaTriangleCoords,
            strokeColor: '#FF0000',
            strokeOpacity: 0.8,
            strokeWeight: 2,
            fillColor: '#FF0000',
            fillOpacity: 0.35
        });
        bermudaTriangle.setMap(map);*/
    }
}