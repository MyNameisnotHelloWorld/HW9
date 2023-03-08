let current_table;

function clean_data(){
    document.getElementById("the_form").reset();
    var content = document.getElementById("location");
    content.style.display = "block"
    var table = document.querySelector("#event_table")
    var details = document.querySelector("#detail_events")
    var e = document.querySelector("#expand")
    if(details){
        details.remove()
    }
    if(table){
        table.remove()
    }
    if(e){
        e.remove()
    }
    

    test = 1
}

function getValue(){
    var check = document.getElementById("auto_detect_location");
    
    var content = document.getElementById("location").value;
    const word = document.getElementById("keyword").value;
    var mile = document.getElementById("distance").value;
    var keyword = word.toString().replace(/\s/g, '+')
    var catgory = document.getElementById("category").value;
    if (check.checked){
        content = "auto-detected"
    }else{
        if(content!=""){
            var content = content.toString().replace(/\s/g, '+')
        }
    }
    if (catgory == "Music"){
        catgory = "KZFzniwnSyZfZ7v7nJ"
        
    }else if(catgory == "Sports"){
        catgory = "KZFzniwnSyZfZ7v7nE"
        
    }else if(catgory == "Arts" || catgory == "Theatre"){
        catgory = "KZFzniwnSyZfZ7v7na"
        
    }else if(catgory == "Film"){
        catgory = "KZFzniwnSyZfZ7v7nn"
        
    }else if(catgory == "Miscellaneous"){
        catgory = "KZFzniwnSyZfZ7v7n1"
        
    }

    $.ajax({
        type:"GET", 
        url:"/"+String(keyword)+"/"+String(mile)+"/"+String(catgory)+"/"+String(content), 
        async:false, 
        dataType: "json", 
        success: function(data) { 
            // Parse the response.
            // Do other things.
            the_data = data
            if(data.hasOwnProperty('_embedded')){
                var info = data_process(data)
                createTable(info)
            }else{
                const mytable = document.getElementById("mytable")
                const table = document.createElement("table")
                table.id = "event_table"
                table.style.width = "700px"
                table.style.height = "50px"
                const tr = document.createElement("tr")
                const th = document.createElement("th")
                th.style.color = "red"
                th.style.backgroundColor = "white"
                th.textContent = "No Record found"
                tr.appendChild(th)
                table.append(tr)
                mytable.appendChild(table)
            }
            
            
         },
        error: function(xhr, status, err) {
            console.log("wrong")
            console.log(err)
            
         }
    });

    
}
var event_reverse = true
var genre_reverse = true
var venues_reverse = true
var test = 1
function sorting(n){
    
    console.log("sorting")
    var reverse = null;
    var lst = Array()
    
    var info = data_process(the_data)
    for(let i = 0;i < Object.keys(info).length; i++){
        var d = info[i]
        lst.push(d)
    }
    
    //https://www.freecodecamp.org/news/how-to-sort-alphabetically-in-javascript/
    lst = lst.sort(function(param1,param2){
        if(n == 0){
            reverse = event_reverse
            return sorting_details(param1.event,param2.event,event_reverse)
        }else if (n==1){
            reverse = genre_reverse
            return sorting_details(param1.genre,param2.genre,genre_reverse)
        }else{
            reverse = venues_reverse
            return sorting_details(param1.venues,param2.venues,venues_reverse)
        }
    })
    reverse = !reverse
    if(n==0){
        event_reverse = reverse
    }else if(n==1){
        genre_reverse = reverse
    }else{
        venues_reverse = reverse
    }
    console.log(lst)
    const old_table = document.getElementById("event_table")
    
    createTable(lst)
   
}

function sorting_details(param1,param2,reverse){
    if(param1 < param2){
        if(reverse){
            return -1;
        }else{
            return 1;
        }
    }
    if(param1 > param2){
        if(reverse){
            return 1;
        }else{
            return -1;
        }
    }
    return 0;
}



