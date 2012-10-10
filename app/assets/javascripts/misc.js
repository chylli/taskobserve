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
    f = function() {
        $('#more_activities').slideUp('slow');
        get_real_data("#activity_container",url);
    }
    return f
}
