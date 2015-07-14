<div class="pager">{$requestsNumber} {gt text="Peticions"} - {$pager}</div>
<table class="table table-hover table-striped">
    <thead>
        <tr>
            <th>{gt text="Nom Client"}</th>
            <th>{gt text="Servei"}</th>
            <th>{gt text="Ha enviat"}</th>
            <th>{gt text="Estat"}</th>
            <th>{gt text="Tipus"}</th>
            <th>{gt text="Resposta dels administradors"}</th>
            <th>{gt text="Data de petició"}</th>
            <th>{gt text="Darrera modificació"}</th>
            <th>{gt text="Opcions"}</th>
        </tr>
    </thead>
    <tbody>
        {foreach item=client from=$requests}
        <tr id="formRow_{$client.clientId}"
            {if $client.state == 'Pendent'}
                class="info"
            {elseif $client.state == 'Solucionada'}
                class="success"
            {elseif $client.state == 'Denegada'}
                class="danger"
            {else}
                class="warning"
            {/if}
            >
            <td>
                 <a href="{modurl modname='Agoraportal' type='user' func='myAgora' clientCode=$client.clientCode}" target="_blank">
                     {$client.clientName}
                 </a>
             </td>
             <td><img src="modules/Agoraportal/images/{$client.serviceName}.gif" alt="{$client.serviceName}" title="{$client.serviceName}"/> </td>
             <td>{$client.username} </td>
             <td>{$client.state} </td>
             <td>{$client.type} </td>
             <td>{$client.adminComments|truncate:30} </td>
             <td>{$client.timeCreated|dateformat:"%d/%m/%Y - %H:%m"} </td>
             <td>{$client.timeClosed|dateformat:"%d/%m/%Y - %H:%m"} </td>
             <td>
                <div class="btn-group" role="group">
                    <a class="btn btn-primary" href="{modurl modname='Agoraportal' type='admin' func='editRequest' requestId=$client.requestId init=$init search=$search searchText=$searchText stateFilter=$stateFilter service=$service}" title="Edita">
                        <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                        <span class="sr-only">Edita</span>
                    </a>
                    <a class="btn btn-danger" href="{modurl modname='Agoraportal' type='admin' func='deleteRequest' requestId=$client.requestId}" title="Esborra">
                        <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
                        <span class="sr-only">Esborra</span>
                    </a>
                </div>

             </td>
         </tr>
         {foreachelse}
         <tr>
             <td colspan="10">
                 {gt text="No s'han trobat continguts"}
             </td>
         </tr>
         {/foreach}
        </tbody>
    </table>
