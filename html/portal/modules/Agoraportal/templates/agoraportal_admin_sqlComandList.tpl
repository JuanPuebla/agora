<div class="list-group">
{foreach from=$comands item=comand}
<a href="#" onClick="sqlFunctionUpdate(1, {$comand.comandId})" class="list-group-item clearfix" id="comandBox_".{$comand.comandId}>
     {$comand.description|nl2br}
     <span class="btn-group pull-right" role="group">
         <button type="button" class="btn btn-info input-sm"  onClick="sqlFunctionUpdate(2, {$comand.comandId})" title="Modifica">
            <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
            <span class="sr-only">Modifica</span>
         </button>
         <button type="button" class="btn btn-danger input-sm"  onClick="sqlComandsUpdate(2, {$comand.comandId})" title="Esborra">
            <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
            <span class="sr-only">Esborra</span>
         </button>
     </span>
 </a>
 {/foreach}
 </div>
