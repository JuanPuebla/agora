<label for="requestMenuServices">{gt text="Servei"}</label>
<select class="form-control" name="requestMenuServices" id="requestMenuServices" onchange="showRequestMessage($('requestMenuServices').value, $('requestFilter').value, $('clientCode').value);">
    <option value="0">{gt text="Tria el servei"}</option>
    {foreach from=$services key=serviceid item=servicename }
        <option value="{$serviceid}">{$servicename}</option>
    {/foreach}
</select>
