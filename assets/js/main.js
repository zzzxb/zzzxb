var timer = null;

$(document).ready(function() {
  resetImgSize();
  toTop();
});

$(window).resize(function() {
    resetImgSize();
});

function resetImgSize() {
  var content = $(".content");
  var images = $(".content img");
  if(images != undefined && images.length > 0){
    for(var i=0; i< images.length;i++){
      var imgWidth = images[i].width;
      var imgHeight = images[i].height;
      var cw = content.width()
      cw = Math.min(cw, $(window).width())
      rate =  content.width() /imgWidth;
      images[i].width = content.width();
      images[i].height= imgHeight * rate;
    }
  }
}

window.addEventListener('scroll', function() {
  var scrollPosition = document.documentElement.scrollTop;
  var windowHeight = window.innerHeight;
  var tv = windowHeight * 0.3;
  if(scrollPosition > tv) {
    var op = (scrollPosition - tv) * 0.001;
    $('.top').css({
      'display': 'block',
      'opacity': Math.min(op, 1)
    });
  }else {
    $('.top').css({
      'display': 'none',
    });
  }
})

function toTop() {
  $('.top').mousedown(function() {
    if(timer === null) pressToTop();
  });

  $('.top').on('touchstart', function() {
    if(timer === null) pressToTop(); 
  });
};

function pressToTop() {
    var speed = 1;
    timer = setInterval(function() {
      speed *= 1.3;
      var scrollPosition = document.documentElement.scrollTop;
      window.scrollTo(0, scrollPosition - speed);
      if(scrollPosition <= 10) {
        clearInterval(timer);
        timer = null;
      }
    }, 1);
}