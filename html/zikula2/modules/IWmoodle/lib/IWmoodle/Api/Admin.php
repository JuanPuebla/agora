<?php

require_once('modules/IWmoodle/lib/IWmoodle/MoodleDB.php');

class IWmoodle_Api_Admin extends Zikula_AbstractApi {

    public function getlinks($args) {
        $id = FormUtil::getPassedValue('id', isset($args['id']) ? $args['id'] : 0, 'GET');
        $links = array();
        if (SecurityUtil::checkPermission('IWmoodle::', "::", ACCESS_ADMIN)) {
            $links[] = array('url' => ModUtil::url('IWmoodle', 'admin', 'main'), 'text' => $this->__('Show available courses'), 'class' => 'z-icon-es-view');
            if ($id > 0) {
                $links[] = array('url' => ModUtil::url('IWmoodle', 'admin', 'enrole', array('id' => $id)), 'text' => $this->__('Enrol users into the course'), 'class' => 'z-icon-es-group');
            }
            $links[] = array('url' => ModUtil::url('IWmoodle', 'admin', 'conf'), 'text' => $this->__('Module configuration'), 'class' => 'z-icon-es-config');
            $links[] = array('url' => ModUtil::url('IWmoodle', 'admin', 'sincron'), 'text' => $this->__('Synchronize users'), 'class' => 'z-icon-es-group');
        }
        return $links;
    }

    /**
     * Get all the courses avaliable in Moodle
     * @author:     Albert Pérez Monfort (aperezm@xtec.cat)
     * @return:	The main information about the courses avaliable in Moodle
     */
    public function getall() {
        // Security check
        if (!SecurityUtil::checkPermission('IWmoodle::', '::', ACCESS_ADMIN)) {
            return LogUtil::registerPermissionError();
        }

        $prefix = MoodleDB::get_prefix();
        $sql = "SELECT id, fullname, dbms_lob.substr(summary, 3900, 1), shortname, format, visible
			FROM {$prefix}course
			WHERE category > 0 ORDER BY id DESC";
        return MoodleDB::get_records($sql);
    }

    /**
     * Change the activation of the Moodle courses
     * @author:     Albert Pérez Monfort (aperezm@xtec.cat)
     * @param:	args   id of the course to activate or to unactivate
     * @return:	true if success
     */
    public function activate($args) {

        extract($args);
        // Security check
        if (!SecurityUtil::checkPermission('IWmoodle::', '::', ACCESS_ADMIN)) {
            return LogUtil::registerPermissionError();
        }
        $prefix = MoodleDB::get_prefix();
        //get course
        $course = ModUtil::apiFunc('IWmoodle', 'user', 'getcourse', array('courseid' => $id));
        $visible = ($course['visible'] == 0) ? 1 : 0;
        $sql = "UPDATE {$prefix}course SET visible = $visible WHERE id = $id";
        return MoodleDB::update($sql);
    }

    /**
     * Gets all users enroled into a course and the roles of these users
     * @author:     Albert Pérez Monfort (aperezm@xtec.cat)
     * @param:	args   id of the course
     * @return:	An array with the users and roles
     */
    public function getallusersbyrole($args) {

        extract($args);
        // Security check
        if (!SecurityUtil::checkPermission('IWmoodle::', '::', ACCESS_ADMIN)) {
            return LogUtil::registerPermissionError();
        }

        $prefix = MoodleDB::get_prefix();
        $sql = "SELECT
			c.id, u.userid, u.username, u.auth, u.lastaccess, ctx.contextid, ra.id as roleid
			FROM
				{$prefix}course c, {$prefix}role_assignments ra, {$prefix}user u, {$prefix}context ctx
			WHERE
				ctx.instanceid = $id
				AND ctx.contextlevel = 50
				AND ctx.id = ra.contextid
				AND ra.roleid = $role
				AND ra.userid = u.id
				AND c.id=$id";
        return MoodleDB::get_records($sql);
    }

