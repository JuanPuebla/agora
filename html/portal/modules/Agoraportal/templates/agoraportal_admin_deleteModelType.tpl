{include file="agoraportal_admin_menu.tpl"}
<h3>{gt text="Esborra el registre de la maqueta"}</h3>

<form  class="z-form" enctype="application/x-www-form-urlencoded" method="post" id="deleteModelType" action="{modurl modname='Agoraportal' type='admin' func='deleteModelType'}">
    <input type="hidden" name="csrftoken" value="{insert name='csrftoken'}" />
    <input type="hidden" name="modelTypeId" value="{$modelType.modelTypeId}" />
    <input type="hidden" name="confirmation" value="1" />

    {gt text="Confirmació de l'esborrament"}: <strong>{$modelType.keyword}</strong>

    <div class="z-center z-buttons">
        <input class="z-bt-ok" type="submit" value="{gt text="Esborra el registre"}" />
    </div>

</form>
