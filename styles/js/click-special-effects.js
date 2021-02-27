const shape = "heart";
var colorLibrary = new Array("LightBlue", "lightPink","lightGreen", "red", "Yellow", "gold", "Tomato", "Plum");
var flag = false;
var count = 0; // 计数器
var time; // 定时器
var a = document.getElementById("drawing_"+shape);
var l = document.getElementById("left_"+shape);
var r = document.getElementById("right_"+shape);
var vanish = 0;
var vanish_r = 0;
var vanish_l = 0;

document.onmousedown= function(e) {
    if (count != 0) {
        return;
    }
    flag = true;
    clearInterval(time);
    drawingGraphics(e.clientX, e.clientY);
    // printMousePostion(randomColor, e.clientY);
}

function drawingGraphics(x, y) {
    a.style.opacity = 1;
    a.style.left= (x+5)+"px";
    a.style.top = (y-15)+"px";
    let randomColor = Math.floor(Math.random() * 16);
    a.style.backgroundColor = colorLibrary[randomColor];
    l.style.backgroundColor = colorLibrary[randomColor];
    r.style.backgroundColor = colorLibrary[randomColor];
    time = setInterval("heart_move()", 10);
}

function heart_move() {
    if (flag && count <= 50) {
        count++;
        vanish = (a.offsetTop-2);
        a.style.top = vanish + "px";
        a.style.opacity = 1.4 - (count*2)/100;
    }else {
        a.style.opacity = 0;
        flag = false;
        count = 0;
        clearInterval(time);
    }
}


/**
 * 打印鼠标位置
 * @param {*} x mouse X
 * @param {*} y mouse Y
 */
function printMousePostion(x, y) {
    var tag = document.getElementById("mouse_postion");
    var nowPostion = "x:" + x + " y: " +y;
    tag.innerHTML = nowPostion;
}