<?php

require_once('modules/IWmoodle/lib/IWmoodle/MoodleDB.php');

class IWmoodle_Api_User extends Zikula_AbstractApi {

    /**
     * Get the courses where a user is pre-enroled
     * @author:     Albert PÃ©rez Monfort (intraweb@xtec.cat)
     * @param:	id of the user
     * @return:	An array with the courses where the user is pre-enroled
     */
    public function getallpre_ins($args) {

        // Security check
        if (!SecurityUtil::checkPermission('IWmoodle:coursesblock:', "::", ACCESS_READ)) {
            return false;
        }
        $user = $args['user'];
        $pntable = DBUtil::getTables();
        $c = $pntable['IWmoodle_column'];
        $where = "$c[uid] = $user";
        // get the objects from the db
        $items = DBUtil::selectObjectArray('IWmoodle', $where);
        // Check for an error with the database code, and if so set an appropriate
        // error message and return
        if ($items === false) {
            return LogUtil::registerError($this->__('Error! Could not load items.'));
        }
        // Return the items
        return $items;
    }

    /**
     * Delete the pre-inscription of an user
     * @author:     Albert PÃ©rez Monfort (intraweb@xtec.cat)
     * @param:	args   Array with the id of the course, the role and the id of the user
     * @return:	True if successfull or false in other cases
     */
    public function delete_pre($args) {

        // Security check
        if (!SecurityUtil::checkPermission('IWmoodle:coursesblock:', "::", ACCESS_READ)) {
            return false;
        }
        // Argument check 
        if (!isset($args['mid']) || !is_numeric($args['mid'])) {
            return LogUtil::registerError($this->__('Error! Could not do what you wanted. Please check your input.'));
        }
        // Delete item
        if (!DBUtil::deleteObjectByID('IWmoodle', $args['mid'], 'mid')) {
            return LogUtil::registerError($this->__('Error! Sorry! Deletion attempt failed.'));
        }
        // Success
        return true;
    }

    /**
     * Check if a user is enroled in a Moodle course with the same role
     * @author:     Albert PÃ©rez Monfort (intraweb@xtec.cat)
     * @param:	args   Array with the id of the course
     * @return:	Returns true if the user is enroled into the course with the same role or false in other cases
     */
    public function is_enroled($args) {

        // Security check
        if (!SecurityUtil::checkPermission('IWmoodle:coursesblock:', "::", ACCESS_READ)) {
            return false;
        }
        $user = $args['user'];
        $role = $args['role'];
        $course = $args['course'];

        $prefix = MoodleDB::get_prefix();
        $sql = "SELECT count(*) FROM {$prefix}role_assignments ra, {$prefix}context ctx
			WHERE ra.userid = $user AND ra.roleid = $role AND ra.contextid = ctx.id AND ctx.instanceid = $course";
        return MoodleDB::exists($sql);
    }

    /**
     * Checks if a user is a Moodle user
     * @author:     Albert PÃ©rez Monfort (intraweb@xtec.cat)
     * @param:	args   Array with the id of the course, the role and the id of the user
     * @return:	True if is a Moodle user or false in other cases
     */
    public function is_user($args) {
        // Security check
        if (!SecurityUtil::checkPermission('IWmoodle:coursesblock:', "::", ACCESS_READ)) {
            return false;
        }

        $user = $args['user'];
        $prefix = MoodleDB::get_prefix();
        $sql = "SELECT COUNT(*) FROM {$prefix}user WHERE username = '$user'";
        return MoodleDB::exists($sql);
    }

    /**
     * Get the information of a course
     * @author:     Albert PÃ©rez Monfort (intraweb@xtec.cat)
     * @param:	id of the course and role informations of the course
     * @return:	An array with the information of the course and the role
     */
    public function getcourse($args) {

        // Security check
        if (!SecurityUtil::checkPermission('IWmoodle:coursesblock:', "::", ACCESS_READ)) {
            return false;
        }
        $courseid = $args['courseid'];

        $prefix = MoodleDB::get_prefix();
        if (!isset($args['role'])) {
            $sql = "SELECT c.id, fullname, visible, to_char(summary) as summary
				FROM {$prefix}course c WHERE c.id = $courseid";
        } else {
            $role = $args['role'];
            $sql = "SELECT c.id, c.fullname, c.visible, to_char(c.summary) as summary, r.name as rolename
				FROM {$prefix}course c, {$prefix}role r
				WHERE c.id = $courseid AND r.id = $role";
        }
        return MoodleDB::get_record($sql);
    }

    /**
     * Get the identity and other information of a user in Moodle tables
     * @author:     Albert PÃ©rez Monfort (intraweb@xtec.cat)
     * @param:	id of the user in the intranet
     * @return:	The id of the user in Moodle
     */
    public function getuserMDuid($args) {

        // Security check
        if (!SecurityUtil::checkPermission('IWmoodle:coursesblock:', "::", ACCESS_READ)) {
            return false;
        }
        $username = $args['username'];

        $prefix = MoodleDB::get_prefix();
        $sql = "SELECT id, password, auth, mnethostid FROM {$prefix}user WHERE username = '$username'";
        return MoodleDB::get_record($sql);
    }

    /**
     * Get the courses of Moodle where the user is enroled
     * @author:     Albert PÃ©rez Monfort (intraweb@xtec.cat)
     * @param:	id of the user in the intranet
     * @return:	And array with the courses where the user is registered
     */
    public function getusercourses($args) {

        // Security check
        if (!SecurityUtil::checkPermission('IWmoodle:coursesblock:', "::", ACCESS_READ)) {
            return false;
        }

        $user = $args['user'];

        // gets user id from Moodle
        $user_array = ModUtil::apiFunc('IWmoodle', 'user', 'getuserMDuid', array('username' => $user));
        $userid = $user_array['id'];
        $prefix = ModUtil::getVar('IWmoodle', 'dbprefix');

        $prefix = MoodleDB::get_prefix();
        $sql = "SELECT c.id, r.name as rolename, to_char(c.summary) as summary, c.fullname
			FROM {$prefix}course c, {$prefix}context ctx, {$prefix}role_assignments ra , {$prefix}role r
			WHERE ctx.id = ra.contextid
			AND ra.userid = $userid
			AND c.id = ctx.instanceid
			AND  r.id = ra.roleid
			AND c.visible=1
			ORDER BY c.id, c.fullname";
        return MoodleDB::get_records($sql);
    }

    /**
     * Checks if an user is pre-enroled in a course
     * @author:     Albert PÃ©rez Monfort (intraweb@xtec.cat)
     * @param:	args   Array with the id of the course, the role and the id of the user
     * @return:	True if the user is pre-enroled and false in any other case
     */
    public function is_preenroled($args) {

        // Security check
        if (!SecurityUtil::checkPermission('IWmoodle:coursesblock:', "::", ACCESS_READ)) {
            return false;
        }

        $user = $args['user'];
        $course = $args['course'];
        $role = $args['role'];

        $pntable = & DBUtil::getTables();
        $c = $pntable['IWmoodle_column'];
        $where = "$c[uid] = $user AND $c[mcid] = $course	AND $c[role] = $role";
        // get the objects from the db
        $items = DBUtil::selectObjectArray('IWmoodle', $where);
        // Check for an error with the database code, and if so set an appropriate
        // error message and return
        if ($items === false) {
            return LogUtil::registerError($this->__('Error! Could not load items.'));
        }
        if (count($items) > 0) {
            return true;
        } else {
            return false;
        }
    }

}
