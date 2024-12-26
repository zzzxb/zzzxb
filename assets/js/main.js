$(document).ready(function() {
  resetImgSize()
})

function resetImgSize() {
  var content = $(".content");
  var images = $(".content img");
  if(images != undefined && images.length > 0){
    for(var i=0; i< images.length;i++){
      var imgWidth = images[i].width;
      var imgHeight = images[i].height;
      if( imgWidth >= content.width() ){
          rate =  content.width() /imgWidth;
          images[i].width = content.width();
          images[i].height= imgHeight * rate;
      }
    }
  }
}