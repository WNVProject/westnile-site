function initMap() {
    var mapOptions = { zoom: 7, center: new google.maps.LatLng(46.8083, -100.7837) };
    var map = new google.maps.Map(
        document.getElementById('map'), mapOptions);
}
