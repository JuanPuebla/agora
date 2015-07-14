<td>{$serviceId}</td>
<td><img src="modules/Agoraportal/images/{$service.serviceName}.gif" alt="{$service.serviceName}" title="{$service.serviceName}"/></td>
<td>{$service.URL}</td>
<td>{$service.description}</td>
<td>{$service.version}</td>
<td>{$service.hasDB}</td>
<td>{$service.tablesPrefix}</td>
<td>{$service.allowedClients}</td>
<td>{$service.serverFolder}</td>
<td>{$service.defaultDiskSpace}</td>
<td>
    <a class="btn btn-info" href="#" onclick="editService({$serviceId});" title="Edita">
        <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
        <span class="sr-only">Edita</span>
    </a>
</td>