function createTable(info){
    
    console.log(Object.keys(info).length)
    const table = document.createElement("table")
    const head = document.createElement("thead")
    table.style.width = "70%"
    table.style.height = "5%"
    table.id = "event_table"
    const topic_tr = document.createElement("tr")
    topic_tr.style.height = "15"

    const date_th = document.createElement("th")
    date_th.textContent = "Date"
    date_th.style.width = "15%"
    date_th.style.height = "20"
    topic_tr.append(date_th)

    const icon_th = document.createElement("th")
    icon_th.textContent = "Icon"
    icon_th.style.width = "15%"
    icon_th.style.height = "20"
    topic_tr.append(icon_th)

    var event_th = document.createElement("th")
    event_th.textContent = "Event"
    event_th.style.width = "40%"
    event_th.style.height = "20"
    event_th.classList.add("sorted_th")
    event_th.setAttribute("onclick","sorting(0)")
    topic_tr.append(event_th)

    const genre_th = document.createElement("th")
    genre_th.textContent = "Genre"
    genre_th.style.width = "10%"
    genre_th.style.height = "20"
    genre_th.classList.add("sorted_th")
    
    genre_th.setAttribute("onclick","sorting(1)")
    topic_tr.append(genre_th)

    const venue_th = document.createElement("th")
    venue_th.textContent = "Venue"
    venue_th.style.width = "20%"
    venue_th.style.height = "20"
    venue_th.setAttribute("onclick","sorting(2)")
    venue_th.classList.add("sorted_th")
    topic_tr.append(venue_th)

    head.append(topic_tr)
    table.append(head)

    current_table = info;
    for(let i = 0;i < Object.keys(info).length; i++){
        
        var local = info[i]["local"]
        var imageUrl = info[i]["images"]
        var event_name = info[i]["event"]
        var genre = info[i]["genre"]
        var venues_name = info[i]["venues"]

        const data_tr = document.createElement("tr")

        const date_data = document.createElement("td")
        date_data.textContent = local
        date_data.style.width = "15%"
        data_tr.appendChild(date_data)
                    
        const icon_data = document.createElement("th")
        const image = document.createElement("img")
        image.width = 40
        image.height = 40
        image.src = imageUrl.toString()
        icon_data.appendChild(image)
        data_tr.appendChild(icon_data)

        const event_data = document.createElement("th")
        const text = document.createElement("span")
        text.style.cursor = "pointer"
        text.textContent = event_name
        text.classList.add("event_color")
        event_data.style.width = "15%"
        var event_detail = "info("+i+")"
        text.setAttribute("onclick",event_detail)
        event_data.appendChild(text)
        data_tr.appendChild(event_data)

        const genre_data = document.createElement("th")
        genre_data.textContent = genre
        genre_data.style.width = "15%"
        data_tr.appendChild(genre_data)

        const venues_data = document.createElement("th")
        venues_data.textContent = venues_name
        venues_data.style.width = "15%"
        data_tr.appendChild(venues_data)

        table.append(data_tr)
    }
    const mytable = document.getElementById("mytable")
    table.style.width = "700px"
    table.style.height = "50px"
    const origintable = document.querySelector("#event_table")
    if(origintable){
        origintable.replaceWith(table);
    }else{
        mytable.appendChild(table)
    }
                
}


function info(i){
    console.log(i)
    console.log(current_table[i])
    const my_details = document.querySelector("#detail_events")
    const expand = document.querySelector("#expand")
    const details_div = document.createElement("div")
    details_div.classList.add("details_border")
    const my_table = document.getElementById("event_table")
    if(my_details){
        console.log("hhhh")
        const new_details = create_info(i)
        const new_expand = the_expand(i)
        my_details.replaceWith(new_details)
        expand.replaceWith(new_expand)
    }else{
        console.log("qqqqq")
        const new_details = create_info(i)
        const my_expand = the_expand(i)
        my_table.insertAdjacentElement('afterend',new_details)
        new_details.insertAdjacentElement("afterend",my_expand)
    }
    
}

