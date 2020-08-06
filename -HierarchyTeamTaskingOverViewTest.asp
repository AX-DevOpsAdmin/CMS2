<!DOCTYPE HTML>
<html>
<head>

<title>Team Hierarchy</title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script type="text/javascript" src="calendar.js"></script>
<style>
body {width:99%; margin:0; padding:0; border:0; line-height:1;} 

</style>
<script type="text/javascript" src="Includes/jquery-1.10.2.js"></script>
<script type="text/javascript">

function calendarTable() {
    $("#caltable").delegate('td', 'mouseover mouseleave', function (e) {
        if (e.type == 'mouseover') {
            $(this).parent().addClass("rowhover");
            $("colgroup").eq($(this).index()).addClass("colhover");
        }
        else {
            $(this).parent().removeClass("rowhover");
            $("colgroup").eq($(this).index()).removeClass("colhover");
        }
    });
}

</script>
</head>
<body >

         


<div class="row">
    <div class="col-sm-12">
        <table id="caltable" class=" tableCal table-striped">
            <colgroup></colgroup>
           
                <tr>
                    <th><a onclick="">&lt;&lt;</a> <span>&gt;&gt;</a></th>
                    
                        <th class="@d.dClass">
                            <div>@d.date.Day</div>
                            <div id="dayofWeek">
                                
                            </div>
                        </th>
                
                </tr>
            </thead>
            <tbody>
                
                    <tr><td class="@d.dClass"> <div> test</div></td><td class="@d.dClass"> <div> test</div></td><td class="@d.dClass"> <div> test</div></td></tr>
             <tr><td class="@d.dClass"> <div> test</div></td><td class="@d.dClass"> <div> test</div></td><td class="@d.dClass"> <div> test</div></td></tr>
             <tr><td class="@d.dClass"> <div> test</div></td><td class="@d.dClass"> <div> test</div></td><td class="@d.dClass"> <div> test</div></td></tr>
             
            </tbody>
        </table>
    </div>
</div>


</body>
</html>

