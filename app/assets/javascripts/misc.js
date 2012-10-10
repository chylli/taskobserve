get_real_data = function(item,url) {

    replace_data = function(data) {
        change = function(){
            $(item).html(data);
            
            active_modal(); //regiester modal

            $(item).slideDown('slow'); 
        }
        $(item).slideUp('slow',change); 
    }
    $.get(url,{},replace_data)
}

function more_activities(url) {
    item = '#activity_container';

    slide1 = function() {
        $(item).html('Loading...');        
        $(item).slideDown('slow',slide2);
    }

    slide2 = function() {
        get_real_data(item,url)
    }

    f = function() {
        $('#more_activities').slideUp('slow');
        $(item).slideUp('slow',slide1);

    }
    return f
}
