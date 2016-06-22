var bridge;

$(function() {

    function setupWebViewJavascriptBridge(callback) {
        if (window.WebViewJavascriptBridge) {
            return callback(WebViewJavascriptBridge);
        }
        if (window.WVJBCallbacks) {
            return window.WVJBCallbacks.push(callback);
        }
        window.WVJBCallbacks = [callback];
        var WVJBIframe = document.createElement('iframe');
        WVJBIframe.style.display = 'none';
        WVJBIframe.src = 'wvjbscheme://__BRIDGE_LOADED__';
        document.documentElement.appendChild(WVJBIframe);
        setTimeout(function() {
            document.documentElement.removeChild(WVJBIframe)
        }, 0)
    }

    setupWebViewJavascriptBridge(function(bridge) {

        self.bridge = bridge

        bridge.registerHandler('getUserInfos', function(data, responseCallback) {

            setFontSize(data.bodySize, data.titleSize, data.subtitleSize)

            responseCallback({})
        })
    })

    function setFontSize(body, title, subtitle) {
        var body_section = document.getElementById('body_section');
        body_section.style.fontSize = body;

        var subtitle = document.getElementById('subtitle');
        subtitle.style.fontSize = subtitle;

        var title = document.getElementById('title');
        title.style.fontSize = title;
    }

    $("img").lazyload({
        load: {
            call: function(a, b, c) {
                bridge.callHandler('testObjcCallback', {
                    'height': document.body.offsetHeight,
                }, function(response) {})
            }
        }
    });


    $("#body_section img").click(function() {
        var index = $("img").index(this);
        bridge.callHandler('clickImageIndex', {
            'index': index,
        }, function(response) {})
    });

    $("#video iframe").width($(window).width() - 40);
    $("#video iframe").height($("#video iframe").width() * 3 / 5);


    $("#video iframe").addClass("center-block");

});