    /**
     * Gets all the roles in a Moodle course
     * @author:     Albert Pérez Monfort (aperezm@xtec.cat)
     * @param:	args   id of the course
     * @return:	An array with the name and identities of the roles
     */
    public function getallroles() {

        // Security check
        if (!SecurityUtil::checkPermission('IWmoodle::', '::', ACCESS_ADMIN)) {
            return LogUtil::registerPermissionError();
        }
        $prefix = MoodleDB::get_prefix();
        $sql = "SELECT id, name FROM {$prefix}role";
        return MoodleDB::get_records($sql);
    }

    /**
     * Get the id of a user into the website
     * @author:     Albert Pérez Monfort (aperezm@xtec.cat)
     * @param:	args   the user name
     * @return:	the id of the user
     */
    public function getuserPNuid($args) {
        // Security check
        if (!SecurityUtil::checkPermission('IWmoodle::', '::', ACCESS_ADMIN)) {
            return LogUtil::registerPermissionError();
        }
        extract($args);
        $pntable = DBUtil::getTables();
        $c = $pntable['users_column'];
        $where = "$c[uname]='$pn_uname'";
        // get the objects from the db
        $items = DBUtil::selectObjectArray('users', $where);
        // Return the user id
        return $items[0]['uid'];
    }

        /**
     * Change the method used by the user to validate into Moodle. Two possibilities: from the website via db or from the Moodle using the manual method
     * @author:     Albert Pérez Monfort (aperezm@xtec.cat)
     * @param:	args   id of the users that have to change their validation method
     * @return:	true if success
     */
    public function change($args) {

        extract($args);
        // Security check
        if (!SecurityUtil::checkPermission('IWmoodle::', '::', ACCESS_ADMIN)) {
            return LogUtil::registerPermissionError();
        }
        $prefix = MoodleDB::get_prefix();
        $user_pass = substr($user_pass, 3, strlen($user_pass));
        if ($user_connect == 1) {
            $sql = "UPDATE {$prefix}user SET auth='manual',password='$user_pass' WHERE username='$user_name'";
            return MoodleDB::update($sql);
        } else if ($user_connect == 0) {
            $sql = "UPDATE {$prefix}user SET auth='db',password='$user_pass' WHERE username='$user_name'";
            return MoodleDB::update($sql);
        } else {
            $r = ModUtil::apiFunc('IWmoodle', 'admin', 'inscriu', array('uid' => $user_id));
        }

        return true;
    }

