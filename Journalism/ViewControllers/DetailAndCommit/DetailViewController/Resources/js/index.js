$(function() {

    var setFontSize = function() {
        var body_section = document.getElementById('body_section');
        body_section.style.fontSize = bodyS;

        var subtitle = document.getElementById('subtitle');
        subtitle.style.fontSize = subtitleS;

        var title = document.getElementById('title');
        title.style.fontSize = titleS;
    }

    $("img").lazyload({
      skip_invisible : false,
        threshold: 100,
        effect: "fadeIn",event : "click",
        load: {
            call: function() {
                window.webkit.messageHandlers.JSBridge.postMessage({"type": 1})
            }
        }
    });

    $("#body_section img").click(function() {
        var index = $("img").index(this);
        window.webkit.messageHandlers.JSBridge.postMessage({
            "type": 1,
            "data": index
        });
    })


    $("#video iframe").width($(window).width() - 40);
    $("#video iframe").height($("#video iframe").width() * 3 / 5);
    $("#video iframe").addClass("center-block");
});
