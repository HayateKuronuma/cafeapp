let map;
let marker;

window.initMap = function() {
  let ShopLatLng = new google.maps.LatLng( document.getElementById("lat").value, document.getElementById("lng").value )
  map = new google.maps.Map(document.getElementById('shop-map'), {
    center: ShopLatLng,
    zoom: 16
  });
  myMarker = new google.maps.Marker({
    position: ShopLatLng,
    map: map
  });
}
