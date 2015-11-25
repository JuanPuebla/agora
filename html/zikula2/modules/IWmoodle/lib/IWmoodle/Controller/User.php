<?php

class IWmoodle_Controller_User extends Zikula_AbstractController
{

    /**
     * Prepare user to redirect to Moodle
     * @author:     Albert Pï¿œrez Monfort (aperezm@xtec.cat)
     * @return:    Redirect to Moodle
     */
    public function main()
    {
        $viewcourse = FormUtil::getPassedValue('id');
        $location = trim(ModUtil::getVar('IWmoodle', 'moodleurl'));
        $window = ModUtil::getVar('IWmoodle', 'newwindow');
        $guest = ModUtil::getVar('IWmoodle', 'guestuser');

        // Security check
        if (!SecurityUtil::checkPermission('IWmoodle:coursesblock:', '::', ACCESS_READ)) {
            return LogUtil::registerPermissionError();
        }

        //if user is not moodle use, create it
        if (UserUtil::getVar('uname') != '') {
            //check if user is Moodle user
            $is_user = ModUtil::apiFunc('IWmoodle', 'user', 'is_user', array('user' => UserUtil::getVar('uname')));

            if (!$is_user) {
                //if not create it
                $inscribed = ModUtil::apiFunc('IWmoodle', 'admin', 'inscriu');
                $sv = ModUtil::func('IWmain', 'user', 'genSecurityValue');
                ModUtil::func('IWmain', 'user', 'userDelVar', array('name' => 'courses',
                    'module' => 'IWmoodle',
                    'uid' => $uid,
                    'sv' => $sv));
                if ($inscribed) {
                    ModUtil::func('IWmoodle', 'user', 'enrole');
                }
            }
        }

        $username = UserUtil::getVar('uname');
        $prefix = System::getVar('prefix');

        if ($username == '') {
            $username = $guest;
        }

        $secureValue = rand();

        setcookie('gotoMoodle', $secureValue, '0', '/');

        $userpw = UserUtil::getVar('pass');

        $parm = $username;
        $parm .= "|";
        $parm .= $userpw;
        $parm .= "|";
        $parm .= $home;
        $parm .= "|";
        $parm .= $viewcourse;
        $parm .= "|";
        $parm .= $guest;
        $parm .= "|";
        $parm .= md5($secureValue);

        $check = md5($parm);

        $url = "$location/index_iw.php?parm=$parm";

        if ($window == 1) {
            // Open Moodle in a new window
            Header('Location: ' . $url . '&check=' . $check);
            exit;
        }

        // Open Moodle into the the website
        $view = new Zikula_View(ServiceUtil::getManager());
        $view->caching = false;

        $url = $url . '&check=' . $check;

        $view->assign('url', $url);
        return $view->fetch('iwmoodle_user_go.htm');
    }
}