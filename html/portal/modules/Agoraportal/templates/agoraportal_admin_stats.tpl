
<link rel="stylesheet" type="text/css" href="modules/Agoraportal/javascript/calendar/css/jscal2.css" />
<link rel="stylesheet" type="text/css" href="modules/Agoraportal/javascript/calendar/css/border-radius.css" />
<link rel="stylesheet" type="text/css" href="modules/Agoraportal/javascript/calendar/css/agora/agora.css" />
<script type="text/javascript" src="modules/Agoraportal/javascript/calendar/jscal2.js"></script>
<script type="text/javascript" src="modules/Agoraportal/javascript/calendar/lang/ca.js"></script>
<script src="modules/Agoraportal/includes/chartjs/Chart.min.js"></script>

{include file="agoraportal_admin_menu.tpl"}
<h3>{gt text="Estadístiques"}</h3>
<input type="hidden" name="lastorder" id="lastorder" value="clientDNS" />
<input type="hidden" name="order" id="order" value="ASC" />
<div class="panel panel-default">
    <div class="panel-heading">{gt text="Executa sobre:"} <span id="reload"></span></div>
    <div class="panel-body">
        <form class="form-inline" name="statsForm" id="statsForm" action="index.php?module=Agoraportal&type=admin&func=statsGetCSVContent" method="POST">
            <select class="form-control" name="which" id="which" onchange="statsServiceSelected()">
                <option value="all" {if $which neq "selected"}selected="selected"{/if}>{gt text="Tots els centres"}</option>
                <option value="selected" {if $which eq "selected"}selected="selected"{/if}>{gt text="Només els seleccionats"}</option>
            </select>
            <select class="form-control" name="stats_sel" id="stats_sel" onchange="statsServiceSelected()">
                <option value="0">{gt text="Selecciona una estadística"}</option>
                <option value="1" {if $stats_sel eq "1"}selected="selected"{/if} onclick="statsAssistent(1)">{gt text="Estadístiques mensuals Moodle 1.9"}</option>
                <option value="2" {if $stats_sel eq "2"}selected="selected"{/if}>{gt text="Estadístiques setmanals Moodle 1.9"}</option>
                <option value="3" {if $stats_sel eq "3"}selected="selected"{/if}>{gt text="Estadístiques diàries Moodle 1.9"}</option>
                <option value="4" {if $stats_sel eq "4"}selected="selected"{/if}onclick="statsAssistent(1)">{gt text="Estadístiques mensuals Intraweb"}</option>
                <option value="5" {if $stats_sel eq "5"}selected="selected"{/if}onclick="statsAssistent(1)">{gt text="Estadístiques mensuals Moodle 2"}</option>
                <option value="6" {if $stats_sel eq "6"}selected="selected"{/if}>{gt text="Estadístiques setmanals Moodle 2"}</option>
                <option value="7" {if $stats_sel eq "7"}selected="selected"{/if}>{gt text="Estadístiques diàries Moodle 2"}</option>
                <option value="8" {if $stats_sel eq "8"}selected="selected"{/if}>{gt text="Estadístiques diàries Nodes"}</option>
                <option value="9" {if $stats_sel eq "9"}selected="selected"{/if}>{gt text="Estadístiques mensuals Nodes"}</option>
            </select>
            <div class="form-group">
                <label for="date_start">{gt text="Des de: "}</label>
                <input class="form-control" size="8" id="date_start" name="date_start"  value="{$date_start}"/>
                <input class="btn btn-default" type="button" id="from_btn" value="..." />
            </div>
            <div class="form-group">
                <label for="date_stop">{gt text="Fins a: "}</label>
                <input class="form-control" size="8" id="date_stop" name="date_stop" value="{$date_stop}"/>
                <input class="btn btn-default"  type="button" id="to_btn" value="..." />
            </div>
            <button type="button" class="form-control btn btn-primary" onclick="statsGetStatistics(document.forms['statsForm'].which.value,document.forms['statsForm'].stats_sel.value, document.forms['statsForm'].date_start.value, document.forms['statsForm'].date_stop.value, 'clientDNS')">
                <span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span> Mostra</button>
            <!--<input type="button" name="Obté csv" value="Exporta a format .csv" onClick="statsGetCSV(document.statsForm.which.value,document.statsForm.stats_sel.value, document.statsForm.date_start.value, document.statsForm.date_stop.value,'clientDNS')" />
      <a href="index.php?module=Agoraportal&type=admin&func=statsDownloadCSV" >Descarrega l'últim fitxer .csv generat</a>-->
            <input type="hidden" name="clients" />
            <input type="hidden" name="orderby" value="clientDNS" />
            <!-- <a href="index.php?module=Agoraportal&type=admin&func=statsGetCSVContent" onClick="statsGetCSV(document.statsForm.which.value,document.statsForm.stats_sel.value, document.statsForm.date_start.value, document.statsForm.date_stop.value,'clientDNS')" >Descarrega l'últim fitxer .csv generat</a>
            -->
            <input class="form-control btn btn-info" type="submit" name="kk" value="Exporta a format .csv"/>
            <div id="servicesListContent" name="servicesListContent" class="{if $which eq "all"}hidden{/if}">
                 {$statsservicesList}
            </div>
        </form>
    </div>
