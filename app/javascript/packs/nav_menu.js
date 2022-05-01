$(".openbtn").on('click', function () {
  $(this).toggleClass('active-nav');
  $("#g-nav").toggleClass('panelactive');
});
$("#g-nav a").on('click', function () {
  $(".openbtn").removeClass('active-nav');
  $("#g-nav").removeClass('panelactive');
});