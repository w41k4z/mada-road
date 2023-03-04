let map = L.map('map').setView([-19, 47], 5);
L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19,
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
}).addTo(map);

let rn2_style = {
    "color": "red",
    "weight": 5,
    "opacity": 0.65
};
let rn4_style = {
    "color": "blue",
    "weight": 5,
    "opacity": 0.65
};
let rn7_style = {
    "color": "green",
    "weight": 5,
    "opacity": 0.65
};
let degradation_style = {
    "color": "black",
    "weight": 10,
    "opacity": 0.75
};
