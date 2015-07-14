<div class="pager">{$clientsNumber} {gt text="Serveis"} - {$pager}</div>
<table class="table table-hover table-striped table-condensed">
    <thead>
        <tr>
            <th>{gt text="BD"}</th>
            <th>{gt text="Nom client"}</th>
            <th>{gt text="Tipus"}</th>
            <th>{gt text="Servei"}</th>
            <th>{gt text="Municipi i SSTT"}</th>
            <th>{gt text="Ha Enviat"}</th>
            <th>{gt text="Observacions"}</th>
            <th>{gt text="Data"}</th>
            <th>{gt text="Consum"}</th>
            <th>{gt text="Estat"}</th>
            <th>{gt text="Opcions"}</th>
        </tr>
    </thead>
    <tbody>
        {foreach item=client from=$clients}
        <tr id="formRow_{$client.clientId}">
            <td align="left" valign="top" class="id">
                 {$client.activedId}
             </td>
             <td align="left" valign="top" class="codeandname">
                 <a href="{modurl modname='Agoraportal' type='user' func='myAgora' clientCode=$client.clientCode}">{$client.clientName}</a>
                 <br />
                 {$client.clientDNS} - {$client.clientCode}
             </td>
             <td align="left" valign="top" class="schooltype">
                 {if isset($types[$client.typeId].typeName)}
                 {$types[$client.typeId].typeName}
                 {/if}
                 {if $client.extraFunc neq ''}
                 <div>
                     {$client.extraFunc}
                 </div>
                 {/if}
                 {if $client.educat eq 1}
                 <div style="float: right;">
                     <img src="modules/Agoraportal/images/educat.png" alt="educat" title="educat" align="middle"/>
                 </div>
                 {/if}
             </td>
             <td align="left" valign="top" class="service">
                 {if $client.state eq 1 && $services[$client.serviceId].serviceName neq 'marsupial'}
                 <a href="{$client.clientDNS|serviceLink:$services[$client.serviceId].serviceName}" target="_blank">
                 {/if}
                 <img src="modules/Agoraportal/images/{$services[$client.serviceId].serviceName}.gif" alt="{$services[$client.serviceId].serviceName}" title="{$services[$client.serviceId].serviceName}" />
                 {if $client.state eq 1 && $services[$client.serviceId].serviceName neq 'marsupial'}
                 </a>
                 {/if}
             </td>
             <td align="left" valign="top" class="location">
                 {$client.clientCity}
                 {if isset($locations[$client.locationId].locationName)}
                 <div>
                     {$locations[$client.locationId].locationName}
                 </div>
                 {/if}
             </td>
             <td align="left" valign="top" class="contact">
                 {$client.contactName}
                 <br />
                 {$client.contactProfile}
             </td>
             <td valign="top" class="observs">
                 {$client.observations|nl2br}
                 {if $client.annotations neq ''}
                 <div class="z-form">
                 <fieldset class="adminNotes">
                     <legend>{gt text="Anotacions"}</legend>
                     {$client.annotations|nl2br}
                 </fieldset>
                 </div>
                 {/if}
             </td>
             <td width="100" class="time">
                 <span class="timeLetter" title="Data d'edició">{gt text="e"}</span>: {$client.timeEdited|dateformat:"%d/%m/%Y"}
                 <br />
                 <span class="timeLetter" title="Data de creació">{gt text="c"}</span>: {$client.timeCreated|dateformat:"%d/%m/%Y"}
                 <br />
                 <span class="timeLetter" title="Data de sol·licitud">{gt text="s"}</span>: {$client.timeRequested|dateformat:"%d/%m/%Y"}
             </td>
             <td style="background-color: {$client.diskConsumeCellColor}; width: 70px; text-align:right;" class="diskusage">
                 {if $client.diskSpace gt 0}
                 {$client.diskSpace} MB
                 <br />
                 {$client.diskConsume} MB
                 <br />
                 {$client.diskConsumePerCent} %
                 {/if}
             </td>
             <td align="left" valign="top" width="100" class="state">
                 {if $client.state eq 0}
                 <span class="toCheck">
                 {gt text="Per revisar"}
                </span>
                {elseif $client.state eq 1}
                <span class="actived">
                    {gt text="Actiu"}
                </span>
                {elseif $client.state eq -2}
                <span class="denegated">
                    {gt text="Denegat"}
                </span>
                {elseif $client.state eq -3}
                <span class="denegated">
                    {gt text="Donat de baixa"}
                </span>
                {elseif $client.state eq -4}
                <span class="denegated">
                    {gt text="Desactivat"}
                </span>
                {else}
                {gt text="No s'ha trobat"}
                {/if}
            </td>
            <td valign="top" align="center" class="actions">
                <div class="btn-group" role="group">
                    {if $client.state eq 1 && $services[$client.serviceId].serviceName neq 'marsupial'}
                        <a target="_blank" class="btn btn-primary" href="{modurl modname='Agoraportal' type='admin' func='listDataDirs' serviceName=$services[$client.serviceId].serviceName activedId=$client.activedId}" title="Fitxers">
                            <span class="glyphicon glyphicon-folder-open" aria-hidden="true"></span>
                            <span class="sr-only">Fitxers</span>
                        </a>
                    {/if}
                    <a class="btn btn-info" href="{modurl modname='Agoraportal' type='admin' func='editService' clientServiceId=$client.clientServiceId init=$init search=$search searchText=$searchText stateFilter=$stateFilter service=$service}" title="Edita">
                        <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                        <span class="sr-only">Edita</span>
                    </a>
                    <a class="btn btn-warning" href="{modurl modname='Agoraportal' type='admin' func='serviceTools' clientServiceId=$client.clientServiceId}" title="Eines">
                        <span class="glyphicon glyphicon-wrench" aria-hidden="true"></span>
                        <span class="sr-only">Eines</span>
                    </a>
                    <a class="btn btn-danger" href="{modurl modname='Agoraportal' type='admin' func='deleteService' clientServiceId=$client.clientServiceId}" title="Esborra">
                        <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
                        <span class="sr-only">Esborra</span>
                    </a>
                </div>
            </td>
        </tr>
        {foreachelse}
        <tr>
            <td colspan="11" align="left">
                <div class="alert alert-warning">{gt text="No s'han trobat serveis"}</div>
            </td>
        </tr>
        {/foreach}
    </tbody>
</table>