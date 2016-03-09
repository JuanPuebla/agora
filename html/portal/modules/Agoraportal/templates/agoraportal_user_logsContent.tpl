<nav class="pull-right">
    {$numLogs}
    {gt text=" registres - <b>Pàgines: </b>"}
    <br/>
    <ul class="pagination">
    {foreach from=$pags item=pag}

        {if $pag eq $config.pag}
        <li class="active"><a href="#">{$pag}</a>
        {else}
        <li>
        <a href='javascript:logs({$config.init},
           {if $config.actionCode eq ""}null{else}{$config.actionCode}{/if},
           {if $config.fromDate eq ""}null{else}"{$config.fromDate}"{/if},
           {if $config.toDate eq ""}null{else}"{$config.toDate}"{/if},
           {if $config.uname eq ""}null{else}{$config.uname}{/if},
           {$pag})'>{$pag}</a>
        {/if}
    </li>
    {foreachelse} 0
    {/foreach}
  </ul>
</nav>
<table class="table table-striped table-hover">
    <thead>
        <tr>
            <th>{gt text="Tipus d'acció"}</th>
            <th>{gt text="Acció"}</th>
            {if $isAdmin}
                <th>{gt text="Autor/a"}</th>
            {/if}
            <th>{gt text="Data"}</th>
        </tr>
    </thead>
    <tbody>
        {foreach from=$logs item=log}
        <tr id="formRow_{$log.logId}">
            <td class="icon">
                {if $log.actionCode eq 1}
                <img class="icon" src="images/icons/medium/db_add.png" alt="log_add" title="log_add"/>
                {elseif $log.actionCode eq 2}
                <img class="icon" src="images/icons/medium/db_comit.png" alt="log_modify" title="log_modify"/>
                {else}
                <img class="icon" src="images/icons/medium/db_remove.png" alt="log_delete" title="log_delete"/>
                {/if}
            </td>
            <td>
                {$log.action|stripslashes}
            </td>
            {if $isAdmin}
                <td class="autor">
                    {$log.uname}
                </td>
            {/if}
            <td class="time">
                {$log.time|dateformat:"%d-%m-%Y"}
            </td>
        </tr>
        {foreachelse}
        <tr>
            <td colspan="5" align="left">
                {gt text="No s'han trobat registres"}
            </td>
        </tr>
        {/foreach}
    </tbody>
</table>