
function tileInfoSidebar(name, terrain, affinity, height, threat){
    hideSidebar()
    document.getElementById("infoDisplay").classList.remove("hidden");
    document.getElementById("infoList").innerHTML="<li>Name: " + name + "</li><li>Terrain: " + terrain + "</li><li>Affinity: " + affinity + "</li><li>Height: " + height + "</li><li>Threat: " + threat + "</li>";
}

function generateSidebar(name, terrain, affinity, height, threat){
    hideSidebar()
    document.getElementById("generate").classList.remove("hidden");
}

function hideSidebar(){
    document.getElementById("infoDisplay").classList.add("hidden");
    document.getElementById("generate").classList.add("hidden");
}