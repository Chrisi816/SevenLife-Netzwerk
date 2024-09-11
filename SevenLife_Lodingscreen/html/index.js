var muted = false

$("document").ready(function () {
    var interval = setInterval(function() {
        $(".textmitte").fadeOut(900)
        $(".textmitte").fadeIn(900)
    }, 6000)
})
document.body.onkeyup = function(e){
    if(e.keyCode == 32){
        if (muted === false) {
            var vid = document.getElementById("video1");
            vid.muted = true;
            muted = true
        } else if (muted === true) {
            var vid = document.getElementById("video1");
            vid.muted = false; 
            muted = false
        }
       
    }
} 