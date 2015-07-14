{include file="agoraportal_user_menu.tpl" clientCode=$client.clientCode}
<script language="javascript" type="text/javascript">
    var path_to_link_script = "modules/Agoraportal/upload/ubr_link_upload.php";
    var path_to_set_progress_script = "modules/Agoraportal/upload/ubr_set_progress.php";
    var path_to_get_progress_script = "modules/Agoraportal/upload/ubr_get_progress.php";
    var path_to_upload_script = "{{$cgi_script}}";
    var multi_configs_enabled = 0;
    var check_allow_extensions_on_client = 1;
    var check_disallow_extensions_on_client = 0;
    var allow_extensions = /(zip|mbz)$/i;
    var check_file_name_format = 1;
    var check_null_file_count = 1;
    var check_duplicate_file_count = 1;
    var max_upload_slots = 1;
    var cedric_progress_bar = 1;
    var cedric_hold_to_sync = 0;
    var progress_bar_width = 400;
    var show_percent_complete = 1;
    var show_files_uploaded = 1;
    var show_current_position = 1;
    var show_elapsed_time = 1;
    var show_est_time_left = 1;
    var show_est_speed = 1;
</script>
<script language="javascript" type="text/javascript" src="modules/Agoraportal/upload/ubr_file_upload.js"></script>

{if $isAdmin}
{assign var='clientCode' value=$client.clientCode}
{else}
{assign var='clientCode' value=''}
{/if}
<nav class="navbar navbar-default">
    <div class="container-fluid">
    <ul class="nav navbar-nav">
        <li><a href="{modurl modname='Agoraportal' type='user' func='files' action='uploadFiles' clientCode=$clientCode}" >{gt text="Envia fitxers grans al servidor"}</a></li>
    {if in_array('moodle2', $activedServicesNames)}
        <li><a href="{modurl modname='Agoraportal' type='user' func='files' action='m2x' clientCode=$clientCode}">{gt text="Fitxers Moodle 2.x"}</a></li>
    {/if}
    </ul>
    </div>
