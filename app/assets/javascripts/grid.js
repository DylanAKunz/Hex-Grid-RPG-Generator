
function tileInfo(name, terrain, affinity, height, threat){
    document.getElementById("infoDisplay").classList.remove("hidden")
    document.getElementById("infoList").innerHTML="<li>" + name + "</li><li>" + terrain + "</li><li>" + affinity + "</li><li>" + height + "</li><li>" + threat + "</li>"
}