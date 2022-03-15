let map;
let myMarker;

window.globalinitMap = function() {
  map = new google.maps.Map(document.getElementById('map'), {
    center: {lat: 35.6896385, lng: 139.689912},
    zoom: 16
  });
  myMarker =  new google.maps.Marker();
}
$(function(){
  const locating = document.querySelector("#status");
  let markerList = [];
  let infoWindow = [];

  $('#search-btn').on('click', function(){
    //現在地取得
    if (navigator.geolocation){
      navigator.geolocation.getCurrentPosition(successCallback, errorCallback, option);
      locating.classList.remove("hidden");
    }else{
      message = 'ご使用中のブラウザは現在地検索に対応しておりません。'
      alert('warning', message);
    }
    //取得成功時
    function successCallback(position) {
      // LatLngに位置座標を代入
      const LatLng = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);

      locating.classList.add("hidden");
      map.setCenter(LatLng);
      myMarker.setMap(null);
      myMarker = new google.maps.Marker({
        position: LatLng,
        map: map,
        icon: "/currenticon.png"
      });
      //ajaxでコントローラーに現在地を渡す
      $.ajax({
        url: "around_shops",
        type: "GET",
        dataType: "html",
        async: true,
        data: {
          lat: position.coords.latitude,
          lng: position.coords.longitude
        },
      }).done(function(result) {
        $('#show_result').html(result);
        infoWindow.forEach(function(infowindow) {
          infowindow.close();
        });
        markerList.forEach(function(marker) {
          marker.setMap(null);
        });
        const len = document.getElementById('len').value;
        for (let i = 0; i < len; i++) {
          let shopname = document.getElementById(`shopname${i}`).innerHTML;
          markerList[i] = new google.maps.Marker({
            map: map,
            label: `${i+1}`,
            position: new google.maps.LatLng( document.getElementById(`lat${i}`).value, document.getElementById(`lng${i}`).value ),
            animation: google.maps.Animation.DROP
          });
          infoWindow[i] = new google.maps.InfoWindow({
            // contentで中身を指定
            content: `<div>${shopname}</div>`
          });
          // markerがクリックされた時、
          markerList[i].addListener("click", function(){
              infoWindow[i].open(map, markerList[i]);
          });
        }
      });
    }
    function errorCallback(error) {
      let err_msg = "";
      switch(error.code)
        {
          case 1:
            err_msg = "位置情報の利用が許可されていません";
            break;
          case 2:
            err_msg = "デバイスの位置が判定できません";
            break;
          case 3:
            err_msg = "タイムアウトしました";
            break;
        }
      document.getElementById("show_result").innerHTML = err_msg;
    }
    let option = {
      enableHighAccuracy: true
    }
  });
});