function the_expand(i){
    const expand_button = document.createElement("div")
    const text_container = document.createElement("div")
    text_container.style.display = "flex"
    //text_container.style.transform = "translate(-50%, -50%)"
    text_container.style.margin = "auto"

    expand_button.id = "expand"
    expand_button.classList.add("expand_button")
    const show_venue = document.createElement("span")
    
    show_venue.style.fontSize = "50px"
    show_venue.style.display = "flex"
    show_venue.style.margin = "auto"
    show_venue.style.color = "rgba( 255, 255, 255, .5)"
    show_venue.innerText = "Show Venues Details"

    text_container.appendChild(show_venue)


    expand_button.appendChild(text_container)

    const arrow_container = document.createElement("div")
    arrow_container.style.display = "flex"
    arrow_container.style.transform = "translate(-50%, -50%)"
    arrow_container.style.margin = "auto"
    const arrow = document.createElement("span")
    arrow.classList.add("down")
    arrow_container.appendChild(arrow)
    expand_button.appendChild(arrow_container)

    expand_button.style.cursor = "pointer"

    expand_button.setAttribute("onclick","show_loc("+i+")")
    return expand_button
}

function show_loc(i){
    const myexpand = document.querySelector("#expand")
    var more_details = current_table[i]["more_details"][0]
   
    
    var lat = more_details["location"]["latitude"]
    var log = more_details["location"]["longitude"]

    var google_addr =  more_details['address']['line1']+", "+more_details["city"]["name"]+", "+more_details["state"]["stateCode"]+" "+more_details["postalCode"]
    google_addr = encodeURIComponent(google_addr)
    

    const loc_and_venue = document.createElement("div")
    loc_and_venue.id = "expand"
    loc_and_venue.classList.add("loc_border")
    const venue_title = document.createElement("span")
    venue_title.classList.add("details_title")
    venue_title.style.marginBottom = "7px"
    venue_title.innerText = current_table[i]["venues"]
    venue_title.style.textDecoration = "underline"

    loc_and_venue.appendChild(venue_title)

    
    if(more_details.hasOwnProperty("images")){
        var next = more_details["images"][0]
        if(next.hasOwnProperty("url")){
            var source = next["url"]
            var small_icon = document.createElement("img")
            small_icon.src = source
            small_icon.style.display = "flex"
            small_icon.style.marginLeft = "47%"
            small_icon.setAttribute("width","70px")
            small_icon.setAttribute("height","70px")
            loc_and_venue.appendChild(small_icon)
        }
        
    } 

    var the_hor = document.createElement("div")
    the_hor.classList.add("horizontal_info")

    var verti = document.createElement("div")
    verti.style.flexDirection = "column"
    verti.style.marginTop = "10px"
    verti.style.marginLeft = "80px"

    var context = document.createElement("div")
    context.style.flexDirection = "row"
    context.style.display = "flex"

    var addressTitle = document.createElement("div")
    addressTitle.style.fontWeight = "900"
    addressTitle.innerText = "Address: "
    
    context.appendChild(addressTitle)
    var addressTitle = document.createElement("div")
    addressTitle.innerText = more_details['address']['line1']
    context.appendChild(addressTitle)

    verti.appendChild(context)

    var addressTitle = document.createElement("div")
    addressTitle.innerText = more_details["city"]["name"]+", "+more_details["state"]["stateCode"]
    addressTitle.style.display = "flex"
    addressTitle.style.marginLeft = "62px"
    verti.appendChild(addressTitle)

    var addressTitle = document.createElement("div")
    addressTitle.style.display = "flex"
    addressTitle.style.marginLeft = "62px"
    addressTitle.innerText = more_details["postalCode"]
    verti.appendChild(addressTitle)

    var google_map = document.createElement("a")
    google_map.style.display = "flex"
    google_map.setAttribute("href","https://www.google.com/maps/search/?api=1&query="+google_addr)
    google_map.innerText = "Open in Google Map"
    google_map.style.fontSize = "20px"
    verti.appendChild(google_map)
    the_hor.appendChild(verti)

    var my_sep = document.createElement("div")
    my_sep.style.display = "flex"
    var sep = document.createElement("div")
    sep.classList.add("big_sep")
    my_sep.appendChild(sep)
    the_hor.appendChild(my_sep)

    var future = document.createElement("div")
    future.style.display = "flex"
    var future_event = document.createElement("a")
    future_event.style.display = "flex"
    future_event.style.marginLeft = "150px"
    future_event.setAttribute("href",current_table[i]["more_details"][0]["url"])
    future_event.innerText = "More events at this venue"
    future_event.style.fontSize = "20px"
    future.appendChild(future_event)
    the_hor.appendChild(future)

    loc_and_venue.appendChild(the_hor)

    myexpand.replaceWith(loc_and_venue)

}

