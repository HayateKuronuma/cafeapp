  const locating = document.querySelector(".status");
  let map
  let marker = [];
  let infoWindow = [];
  window.globalinitMap = function() {
    map = new google.maps.Map(document.getElementById('map'), {
      center: {lat: 35.6896385, lng: 139.689912},
      zoom: 16
    });
  }
  $(function(){
    $('.serchbtn').on('click', function(){
      // LatLngに位置座標を代入
      if (navigator.geolocation){
        navigator.geolocation.getCurrentPosition(successCallback, errorCallback, option);
        locating.textContent = "Locating…";
      }else{
        message = 'ご使用中のブラウザは現在地検索に対応しておりません。'
        alert('warning', message)
      }
      function successCallback(position) {
        // LatLngに位置座標を代入
        LatLng = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
        locating.textContent = "";
        map.setCenter(LatLng);
        marker = new google.maps.Marker({
          position: LatLng,
          map: map
        });
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
          const len = document.getElementById('len').value
          for (let i = 0; i < len; i++) {
            marker[i] = new google.maps.Marker({
              map: map,
              position: new google.maps.LatLng( document.getElementById(`lat${i}`).value, document.getElementById(`lng${i}`).value )
            });
          }
        });
      }
      function option(){
        enableHighAccuracy: true;
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
    });
  });
