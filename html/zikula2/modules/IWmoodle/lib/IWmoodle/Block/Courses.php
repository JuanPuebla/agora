<?php

class IWmoodle_Block_Courses extends Zikula_Controller_AbstractBlock {

    public function init() {
        SecurityUtil::registerPermissionSchema('IWmoodle:coursesblock:', '::');
    }

    public function info() {
        return array('text_type' => 'Courses',
            'module' => 'IWmoodle',
            'text_type_long' => $this->__('Courses available in Moodle'),
            'allow_multiple' => true,
            'form_content' => false,
            'form_refresh' => false,
            'show_preview' => true);
    }

    public function display($row) {
        //Security check
        if (!SecurityUtil::checkPermission('IWmoodle:coursesblock:', "::", ACCESS_READ)) {
            return;
        }
        $uid = UserUtil::getVar('uid');

        if (!UserUtil::isLoggedIn()) {
            return;
        }

        $courses_array = array();
        $course_previous = '';
        $pre_ins = array();

        // Create output object
        $view = Zikula_View::getInstance('IWmoodle', false);
        $uname = UserUtil::getVar('uname');
        //check if the user is Moodle user

        $is_user = ModUtil::apiFunc('IWmoodle', 'user', 'is_user', array('user' => $uname));
        //Inform to system that the intranet user is a Moodle user
        $view->assign('isuser', $is_user);

        if ($is_user) {
            // get user courses
            $courses = ModUtil::apiFunc('IWmoodle', 'user', 'getusercourses', array('user' => $uname));
            if (!empty($courses)) {
                foreach ($courses as $course) {
                    if ($course['fullname'] != $course_previous) {
                        if ($course_previous != '') {
                            $courses_array[] = array('fullname' => $course_previous,
                                'summary' => nl2br($course_previous_summary),
                                'id' => $course_previous_id,
                                'roles' => $course_previous_roles);
                        }
                        $course_previous = $course['fullname'];
                        $course_previous_id = $course['id'];
                        $course_previous_roles = $course['rolename'] . '<br/>';
                        $course_previous_summary = $course['summary'];
                    } else {
                        $course_previous_roles .= $course['rolename'] . '<br/>';
                    }
                }
                $courses_array[] = array('fullname' => $course_previous,
                    'summary' => nl2br($course_previous_summary),
                    'id' => $course_previous_id,
                    'roles' => $course_previous_roles);
            }
        }
        // Security check
        $administrator = (SecurityUtil::checkPermission('IWmoodle::', '::', ACCESS_ADMIN)) ? true : false;
        // assing the courses array to the output
        $view->assign('courses', $courses_array);
        $view->assign('administrator', $administrator);
        $view->assign('moodleurl', ModUtil::getVar('IWmoodle', 'moodleurl'));
        $row['content'] = $view->fetch('iwmoodle_block_display.htm');
        return BlockUtil::themesideblock($row);
    }

}