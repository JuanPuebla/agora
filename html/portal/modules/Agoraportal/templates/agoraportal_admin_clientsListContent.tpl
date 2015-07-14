<div class="pager">{$clientsNumber} {gt text="Serveis"} - {$pager}</div>
<table class="table table-hover table-striped">
    <thead>
        <tr>
            <th>{gt text="Nom client"}</th>
            <th>{gt text="Servei Territorial"}</th>
            <th>{gt text="Observacions"}</th>
            <th>{gt text="Estat"}</th>
            <th>{gt text="Opcions"}</th>
        </tr>
    </thead>
    <tbody>
        {foreach item=client from=$clients}
        <tr id="formRow_{$client.clientId}">
            <td align="left" valign="top">
                 <a href="{modurl modname='Agoraportal' type='user' func='myAgora' clientCode=$client.clientCode}">
                     {$client.clientName}
                 </a>
                 <div>{$client.clientCode}</div>
             </td>
             <td align="left" valign="top">
                 {if isset($locations[$client.locationId].locationName)}
                 {$locations[$client.locationId].locationName}
                 {/if}
             </td>
             <td align="left" valign="top">
                 {$client.clientDescription|nl2br}
             </td>
             <td align="left" valign="top" width="150">
                 {if $client.clientState eq 0}
                 <span class="denegated">
                     {gt text="No actiu"}
                 </span>
                 {elseif $client.clientState eq 1}
                 <span class="actived">
                     {gt text="Actiu"}
                 </span>
                 {/if}
                 <div>
                     {if $client.noVisible eq 1}
                     <span class="denegated">
                         {gt text="No visible"}
                     </span>
                     {elseif $client.noVisible eq 0}
                     <span class="actived">
                         {gt text="Visible"}
                     </span>
                     {/if}
                 </div>
             </td>
             <td align="center">
                <div class="btn-group" role="group">
                    <a class="btn btn-info" href="{modurl modname='Agoraportal' type='admin' func='editClient' clientId=$client.clientId init=$init search=$search searchText=$searchText}" title="Edita">
                        <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                        <span class="sr-only">Edita</span>
                    </a>
                    {*<a class="btn btn-danger" href="{modurl modname='Agoraportal' type='admin' func='deleteClient' clientId=$client.clientId init=$init search=$search searchText=$searchText}" title="Esborra">
                        <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
                        <span class="sr-only">Esborra</span>
                    </a>*}
                </div>
             </td>
         </tr>
         {foreachelse}
         <tr>
             <td colspan="5" align="left">
                <div class="alert alert-warning">{gt text="No s'han trobat clients"}</div>
             </td>
         </tr>
         {/foreach}
    </tbody>
</table>