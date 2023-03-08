var http = require("http");
const parser  = require("body-parser");
var geohash = require('geohash');

const path = require('path');
var address = 'http://localhost:8080'
const express = require("express");
const app = express();
app.use(express.static('static'));
app.use(parser.json());


app.listen(3000, function () {
  console.log('server running');
});

app.get('/',function(req,res) {
  res.sendFile(path.join(__dirname+'/static/main.html'));
});

app.get("/:keyword/:mile/:category/:loc",function(req,res) {
  var kw = req.params.keyword
  var mile = req.params.mile
  var category = req.params.category
  var loc = req.params.loc
  var category;
  var ticketApi;
  var my_loc_url

  url = "https://app.ticketmaster.com/discovery/v2/events.json?apikey=AY0kAQMXhyKSSYEQbDhYyT0IHkCH9tgE&"
  if(req.params.category == "Default"){
      ticketApi = 'keyword='+kw+'&radius='+mile+'&unit=miles'
  }  else{
      ticketApi = 'keyword='+kw+'&segmentId='+category+'&radius='+mile+'&unit=miles'
  }
  var noplace = false
  var my_loc_url;
  var info;
  var geo;
  var param;
  if(loc=="auto-detected"){
      my_loc_url = "https://ipinfo.io/64.136.145.103?token=1055805e13f2a6"
      info = requests.get(my_loc_url).json()
      loc = info["loc"].split(",")
      geo = geohash.encode(float(loc[0]),float(loc[1]),7)
      param += "&geoPoint="+geo
  }else{


  }
  url = url + ticketApi
  if (noplace){
    res.send(jsonify('{}'))
  }else{
    res.send(jsonify(requests.get(url).json()))
  }     
})