    /**
     * Create user into Moodle
     * @author:     Albert Pérez Monfort (aperezm@xtec.cat)
     * @param:	args   id of the users that have to change their validation method
     * @return:	true if success
     */
    public function inscriu($args) {

        extract($args);
        // Security check
        if (!SecurityUtil::checkPermission('IWmoodle::', '::', ACCESS_ADMIN) && UserUtil::getVar('uid') != $uid) {
            //return LogUtil::registerPermissionError();
        }
        if (!isset($uid)) {
            $uid = UserUtil::getVar('uid');
        }

        $prefix = MoodleDB::get_prefix();
        // Prepare vars because we're going to change the database
        $uname = strtolower(UserUtil::getVar('uname', $uid));
        $pass = UserUtil::getVar('pass', $uid);
        $sv = ModUtil::func('IWmain', 'user', 'genSecurityValue');
        $firstname = ModUtil::func('IWmain', 'user', 'getUserInfo', array('uid' => UserUtil::getVar('uid', $uid),
                    'info' => 'n',
                    'sv' => $sv));
        $sv = ModUtil::func('IWmain', 'user', 'genSecurityValue');
        $lastname = ModUtil::func('IWmain', 'user', 'getUserInfo', array('uid' => UserUtil::getVar('uid', $uid),
                    'info' => 'c1',
                    'sv' => $sv));
        $sv = ModUtil::func('IWmain', 'user', 'genSecurityValue');
        $lastname2 = ModUtil::func('IWmain', 'user', 'getUserInfo', array('uid' => UserUtil::getVar('uid', $uid),
                    'info' => 'c2',
                    'sv' => $sv));

        if ($lastname2 != '') {
            $lastname .= ' ' . $lastname2;
        }
        $dfl_description = (ModUtil::getVar('IWmoodle', 'dfl_description') != '') ? ModUtil::getVar('IWmoodle', 'dfl_description') : ' ';
        $dfl_language = (ModUtil::getVar('IWmoodle', 'dfl_language') != '') ? ModUtil::getVar('IWmoodle', 'dfl_language') : ' ';
        $dfl_country = (ModUtil::getVar('IWmoodle', 'dfl_country') != '') ? ModUtil::getVar('IWmoodle', 'dfl_country') : ' ';
        $dfl_city = (ModUtil::getVar('IWmoodle', 'dfl_city') != '') ? ModUtil::getVar('IWmoodle', 'dfl_city') : ' ';
        $dfl_gtm = (ModUtil::getVar('IWmoodle', 'dfl_gtm') != '') ? ModUtil::getVar('IWmoodle', 'dfl_gtm') : ' ';
        $email = UserUtil::getVar('pn_email', $uid);
        if ($lastname == '') {
            $lastname = ' ';
        }
        if ($email == '') {
            $email = $uname . '@mail.domain';
        }
        // get admin mnethostid to user the value for the other users
        $userAdmin = ModUtil::apiFunc('IWmoodle', 'user', 'getuserMDuid', array('username' => 'admin'));
        // let's proceed
        $time = time();
        $sql = "INSERT INTO
			{$prefix}user
			(auth, confirmed, username, password, description, lang, timemodified, country, city, firstname, lastname, email, timezone, mnethostid)
			VALUES
				('db', 1, '" .
                $uname . "', '" .
                substr($pass, 3, strlen($pass)) . "', '" .
                $dfl_description . "', '" .
                $dfl_language . "', '" .
                $time . "', '" .
                $dfl_country . "', '" .
                $dfl_city . "', '" .
                $firstname . "', '" .
                $lastname . "', '" .
                $email . "', '" .
                $dfl_gtm . "', " . $userAdmin['mnethostid'] . ")";
        return MoodleDB::insert($sql);
    }

    /**
     * Gets all users
     * @author:     Albert Pérez Monfort (aperezm@xtec.cat)
     * @param:	args   id of the group of users to return
     * @return:	an array with the main information of the users
     */
    public function getusers($args) {
        extract($args);
        // Security check
        $items = array();
        // Security check
        if (!SecurityUtil::checkPermission('IWmoodle::', '::', ACCESS_ADMIN)) {
            return LogUtil::registerPermissionError();
        }
        $tables = DBUtil::getTables();
        $ocolumn = $tables['group_membership_column'];
        $lcolumn = $tables['users_column'];

        $orderby = "$lcolumn[uname]";

        $where = '';
        if ($filtre != '' && $filtre != '0') {
            $where = "$lcolumn[uname] LIKE '" . $filtre . "%'";
        }
        if ($campfiltre > 0) {
            $usersGroup = ModUtil::func('getMembersGroup');
            $sv = ModUtil::func('IWmain', 'user', 'genSecurityValue');
            $groupMembers = ModUtil::func('IWmain', 'user', 'getMembersGroup', array('sv' => $sv,
                        'gid' => $campfiltre));

            $and = ($where != '') ? ' AND ' : '';
            $where .= $and . "(";

            foreach ($groupMembers as $member) {
                $where .= "$ocolumn[uid] = $member[id] OR ";
            }
            $where = substr($where, 0, strlen($where) - 3) . ')';
        }

        if ($onynumber == 1) {
            $items = DBUtil::selectObjectCount('users', $where);
        } else {
            $items = DBUtil::selectObjectArray('users', $where, $orderby, $inici - 1, $numitems, 'uid');
        }
        return $items;
    }

    /**
     * @author:     Albert Pérez Monfort (aperezm@xtec.cat)
     * @param:	args   Array with the id of the course, the role and the id of the user
     * @return:	True if success
     */
    public function getMoodleUsers($args) {

        extract($args);
        // Security check
        $registres = array();
        // Security check
        if (!SecurityUtil::checkPermission('IWmoodle::', '::', ACCESS_ADMIN)) {
            return LogUtil::registerPermissionError();
        }
        $prefix = MoodleDB::get_prefix();
        $time = time();
        $sql = "SELECT id, username, password, firstname, lastname, email, auth
			FROM {$prefix}user
			WHERE confirmed = 1 AND deleted = 0";
        return MoodleDB::get_records($sql);
    }

    /**
     * Create a new user in table users
     * @author:     Albert Pérez Monfort (aperezm@xtec.cat)
     * @param:	args   user values
     * @return:	True if success and false otherwise
     */
    public function createUser($args) {

        $nom = FormUtil::getPassedValue('nom', isset($args['nom']) ? $args['nom'] : null, 'POST');
        $cognoms = FormUtil::getPassedValue('cognoms', isset($args['cognoms']) ? $args['cognoms'] : null, 'POST');
        $pass = FormUtil::getPassedValue('pass', isset($args['pass']) ? $args['pass'] : null, 'POST');
        $uname = FormUtil::getPassedValue('uname', isset($args['uname']) ? $args['uname'] : null, 'POST');
        $email = FormUtil::getPassedValue('email', isset($args['email']) ? $args['email'] : null, 'POST');

        // Security check
        if (!SecurityUtil::checkPermission('IWusers::', '::', ACCESS_ADMIN)) {
            return LogUtil::registerPermissionError();
        }

        //Needed arguments
        if ($uname == null || $pass == null || $email == null) {
            return LogUtil::registerError($this->__('Error! Could not do what you wanted. Please check your input.'));
        }
        
        // Added support for Moodle 2.6+ hash passwords
        if (strlen($pass) != 60) {
            $pass = '1$$' . $pass;
        }

        $items = array('uname' => $uname,
            'pass' => $pass,
            'email' => $email,
            'activated' => 1,
            'approved_by' => 2,
            'user_regdate' => date("Y-m-d H:i:s", time()));
        $result = DBUtil::insertObject($items, 'users', 'uid');
        if (!$result) {
            return LogUtil::registerError($this->__('Error! Creation attempt failed.'));
        }

        
        /* @aginard: Following there's a hack in order to get users activated and configured. Users 
         * creation system in Zikula 1.3 is complex and non-documented, and we couldn't find the 
         * correct way to get this done
         */
        
        global $ZConfig;

        $dbc = mysqli_connect(  $ZConfig['DBInfo']['databases']['default']['hostmigrate'],
                                $ZConfig['DBInfo']['databases']['default']['user'],
                                $ZConfig['DBInfo']['databases']['default']['password'], 
                                $ZConfig['DBInfo']['databases']['default']['dbname'],
                                $ZConfig['DBInfo']['databases']['default']['portmigrate']);
        $dbc->set_charset('utf8');

        $sqls[] = " UPDATE users 
                    SET email = '$email', 
                        activated = 1,
                        approved_by = 2,
                        user_regdate = '" . date("Y-m-d H:i:s", time()) . "',
                        approved_date = '" . date("Y-m-d H:i:s", time()) . "'
                    WHERE uid = $result[uid]";
        
        if (ModUtil::available('Legal')) {
            $now = new DateTime();
            $sqls[] = "INSERT INTO objectdata_attributes
                            (attribute_name, object_id, object_type, value)
                       VALUES
                            ('_Legal_termsOfUseAccepted', $result[uid], 'users', '" . $now->format(DateTime::ISO8601) . "'),
                            ('_Legal_privacyPolicyAccepted', $result[uid], 'users', '" . $now->format(DateTime::ISO8601) . "'),
                            ('_Legal_agePolicyConfirmed', $result[uid], 'users', '" . $now->format(DateTime::ISO8601) . "')";
        }

        foreach ($sqls as $sql) {
            $res = mysqli_query($dbc, $sql);
        }

        mysqli_close($dbc);

        /*
         * @aginard: End of the hack
         */

        
        //add user to default group
        $defaultgroup = ModUtil::getVar('Groups', 'defaultgroup');
        $items = array('uid' => $result['uid'],
            'gid' => $defaultgroup);
        if (!DBUtil::insertObject($items, 'group_membership')) {
            return LogUtil::registerError($this->__('Error! Creation attempt failed.'));
        }

        $items = array('uid' => $result['uid'],
            'nom' => $nom,
            'cognom1' => $cognoms);

        if (!ModUtil::apiFunc('IWusers', 'admin', 'create', $items)) {
            return LogUtil::registerError($this->__('Error! Creation attempt failed.'));
        }

        // Return the id of the newly created user to the calling process
        return $result['uid'];
    }
}