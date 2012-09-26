# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

get_real_data = (item,url) ->
        replace_data = (data) ->
                change = ->
                        $(item).html(data)
                        active_modal() # register modal
                        $(item).slideDown('slow')
                        
                $(item).slideUp('slow',change)
        $.get(url,{},replace_data)

window.get_real_data = get_real_data

