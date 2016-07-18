/*
 * https://github.com/LoeiFy/CBFimage/blob/master/README.md
 *
 * @version 1.0.1
 * @author LoeiFy@gmail.com
 * http://lorem.in/ | under MIT license
 */

;(function(window, undefined) {

    function CBFimage(element, option) {

        this.option = {
            start:      function() {},
            progress:   function(loaded, total) {},
            complete:   function(image) {}
        }

        if (option && typeof option === 'object') {
            for (var key in option) {
                this.option[key] = option[key]
            }
        }

        if (element && element.getAttribute('src') !== '') {
            this.element = element;

            this.src = element.getAttribute('src');

            var blur = parseInt(element.getAttribute('blur'));
            this.blur = blur > 0 && blur <= 10 ? blur : 0;

            this.loadImg()
        }

    }

    // canvas draw image
    CBFimage.prototype.canvasImg = function(image) {

        this.element.width = image.width;
        this.element.height = image.height;

        var context = this.element.getContext('2d');
        context.drawImage(image, 0, 0)

        if (this.blur > 0) {
            context.globalAlpha = 0.5;

            for (var y = - this.blur; y <= this.blur; y += 2) {
                for (var x = - this.blur; x <= this.blur; x += 2) {
                    context.drawImage(this.element, x + 1, y + 1)
                    if (x >= 0 && y >= 0) {
                        context.drawImage(this.element, - (x - 1), - (y - 1))
                    }
                }
            }
            context.globalAlpha = 1;
        }

    }

    // xhr get image
    CBFimage.prototype.loadImg = function () {

        var that = this;
        this.request = new XMLHttpRequest();

        this.request.onloadstart = function() {
            that.option.start()
        }

        this.request.onprogress = function(e) {
            // may total = 0
            if (parseInt(e.total) !== 0) {
                that.option.progress(e.loaded, e.total)
            }
        }

        this.request.onload = function(e) {
            if (this.status >= 200 && this.status < 400) {
                var image = new Image();
                image.onload = function() {
                    that.canvasImg(image)
                    that.option.complete(image)
                }

                var type = that.src.substr(that.src.lastIndexOf('.') + 1).substr(0, 3);

                if (type == 'jpg') {
                    type = 'jpeg'
                }

                image.src = 'data:image/'+ type +';base64,'+ base64Encode(that.request.responseText);
            }
        }

        this.request.open('GET', that.src, true)
        this.request.overrideMimeType('text/plain; charset=x-user-defined')
        this.request.send(null)

    }

    // abort
    CBFimage.prototype.abort = function() {
        this.request.abort()
    }

    // http://www.philten.com/us-xmlhttprequest-image/
    function base64Encode(inputStr) {

        var b64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=',
            outputStr = '',
            i = 0;
                   
        while (i < inputStr.length) {
            //all three "& 0xff" added below are there to fix a known bug 
            //with bytes returned by xhr.responseText
            var byte1 = inputStr.charCodeAt(i++) & 0xff,
                byte2 = inputStr.charCodeAt(i++) & 0xff,
                byte3 = inputStr.charCodeAt(i++) & 0xff,
                
                enc1 = byte1 >> 2,
                enc2 = ((byte1 & 3) << 4) | (byte2 >> 4),       
                enc3,
                enc4;

                if (isNaN(byte2)) {
                    enc3 = enc4 = 64;
                } else {
                    enc3 = ((byte2 & 15) << 2) | (byte3 >> 6);
                    if (isNaN(byte3)) {
                        enc4 = 64;
                    } else {
                        enc4 = byte3 & 63;
                    }
                }
            outputStr += b64.charAt(enc1) + b64.charAt(enc2) + b64.charAt(enc3) + b64.charAt(enc4);
        }         
        return outputStr

    }

    window.CBFimage = CBFimage;

})(window)