</div>
<div class="panel panel-default {if $which eq "all"}hidden{/if}" id="cerca">
    <div class="panel-heading">{gt text="Cerca per..."}</div>
    <div class="panel-body">
        <form class="form-inline" name="filterForm" id="filterForm">
            <select class="form-control" name="search" id="search">
                <option {if isset($search) AND $search eq 1}selected{/if} value="1">{gt text="Codi"}</option>
                <option {if isset($search) AND $search eq 2}selected{/if} value="2">{gt text="Nom client"}</option>
            </select>
            <input class="form-control" type="text" value="{$searchText}" name="valueToSearch" id="valueToSearch" size="20" onChange="statsServiceSelected(document.filterForm.search.value,document.filterForm.valueToSearch.value)"/>
            <input class="form-control btn btn-primary" type="button" value="Envia" onClick="statsServiceSelected(document.filterForm.search.value,document.filterForm.valueToSearch.value)" />
            <input class="form-control btn btn-info" type="button" value="Pick Files..." />
        </form>
    </div>
</div>
<div class="panel panel-primary">
    <div class="panel-heading">{gt text="Resultats"}</div>
    <div class="panel-body">
        <div id="resultsContent" name="resultsContent">
            {$resultsContent}
        </div>
    </div>
</div>
<div class="panel panel-info">
    <div class="panel-heading">{gt text="Generar estadístiques"}</div>
    <div class="panel-body">
        <form class="form-inline" name="generateForm" id="generateForm">
            <div class="form-group">
                <label for="date">{gt text="Data: "}</label>
                <input class="form-control" size="8" id="date" name="date"/>
                <input class="form-control btn btn-default" type="button" id="date_btn" value="..." />
            </label>
            <input class="form-control btn btn-info" type="button" value="Genera" onClick="statsGenerateStatistics(document.generateForm.date.value)" />
            <span id="generate" name="generate"></span>
        </form>
    </div>
</div>

<script type="text/javascript">
    var cal1 = Calendar.setup({
        trigger     : "from_btn",
        inputField  : "date_start",
        dateFormat  : "%d/%m/%Y",
        onSelect    : function(cal1) {
            cal1.hide();
            javascript:statsAssistent(2, cal1.selection.get());
        }
    });
    var cal1 = Calendar.setup({
        trigger     : "to_btn",
        inputField  : "date_stop",
        dateFormat  : "%d/%m/%Y",
        onSelect    : function(cal1) {
            cal1.hide();
        }
    });
    var cal1 = Calendar.setup({
        trigger     : "date_btn",
        inputField  : "date",
        dateFormat  : "%d/%m/%Y",
        onSelect    : function(cal1) {
            cal1.hide();
        }
    });
</script>