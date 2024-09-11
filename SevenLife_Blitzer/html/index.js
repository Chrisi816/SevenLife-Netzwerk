$("document").ready(function () { 
    $(".redbackground").hide()
    window.addEventListener('message', function(event) {
        var msg = event.data;
        var audio = null 
        if (event.data.type === "MakeBiltzer"){
           $(".redbackground").show()
           if (audio != null) {
            audio.pause()
           }
           audio = new Howl({src: ["makeblitzer.ogg"]})
           audio.volume(0.5)
           audio.play()
           
           setTimeout(() => {  $(".redbackground").hide() }, 100);
        }
    })
})