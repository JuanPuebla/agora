{include file="agoraportal_admin_menu.tpl"}

<script>
    function submitform() {
        clientsList(document.filterForm.search.value, document.filterForm.valueToSearch.value, 1);
        return false;
    }
</script>

<h3>{gt text="Llista de clients"}</h3>
<div class="panel panel-default">
    <div class="panel-heading">{gt text="Filtra"} <span id="reload"></span></div>
    <div class="panel-body">
        <form class="form-inline form-inline-multiline" name="filterForm" id="filterForm" onsubmit="submitform(); return false;">
            <div class="form-group">
                <label for="valueToSearch">{gt text="Cerca per..."}</label>&nbsp;
                <select class="form-control" name="search" id="search" onchange="submitform();">
                    <option value="0"></option>
                    <option {if $search eq 1}selected{/if} value="1">{gt text="Codi"}</option>
                    <option {if $search eq 2}selected{/if} value="2">{gt text="Nom client"}</option>
                </select>
                <input class="form-control" type="text" name="valueToSearch" id="valueToSearch" size="20" value="{$searchText}"  onchange="submitform();"/>
            </div>
            <button type="submit" class="btn btn-primary"><span class="glyphicon glyphicon-filter" aria-hidden="true"></span> Filtra</button>
        </form>
    </div>
</div>
<a class="btn btn-default" href="{modurl modname='Agoraportal' type='admin' func='newClient'}">
<span class="glyphicon glyphicon-plus" aria-hidden="true"></span>Afegeix un client nou</a>
<div id="clientsListContent" name="clientsListContent">
    {$clientsListContent}
</div>
