{include file="agoraportal_admin_menu.tpl"}

{if $execOper}
<script>
    window.onload = function() {
        operations_execute({/literal}{$execOper}{literal});
    };
</script>
{/if}

<script>
    function submitform() {
        servicesList(document.filterForm.service.value,
                    document.filterForm.stateFilter.value,
                    document.filterForm.search.value,
                    document.filterForm.valueToSearch.value,
                    document.filterForm.order.value,
                    1,
                    document.filterForm.rpp.value);
        return false;
    }
</script>

<h3>{gt text="Llista de serveis dels clients"}</h3>
<div class="panel panel-default">
    <div class="panel-heading">{gt text="Filtra"} <span id="reload"></span></div>
    <div class="panel-body">
        <form class="form-inline form-inline-multiline" name="filterForm" id="filterForm" onSubmit="submitform(); return false;">
            <div class="form-group">
                <label for="service">{gt text="Servei"}</label>&nbsp;
                <select class="form-control" name="service" id="service" onChange="submitform();">
                    <option value="0">{gt text="Tots els serveis"}</option>
                    {foreach item=serviceItem from=$services}
                    <option {if $serviceItem.serviceId eq $service}selected{/if} value="{$serviceItem.serviceId}">{$serviceItem.serviceName}</option>
                    {/foreach}
                </select>
            </div>
            <div class="form-group">
                <label for="stateFilter">{gt text="Estat"}</label>&nbsp;
                <select class="form-control" name="stateFilter" id="stateFilter" onChange="submitform();">
                    <option {if $stateFilter eq -1}selected{/if} value="-1">{gt text="Tots els estats"}</option>
                    <option {if $stateFilter eq 0}selected{/if} value="0">{gt text="Per revisar"}</option>
                    <option {if $stateFilter eq 1}selected{/if} value="1">{gt text="Actiu"}</option>
                    <option {if $stateFilter eq -2}selected{/if} value="-2">{gt text="Denegat"}</option>
                    <option {if $stateFilter eq -3}selected{/if} value="-3">{gt text="Donat de baixa"}</option>
                    <option {if $stateFilter eq -4}selected{/if} value="-4">{gt text="Desactivat"}</option>
                </select>
            </div>
            <div class="form-group">
                <label for="service">{gt text="Cerca per..."}</label>&nbsp;
                <select class="form-control" name="search" id="search" onChange="submitform();">
                    <option value="0"></option>
                    <option {if $search eq 1}selected{/if} value="1">{gt text="Codi"}</option>
                    <option {if $search eq 2}selected{/if} value="2">{gt text="Nom client"}</option>
                    <option {if $search eq 3}selected{/if} value="3">{gt text="Municipi"}</option>
                </select>
                <input class="form-control" type="text" value="{$searchText}" name="valueToSearch" id="valueToSearch" size="20"/>
            </div>
            <div class="form-group">
                <label for="order">{gt text="Ordena per..."}</label>&nbsp;
                <select class="form-control" name="order" id="order" onChange="submitform();">
                    <option {if $order eq 1}selected{/if} value="1">{gt text="Nom client"}</option>
                    <option {if $order eq 2}selected{/if} value="2">{gt text="Data d'edició"}</option>
                </select>
            </div>
            <div class="form-group">
                <label for="rpp">{gt text="Nombre de registres..."}</label>&nbsp;
                <select class="form-control" name="rpp" id="rpp" onChange="submitform();">
                    <option {if $rpp eq 15}selected{/if} value="15">15</option>
                    <option {if $rpp eq 30}selected{/if} value="30">30</option>
                    <option {if $rpp eq 50}selected{/if} value="50">50</option>
                    <option {if $rpp eq 100}selected{/if} value="100">100</option>
                    <option {if $rpp eq 200}selected{/if} value="200">200</option>
                    <option {if $rpp eq 500}selected{/if} value="500">500</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary"><span class="glyphicon glyphicon-filter" aria-hidden="true"></span> Filtra</button>
        </form>
    </div>
</div>
<div id="servicesListContent" name="servicesListContent">
    {$servicesListContent}
</div>
