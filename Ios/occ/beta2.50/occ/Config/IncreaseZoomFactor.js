//<meta name="viewport"content="minimum-scale=0.6; maximum-scale=5;  initial-scale=1; user-scalable=yes; width=640">
function increaseMaxZoomFactor() {
    var element = document.createElement('meta');
    element.name = "viewport";
    element.content = "minimum-scale=0.1; maximum-scale=10";
    var head = document.getElementsByTagName('head')[0];
    head.appendChild(element);
}