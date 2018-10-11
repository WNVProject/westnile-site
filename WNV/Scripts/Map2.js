if (0 == "0") //because javascript comparison types...
{
    function initMap()
    {
        var bismarck = { lat: 46.8083, lng: -100.7837 }
        var map = new google.maps.Map(document.getElementById('map'), { zoom: 7, center: bismarck });
        var marker = new google.maps.Marker({ position: bismark, map: map, title: "Fuck JavaScript" })

        marker.setMap(map);
    }
}