$(function() {

    $("#body_section img").click(function() {
        var index = $("img").index(this);
        window.webkit.messageHandlers.JSBridge.postMessage({
            "type": 1,
            "index": index
        });
    })

    $('img').load(function() {
        // 加载完成
        window.webkit.messageHandlers.JSBridge.postMessage({
            "type": 0
        });
    });



    $("#video iframe").width($(window).width() - 40);
    $("#video iframe").height($("#video iframe").width() * 3 / 5);
    $("#video iframe").addClass("center-block");
});
