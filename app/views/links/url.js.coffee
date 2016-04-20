root = global ? this

$('#url_wrapper').html("<%=j render partial: @partial %>")

$.scrollTo('#url_wrapper', 200) if "url" is "<%=j @partial %>"

new root.Tubity.Link