function SetCharacters(characters){
    var parent = document.getElementById("characterSelect");

    $.each(characters, function(index, element){
        var element_c = document.createElement("div");
        element_c.setAttribute("class", "character-select s-" + index);
        parent.appendChild(element_c);

        var title = document.createElement("h4");
        title.setAttribute("class", "title");
        title.innerHTML = "Profile #" + index;
        element_c.appendChild(title);



        var select = document.createElement("button");
        select.innerHTML = "Select";
        select.setAttribute("class", "btn-select");
        select.setAttribute("id", "btn-select-"+index);
        element_c.appendChild(select)
    });

}


$(document).ready(function(){
    $("button").click(function(){
        $(this).innerHTML = "ok"
    });
});