function create_info(i){
        const details_table = document.createElement("div")
        details_table.classList.add("details_border")
        details_table.id = "detail_events"

        const title = document.createElement("span")
        title.classList.add("details_title")
        title.style.marginBottom = "40px"
        title.style.color = "white"
        title.innerText = current_table[i]["event"]
        details_table.appendChild(title)

        //----------------------
        const alignment = document.createElement("div")
        alignment.classList.add("horizontal_info")

        const details_div = document.createElement("div")
        details_div.classList.add("vertical")
        //-------------------------
        const info_date = document.createElement("span")
        info_date.classList.add("details_info")
        info_date.innerText = "Date"
        details_div.appendChild(info_date)

        const infor_date = document.createElement("span")
        infor_date.classList.add("text_align")
        infor_date.style.fontSize = "20px"
        infor_date.style.color = "white"
        infor_date.innerText = current_table[i]["local"]
        var horizontal = document.createElement("span")
        horizontal.classList.add("horizontal_info")

        var map_image = document.createElement("img")
        map_image.classList.add("text_align")
        map_image.width = "200px"
        map_image.height = "200px"
        map_image.src = current_table[i]["seat_map"]
        horizontal.appendChild(infor_date)
        horizontal.appendChild(map_image)
        details_div.appendChild(horizontal)

        //-------------------------------------------------

        const team = current_table[i]["artist"]
        const team_url = current_table[i]["artist_url"]
        var horizontal = document.createElement("span")
        horizontal.classList.add("horizontal_info")
        if(team_url.length != 0){
            const info_team = document.createElement("span")
            info_team.classList.add("details_info")
            info_team.innerText = "Artist/Team"
            details_div.appendChild(info_team)
            for(let j=0;j<team_url.length;j++){
                var infor_team = document.createElement("a")
                infor_team.classList.add("text_align")
                infor_team.style.color = "blue"
                infor_team.style.fontSize = '15px'
                infor_team.style.textDecoration = 'none'
                infor_team.innerText = team[j]
                infor_team.setAttribute('href',team_url[j])
                
                horizontal.appendChild(infor_team)
                if (j!=team_url.length-1){
                    var spe = document.createElement("a")
                    spe.classList.add("split")
                    spe.innerText = "|"
                    horizontal.appendChild(spe)
                }
            }
            details_div.appendChild(horizontal)
        }
        
        
        
        
        //----------------------------------------------

        const info_venue = document.createElement("span")
        info_venue.classList.add("details_info")
        info_venue.innerText = "Venue"
        details_div.appendChild(info_venue)

        const infor_venue = document.createElement("span")
        infor_venue.classList.add("text_align")
        infor_venue.innerText = current_table[i]["venues"]
        infor_venue.style.fontSize = "20px"
        infor_venue.style.color = "white"
        var horizontal = document.createElement("span")
        horizontal.classList.add("horizontal_info")
        horizontal.appendChild(infor_venue)

        details_div.appendChild(horizontal)
        //----------------------------------------------------
        

        const allclass = current_table[i]["class"]
        var horizontal = document.createElement("span")
        horizontal.classList.add("horizontal_info")
        if (allclass.length != 0){
            const info_genre = document.createElement("span")
            info_genre.classList.add("details_info")
            info_genre.innerText = "Genres"
            details_div.appendChild(info_genre)
            for(let j=0;j<allclass.length;j++){
                var infor_class = document.createElement("span")
                infor_class.classList.add("text_align")
                infor_class.style.color = "white"
                infor_class.style.fontSize = '20px'
                infor_class.innerText = allclass[j]
                
                horizontal.appendChild(infor_class)
                if (j!=allclass.length-1){
                    var spe = document.createElement("a")
                    spe.classList.add("split")
                    spe.innerText = "|"
                    horizontal.appendChild(spe)
                }
            }
            details_div.appendChild(horizontal)
        }
        
        

        //-------------------------------------------------------
        const info_Price = document.createElement("span")
        info_Price.classList.add("details_info")
        info_Price.innerText = "Price Ranges"
        details_div.appendChild(info_Price)

        const infor_range = document.createElement("span")
        infor_range.classList.add("text_align")
        infor_range.innerText = current_table[i]["price_range"]
        infor_range.style.fontSize = "20px"
        infor_range.style.color = "white"
        var horizontal = document.createElement("span")
        horizontal.classList.add("horizontal_info")
        horizontal.appendChild(infor_range)
        details_div.appendChild(horizontal)

        //--------------------------------------------
        const info_status = document.createElement("span")
        info_status.classList.add("details_info")
        info_status.innerText = "Ticket Status"
        details_div.appendChild(info_status)
        var horizontal = document.createElement("span")

        var out_symbol = document.createElement("div")
        out_symbol.classList.add("status_symbol")
        
        var ticket_status = current_table[i]["ticket_status"]
        if (ticket_status == "onsale" | ticket_status == "on sale"){
            out_symbol.style.background = "green"
        }else if(ticket_status == "offsale" | ticket_status == "off sale"){
            out_symbol.style.background = "red"
        }
        else if(ticket_status == "canceled"){
            out_symbol.style.background = "black"
        }else if(ticket_status == "postponed"){
            out_symbol.style.background = "orange"
        }else if(ticket_status == "rescheduled"){
            out_symbol.style.background = "orange"
        }

        var alert = document.createElement("a")
        alert.classList.add("status_info")
        alert.innerText = ticket_status

        out_symbol.appendChild(alert)

        horizontal.appendChild(out_symbol)

        details_div.appendChild(horizontal)


        //---------------------------------------------------
        const info_buy = document.createElement("span")
        info_buy.classList.add("details_info")
        info_buy.innerText = "Buy Ticket At:"
        details_div.appendChild(info_buy)

        var infor_buy = document.createElement("a")
        infor_buy.classList.add("text_align")
        infor_buy.style.color = "blue"
        infor_buy.style.fontSize = '15px'
        infor_buy.style.textDecoration = 'none'
        infor_buy.innerText = "Ticketmaster"
        infor_buy.setAttribute('href',current_table[i]["buy_ticket"])

        var horizontal = document.createElement("span")
        horizontal.classList.add("horizontal_info")
        horizontal.appendChild(infor_buy)

        details_div.appendChild(horizontal)

        alignment.appendChild(details_div)

        if(current_table[i]["seat_map"]!=""){
            const theMap = document.createElement("img")
            theMap.src = current_table[i]["seat_map"]
            theMap.classList.add("map_pic")
            theMap.setAttribute("width","500px")
            theMap.setAttribute("height","500px")
            theMap.style.marginLeft = "150px"
            alignment.appendChild(theMap)
        }
        

        details_table.appendChild(alignment)

        return details_table
}