</nav>
{if $isAdmin}
{include file="agoraportal_admin_clientInfo.tpl"}
{/if}
{if (in_array('moodle2', $activedServicesNames)) AND $action eq 'uploadFiles'}
<div id="uploadFiles">
    <h3>{gt text="Envia fitxers grans al servidor"}</h3>
    <div id="formsArea">
        <form name="form_upload" id="form_upload"  method="post" enctype="multipart/form-data" action="#">
            <noscript><div class="alert alert-danger">Atenció: Per pujar fitxers grans cal que el navegador tingui el Javascript activat.</div></noscript>
            <input type="hidden" name="clientServiceId" value="" />
            {foreach item=usage from=$usageArray name=service}
                <p>{gt text="Servei"}: <strong>{$usage.serviceName}</strong></p>
                <div class="clearfix">
                    <div class="pull-left"><strong>{gt text="Espai de disc ocupat"}</strong>:&nbsp;</div>
                    <div class="progress pull-left" style="width:200px;">
                      <div class="progress-bar" role="progressbar" aria-valuenow="{$usage.percentage}" aria-valuemin="0" aria-valuemax="100" style="width: {$usage.percentage}%;">
                        {$usage.percentage}%
                      </div>
                    </div>


                    <div class="pull-left">&nbsp;&nbsp;({$usage.usedDiskSpace}MB / {$usage.totalDiskSpace}MB) <a href="{modurl modname='Agoraportal' type='user' func='recalcConsume' clientServiceId=$usage.clientServiceId}">{gt text="Actualitza"}</a></div>
                    {if $usage.alert eq 1}
                    <div class="pull-left">&nbsp;&nbsp;
                        <a href="{modurl modname='Agoraportal' type='user' func='requests' clientCode=$client.clientCode}">
                            {gt text="Sol·licita més espai"}
                        </a>
                    </div>
                    {/if}
                </div>
                <div class="clearfix">
                    {if $usage.percentage < 100}
                        <!-- Include extra values you want passed to the upload script here. -->
                        <!-- eg. <input type="text" name="employee_num" value="5"> -->
                        <!-- Access the value in the CGI with $query->param('employee_num'); -->
                        <!-- Access the value in the PHP finished page with $_POST_DATA['employee_num']; -->
                        <!-- DO NOT USE "upfile_" for any of your values. -->
                        <input type="file" name="upfile_{$smarty.foreach.service.index}" size="30" onChange="addUploadSlot(1)"  onkeypress="return handleKey(event)" value="" />
                        <br/>
                        <input class="btn btn-success" type="button" id="upload_button" name="upload_button" value="Envia" onClick="document.forms['form_upload'].clientServiceId.value = {$usage.clientServiceId};linkUpload();document.getElementById('formsArea').style.display='none';" />
                    {/if}
                    {if $usage.percentage > 100}
                        <div class="alert alert-danger">
                            {gt text="Heu superat el límit de capacitat de pujada de fitxers al servidor.
                            Per poder pujar fitxers abans heu d'alliberar quota o obtenir-ne més.
                            Podeu trobar més informació de com sol·licitar l'ampliació de la quota en aquesta <a href=\"http://agora.xtec.cat/moodle/moodle/mod/glossary/view.php?id=461&amp;mode=entry&amp;hook=561\">pregunta freqüent d'Àgora</a>."}
                        </div>
                    {/if}
                </div>
            {/foreach}
        </form>
        <br/>
        <div class="alert alert-info">
            <p>{gt text="Des d'aquí podeu afegir fitxers grans al vostre espai Moodle, tenint en compte les condicions següents:"}</p>
            <ul>
                <li>{gt text="Només s'admeten fitxers comprimits en format ZIP i MBZ que tinguin una mida compresa entre 10 i 200 MB."}</li>
                <li>{gt text="Els fitxers de menys de 10 MB s'han de pujar des de l'espai web."}</li>
                <li>{gt text="Mantingueu una còpia del fitxer en local fins que hàgiu comprovat que el fitxer s'ha enviat correctament."}</li>
                <li>{gt text="Si en el repositori <strong>Fitxers</strong> n'hi ha un amb el mateix nom, serà sobreescrit."}</li>
            </ul>
        </div>
    </div>
    <!-- Start Progress Bar -->
    <div class="alert" id="ubr_alert"></div>
    <div id="progress_bar" style="display:none">
        <div class="bar1" id="upload_status_wrap">
            <div class="bar2" id="upload_status"></div>
        </div>
        <br />
        <center>
            <table class="da    ta" cellpadding='3' cellspacing='1' width="350">
                <tr>
                    <td align="left" width="200"><b>{gt text="Percentatge completat"}:</b></td>
                    <td align="center"><span id="percent">0%</span></td>
                </tr>
                <tr>
                    <td align="left" width="150"><b>{gt text="Fitxers enviats"}:</b></td>
                    <td align="center"><span id="uploaded_files">0</span> de <span id="total_uploads"></span></td>
                </tr>
                <tr>
                    <td align="left"><b>{gt text="Posició actual"}:</b></td>
                    <td align="center"><span id="current">0</span> / <span id="total_kbytes"></span>KB</td>
                </tr>
                <tr>
                    <td align="left"><b>{gt text="Temps consumit"}:</b></td>
                    <td align="center"><span id="time">0</span></td>
                </tr>
                <tr>
                    <td align="left"><b>{gt text="Temps restant"}:</b></td>
                    <td align="center"><span id="remain">0</span></td>
                </tr>
                <tr>
                    <td align="left"><b>{gt text="Velocitat"}:</b></td>
                    <td align="center"><span id="speed">0</span> KB/s.</td>
                </tr>
            </table>
        </center>
    </div>
    <!-- End Progress Bar -->
</div>
{/if}
{if in_array('moodle2', $activedServicesNames) AND $action eq 'm2x'}
<div id="m2x">
    <h3>{gt text="Fitxers Moodle 2.x"}</h3>
    <table class="table table-hover table-striped">
        <thead>
            <tr>
                <th>{gt text="Nom del fitxer"}</th>
                <th>{gt text="Mida (MB)"}</th>
                <th>{gt text="Data"}</th>
                <th>{gt text="Esborra"}</th>
            </tr>
        </thead>
        <tbody>
            {foreach item=file from=$moodle2RepoFiles}
            <tr id="file_{$file.name}">
                {if $file.type == 'dir'}
                    <td class="info">{$file.name}/</td>
                    <td></td>
                {else}
                    <td>{$file.name}</td>
                    <td>{$file.size} MB</td>
                {/if}
                <td>{$file.time}</td>
                <td>
                    <div class="btn-group" role="group">
                        {if $file.type != 'dir'}
                            <a class="btn btn-info" href="{modurl modname='Agoraportal' type='user' func='downloadFile' filename=$file.filename name=$file.name clientCode=$clientCode target='m2x'}" title="Descarrega el fitxer">
                                <span class="glyphicon glyphicon-download" aria-hidden="true"></span>
                                <span class="sr-only">Descarrega el fitxer</span>
                            </a>
                        {/if}
                        <a class="btn btn-danger" href="#" onclick="deleteFileM2x('{$file.filename}','{$file.name}','{$clientCode}');" title="Esborra el fitxer">
                            <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
                            <span class="sr-only">Esborra el fitxer</span>
                        </a>
                    </div>
                </td>
            </tr>
            {foreachelse}
            <tr>
                <td colspan="4">
                    {gt text="No s'han trobat fitxers"}
                </td>
            </tr>
            {/foreach}
        </tbody>
    </table>
</div>
{/if}
