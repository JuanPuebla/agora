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

<div class="z-admincontainer">
    <div class="z-adminpageicon">{img modname='core' src='windowlist.png' set='icons/large'}</div>
    <h2>{gt text="Llista de serveis dels clients"}</h2>
    <div class="z-form">
        <fieldset>
            <legend>{gt text="Filtre"}</legend>
            <form name="filterForm" id="filterForm" onSubmit="submitform(); return false;">
                {gt text="Servei"}
                <select name="service" id="service" onChange="submitform();">
                    <option value="0">{gt text="Tots els serveis"}</option>
                    {foreach item=serviceItem from=$services}
                    <option {if $serviceItem.serviceId eq $service}selected{/if} value="{$serviceItem.serviceId}">{$serviceItem.serviceName}</option>
                    {/foreach}
                </select>
                <span style="margin-left:50px;">&nbsp;</span>
                {gt text="Estat"}
                <select name="stateFilter" id="stateFilter" onChange="submitform();">
                    <option {if $stateFilter eq -1}selected{/if} value="-1">{gt text="Tots els estats"}</option>
                    <option {if $stateFilter eq 0}selected{/if} value="0">{gt text="Per revisar"}</option>
                    <option {if $stateFilter eq 1}selected{/if} value="1">{gt text="Actiu"}</option>
                    <option {if $stateFilter eq -2}selected{/if} value="-2">{gt text="Denegat"}</option>
                    <option {if $stateFilter eq -3}selected{/if} value="-3">{gt text="Donat de baixa"}</option>
                    <option {if $stateFilter eq -4}selected{/if} value="-4">{gt text="Desactivat"}</option>
                </select>
                <span style="margin-left:50px;">&nbsp;</span>
                {gt text="Cerca per..."}
                <select name="search" id="search" onChange="submitform();">
                    <option value="0"></option>
                    <option {if $search eq 1}selected{/if} value="1">{gt text="Codi"}</option>
                    <option {if $search eq 2}selected{/if} value="2">{gt text="Nom client"}</option>
                    <option {if $search eq 3}selected{/if} value="3">{gt text="Municipi"}</option>
                </select>
                <input type="text" value="{$searchText}" name="valueToSearch" id="valueToSearch" size="20"/>
                <input type="submit" value="Envia"  />
                <span id="reload"></span>
                <div style="margin-top: 20px;">
                    {gt text="Ordena per..."}
                    <select name="order" id="order" onChange="submitform();">
                        <option {if $order eq 1}selected{/if} value="1">{gt text="Nom client"}</option>
                        <option {if $order eq 2}selected{/if} value="2">{gt text="Data d'edició"}</option>
                    </select>
                    <span style="margin-left:50px;">&nbsp;</span>
                    {gt text="Nombre de registres..."}
                    <select name="rpp" id="rpp" onChange="submitform();">
                        <option {if $rpp eq 15}selected{/if} value="15">15</option>
                        <option {if $rpp eq 30}selected{/if} value="30">30</option>
                        <option {if $rpp eq 50}selected{/if} value="50">50</option>
                        <option {if $rpp eq 100}selected{/if} value="100">100</option>
                        <option {if $rpp eq 200}selected{/if} value="200">200</option>
                        <option {if $rpp eq 500}selected{/if} value="500">500</option>
                    </select>
                </div>
            </form>
        </fieldset>
    </div>
    <div id="servicesListContent" name="servicesListContent">
        {$servicesListContent}
    </div>
</div>