function data_process(data){
    var dict = {}
    console.log(data)
    var info = data['_embedded']['events']
    for(let i = 0;i < info.length; i++){
        console.log(i)
        var details = {}
        var dates = info[i]["dates"]
        if (!dates["start"]["dateTBA"] & !dates["start"]["dateTBA"]){
            var starts = dates["start"]
            var localT = ""
            var localD = ""
            if (starts.hasOwnProperty('localTime')){
                localT = starts['localTime']
            }
            if(starts.hasOwnProperty('localDate')){
                localD = starts['localDate']
            }
            var local = localD + " "+localT
        }else if(dates["start"]["dateTBA"]){
            var local = "TBA"
        }else{
            var local = "TBD"
        }
        details["local"] = local
        var imageUrl = info[i]["images"][0]["url"]
        details["images"] = imageUrl
        details["ticket_status"] = dates["status"]["code"]
        if (info[i].hasOwnProperty("seatmap")){
            details["seat_map"] = info[i]["seatmap"]["staticUrl"]
        }else{
            details["seat_map"] = ""
        }
        if(info[i].hasOwnProperty("priceRanges")== false){
            details["price_range"] = ""
        }else{
            var min_price = ""
            if(info[i]["priceRanges"][0].hasOwnProperty("min") ){
                min_price = info[i]["priceRanges"][0]["min"]
            }
            var max_price = ""
            if(info[i]["priceRanges"][0].hasOwnProperty("max")){
                max_price = info[i]["priceRanges"][0]["max"]
            }
            if(min_price!="" & max_price!=""){
                details["price_range"] = min_price+" - "+max_price + " "+info[i]["priceRanges"][0]["currency"]
            }else if(min_price!=""){
                details["price_range"] = min_price+ " "+info[i]["priceRanges"][0]["currency"]
            }else if(max_price!=""){
                details["price_range"] = max_price+" "+info[i]["priceRanges"][0]["currency"]
            }else{
                details["price_range"] = ""
            }
        }
        
        
        var classifications1 = info[i]["classifications"][0]
        var venue_type = []
        if(classifications1.hasOwnProperty("subGenre")){
            if (classifications1["subGenre"]["name"]!="Undefined"){
                venue_type.push(classifications1["subGenre"]["name"])
            }
        }

        if(classifications1.hasOwnProperty("genre")){
            if (classifications1["genre"]["name"]!="Undefined"){
                venue_type.push(classifications1["genre"]["name"])
            }
        }

        if(classifications1.hasOwnProperty("segment")){
            if (classifications1["segment"]["name"]!="Undefined"){
                venue_type.push(classifications1["segment"]["name"])
            }
        }

        if(classifications1.hasOwnProperty("subType")){
            if (classifications1["subType"]["name"]!="Undefined"){
                venue_type.push(classifications1["subType"]["name"])
            }
        }

        if(classifications1.hasOwnProperty("type")){
            if (classifications1["type"]["name"]!="Undefined"){
                venue_type.push(classifications1["type"]["name"])
            }
        }
        details["class"] = venue_type
        
        var event_name = info[i]["name"]
        var links = info[i]["_embedded"]
        var attr = links["attractions"]
        
        var artist = []
        var artist_url = []
        if(attr!=undefined){
            for(let j =0;j < attr.length; j++){
                artist.push(attr[j]["name"])
                artist_url.push(attr[j]["url"])
            }
        }
        details["artist"] = artist
        details["artist_url"] = artist_url
        details["buy_ticket"] = info[i]["url"]
        var venues = links["venues"]
        details["more_details"] = venues
        var genre = info[i]["classifications"][0]["segment"]["name"]
        if (venues[0].hasOwnProperty('name')){
            var venues_name = venues[0]['name']
        }else{
            var venues_name = ""
        }
        
        details["venues"] = venues_name
        details["event"] = event_name
        details["genre"] = genre

        dict[i] = details
    }
    return dict

}