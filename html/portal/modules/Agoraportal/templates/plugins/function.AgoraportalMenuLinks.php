<?php

require_once('modules/Agoraportal/lib/Agoraportal/Util.php');

function smarty_function_AgoraportalMenuLinks($params, &$smarty) {
    // set some defaults
    $clientCode = (isset($params['clientCode'])) ? $params['clientCode'] : '';

    // Get the list of services
    $services = ModUtil::apiFunc('Agoraportal', 'user', 'getAllServices');

    $availableServicesNumber = 0;
    foreach ($services as $service) {
        $availableServicesNumber++;
        // Following code is commented in order to allow the 4th service to be asked for
        //  even if there is any service which is not accepting new registers. The problem
        //  appears when an existing service is block for new register.
        /*
        if ($service['allowedClients'] != '') {
            if (!empty($clientCode) && (strpos($service['allowedClients'], $clientCode) !== false)) {
                $availableServicesNumber++;
            }
        } else {
            $availableServicesNumber++;
        }
        */
    }

    if ($service['allowedClients'] != '') {
        if (!empty($clientCode) && (strpos($service['allowedClients'], $clientCode) !== false)) {
            $allowedServices[$service['serviceId']] = $service;
        }
    } else {
        $allowedServices[$service['serviceId']] = $service;
    }

    // Get client services information
    $clientInfo = ModUtil::apiFunc('Agoraportal', 'user', 'getAllClientsAndServices', array('init' => 0,
                'rpp' => 50,
                'service' => 0,
                'state' => array(0, 1),
                'search' => 1,
                'searchText' => $clientCode,
                'clientCode' => $clientCode));

    $numClientServices = count($clientInfo);

    $showRequests = ($numClientServices > 0) ? true : false;

    $AgoraportalMenuLinks = '';

    // Compacted if's don't work as espected here!
    $isClient = AgoraPortal_Util::isClient();
    $isManager = AgoraPortal_Util::isManager();
    $isAdmin = AgoraPortal_Util::isAdmin();

    if (!$isAdmin) {
        $clientInfo = ModUtil::apiFunc('Agoraportal', 'user', 'getRealClientCode', array('clientCode' => $clientCode));
        $clientCode = $clientInfo['clientCode'];
    }

    // Decide whether to show files manager on not i MyAgora
    $showFilesManager = false;
    $isMoodle2Enabled = ModUtil::apiFunc('Agoraportal', 'user', 'existsServiceInClient', array('clientCode' => $clientCode,
                'serviceName' => 'moodle2'));
    if ($isMoodle2Enabled) {
        $showFilesManager = true;
    }

    // Administrator menu
    if ($isAdmin) {
        $AgoraportalMenuLinks = '<ul class="nav nav-pills">';
        $AgoraportalMenuLinks .= ' <li role="presentation"><a href="' . DataUtil::formatForDisplayHTML(ModUtil::url('Agoraportal', 'admin', 'main')) . '"><span class="glyphicon glyphicon-home" aria-hidden="true"></span> ' . __('Llista de serveis') . '</a> ';
        $AgoraportalMenuLinks .= ' <li role="presentation"><a href="' . DataUtil::formatForDisplayHTML(ModUtil::url('Agoraportal', 'admin', 'clientsList')) . '"><span class="glyphicon glyphicon-education" aria-hidden="true"></span> ' . __('Llista de clients') . '</a> ';
        $AgoraportalMenuLinks .= ' <li role="presentation"><a href="' . DataUtil::formatForDisplayHTML(ModUtil::url('Agoraportal', 'admin', 'requestsList')) . '"><span class="glyphicon glyphicon-flag" aria-hidden="true"></span> ' . __('Sol·licituds') . '</a> ';
        $AgoraportalMenuLinks .= ' <li role="presentation"><a href="' . DataUtil::formatForDisplayHTML(ModUtil::url('Agoraportal', 'admin', 'stats')) . '"><span class="glyphicon glyphicon-stats" aria-hidden="true"></span> ' . __('Estadístiques') . '</a> ';
        $AgoraportalMenuLinks .= ' <li role="presentation"><a href="' . DataUtil::formatForDisplayHTML(ModUtil::url('fitxers', 'admin', 'main')) . '"><span class="glyphicon glyphicon-folder-open" aria-hidden="true"></span> ' . __('Fitxers') . '</a> ';
        $AgoraportalMenuLinks .= ' <li role="presentation"><a href="' . DataUtil::formatForDisplayHTML(ModUtil::url('Agoraportal', 'admin', 'sql')) . '"><span class="glyphicon glyphicon-flash" aria-hidden="true"></span> ' . __('Execució d\'SQL') . '</a> ';
        $AgoraportalMenuLinks .= ' <li role="presentation"><a href="' . DataUtil::formatForDisplayHTML(ModUtil::url('Agoraportal', 'admin', 'advices')) . '"><span class="glyphicon glyphicon-bullhorn" aria-hidden="true"></span> ' . __('Enviament d\'avisos') . '</a> ';
        $AgoraportalMenuLinks .= ' <li role="presentation"><a href="' . DataUtil::formatForDisplayHTML(ModUtil::url('Agoraportal', 'admin', 'operations')) . '"><span class="glyphicon glyphicon-transfer" aria-hidden="true"></span> ' . __('Operacions') . '</a> ';
        $AgoraportalMenuLinks .= ' <li role="presentation"><a href="' . DataUtil::formatForDisplayHTML(ModUtil::url('Agoraportal', 'admin', 'queues')) . '"><span class="glyphicon glyphicon-tasks" aria-hidden="true"></span> ' . __('Cues') . '</a> ';
        if ( $agora['server']['enviroment'] != 'PRO' ) {
            $AgoraportalMenuLinks .= ' <li role="presentation"><a href="' . DataUtil::formatForDisplayHTML(ModUtil::url('Agoraportal', 'admin', 'createBatch')) . '"><span class="glyphicon glyphicon-th" aria-hidden="true"></span> ' . __('Creació massiva') . '</a> ';
        }
        $AgoraportalMenuLinks .= ' <li role="presentation"><a href="' . DataUtil::formatForDisplayHTML(ModUtil::url('Agoraportal', 'admin', 'config')) . '"><span class="glyphicon glyphicon-cog" aria-hidden="true"></span> ' . __('Configuració') . '</a> ';
        $AgoraportalMenuLinks .= '</ul>';
    }

    // user services view menu
    if ($isClient && !$isAdmin) {
        $AgoraportalMenuLinks .= '<ul class="nav nav-pills">';
        $AgoraportalMenuLinks .= ' <li role="presentation"><a href="' . DataUtil::formatForDisplayHTML(ModUtil::url('Agoraportal', 'user', 'myAgora')) . '"><span class="glyphicon glyphicon-home" aria-hidden="true"></span> ' . __('Serveis') . "</a> ";
        if ($isManager && $showFilesManager) {
            $AgoraportalMenuLinks .= ' <li role="presentation"><a href="' . DataUtil::formatForDisplayHTML(ModUtil::url('Agoraportal', 'user', 'files')) . '"><span class="glyphicon glyphicon-folder-open" aria-hidden="true"></span> ' . __('Gestió de fitxers') . "</a> ";
        }
        if ($isManager && $showRequests) {
            $AgoraportalMenuLinks .= ' <li role="presentation"><a href="' . DataUtil::formatForDisplayHTML(ModUtil::url('Agoraportal', 'user', 'requests')) . '"><span class="glyphicon glyphicon-flag" aria-hidden="true"></span> ' . __('Altres Sol·licituds') . "</a> ";
        }
        $AgoraportalMenuLinks .= ' <li role="presentation"><a href="' . DataUtil::formatForDisplayHTML(ModUtil::url('Agoraportal', 'user', 'managers')) . '"><span class="glyphicon glyphicon-user" aria-hidden="true"></span> ' . __('Gestors') . "</a> ";
        $AgoraportalMenuLinks .= ' <li role="presentation"><a href="' . DataUtil::formatForDisplayHTML(ModUtil::url('Agoraportal', 'user', 'logs')) . '"><span class="glyphicon glyphicon-inbox" aria-hidden="true"></span> ' . __('Accions fetes') . "</a> ";
        $AgoraportalMenuLinks .= '</ul>';
    }

    // admin services for users view menu
    if ($isAdmin && isset($params['clientCode'])) {
        $AgoraportalMenuLinks .= '<ul class="nav navbar-nav">';
        $AgoraportalMenuLinks .= " <li><a href=\"" . DataUtil::formatForDisplayHTML(ModUtil::url('agoraPortal', 'user', 'myAgora', array('clientCode' => $clientCode))) . "\">" . __('Serveis') . "</a> ";
        if ($showFilesManager) {
            $AgoraportalMenuLinks .= " <li><a href=\"" . DataUtil::formatForDisplayHTML(ModUtil::url('agoraPortal', 'user', 'files', array('clientCode' => $clientCode))) . "\">" . __('Gestió de fitxers') . "</a> ";
        }
        if ($showRequests) {
            $AgoraportalMenuLinks .= " <li><a href=\"" . DataUtil::formatForDisplayHTML(ModUtil::url('Agoraportal', 'user', 'requests', array('clientCode' => $clientCode))) . "\">" . __('Altres Sol·licituds') . "</a> ";
        }
        $AgoraportalMenuLinks .= " <li><a href=\"" . DataUtil::formatForDisplayHTML(ModUtil::url('agoraPortal', 'user', 'managers', array('clientCode' => $clientCode))) . "\">" . __('Gestors') . "</a> ";
        $AgoraportalMenuLinks .= " <li><a href=\"" . DataUtil::formatForDisplayHTML(ModUtil::url('agoraPortal', 'user', 'logs', array('clientCode' => $clientCode))) . "\">" . __('Accions fetes') . "</a> ";
        $AgoraportalMenuLinks .= '</ul>';
    }

    return $AgoraportalMenuLinks;
}