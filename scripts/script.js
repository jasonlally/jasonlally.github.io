$(function(){
  $("a[href^='#']").on('click', function(e) {
    // prevent default anchor click behavior
    e.preventDefault();
    // store hash
    console.log(this);
    var hash = this.hash;
    // animate
    $('html, body').animate({
      scrollTop: $(this.hash).offset().top - 70
    }, 700, function(){
      // when done, add hash to url
      // (default click behaviour)
      window.location.hash = hash;
    });
  });
});